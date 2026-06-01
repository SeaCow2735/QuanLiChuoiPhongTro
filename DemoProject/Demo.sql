USE QuanLyChuoiPhongTro;
 GO
CREATE TABLE KHU_TRO
 (
 MaKhu INT IDENTITY(1,1) PRIMARY KEY,
 TenKhu NVARCHAR(100) NOT NULL,
 DiaChi NVARCHAR(255) NOT NULL,
 SoLuongPhong INT CHECK(SoLuongPhong >= 0)
 );
 GO
-- =========================================
 -- BẢNG PHÒNG
 -- =========================================
CREATE TABLE PHONG
 (
 MaPhong INT IDENTITY(1,1) PRIMARY KEY,
 MaKhu INT NOT NULL,
 TenPhong NVARCHAR(50) NOT NULL,
 GiaPhong DECIMAL(18,2) CHECK(GiaPhong > 0),
 TrangThai NVARCHAR(50) DEFAULT N'Trống',
FOREIGN KEY(MaKhu)
REFERENCES KHU_TRO(MaKhu)
 
);
 GO
-- =========================================
 -- BẢNG KHÁCH THUÊ
 -- =========================================
CREATE TABLE KHACH_THUE
 (
 MaKhach INT IDENTITY(1,1) PRIMARY KEY,
 HoTen NVARCHAR(100) NOT NULL,
 CCCD VARCHAR(12) UNIQUE,
 SDT VARCHAR(15),
 NgaySinh DATE,
 QueQuan NVARCHAR(100)
 );
 GO
-- =========================================
 -- BẢNG HỢP ĐỒNG
 -- =========================================
CREATE TABLE HOP_DONG
 (
 MaHD INT IDENTITY(1,1) PRIMARY KEY,
MaKhach INT NOT NULL,
MaPhong INT NOT NULL,
 
NgayBatDau DATE NOT NULL,
NgayKetThuc DATE NOT NULL,
 
TienCoc DECIMAL(18,2),
 
TrangThai NVARCHAR(50)
DEFAULT N'Đang thuê',
 
FOREIGN KEY(MaKhach)
REFERENCES KHACH_THUE(MaKhach),
 
FOREIGN KEY(MaPhong)
REFERENCES PHONG(MaPhong)
 
);
 GO
-- =========================================
 -- BẢNG CHỈ SỐ ĐIỆN NƯỚC
 -- =========================================
CREATE TABLE CHI_SO_DIEN_NUOC
 (
 MaChiSo INT IDENTITY(1,1) PRIMARY KEY,
MaPhong INT NOT NULL,
 
Thang INT,
Nam INT,
 
DienCu INT,
DienMoi INT,
 
NuocCu INT,
NuocMoi INT,
 
FOREIGN KEY(MaPhong)
REFERENCES PHONG(MaPhong)
 
);
 GO
-- =========================================
 -- BẢNG HÓA ĐƠN
 -- =========================================
CREATE TABLE HOA_DON
 (
 MaHoaDon INT IDENTITY(1,1) PRIMARY KEY,
MaPhong INT NOT NULL,
 
Thang INT,
Nam INT,
 
TienPhong DECIMAL(18,2),
TienDien DECIMAL(18,2),
TienNuoc DECIMAL(18,2),
TienDichVu DECIMAL(18,2),
 
TongTien DECIMAL(18,2),
 
TrangThai NVARCHAR(50)
DEFAULT N'Chưa thanh toán',
 
FOREIGN KEY(MaPhong)
REFERENCES PHONG(MaPhong)
 
);
 GO
-- =========================================
 -- BẢNG THANH TOÁN
 -- =========================================
CREATE TABLE THANH_TOAN
 (
 MaTT INT IDENTITY(1,1) PRIMARY KEY,
MaHoaDon INT NOT NULL,
 
NgayThanhToan DATE,
 
SoTien DECIMAL(18,2),
 
PhuongThuc NVARCHAR(50),
 
FOREIGN KEY(MaHoaDon)
REFERENCES HOA_DON(MaHoaDon)
 
);
 GO

-- =========================================
 -- PROCEDURE THUÊ PHÒNG
 -- GIAO TÁC 1
 -- =========================================
CREATE PROCEDURE SP_ThuePhong
 (
 @MaKhach INT,
 @MaPhong INT,
 @NgayBD DATE,
 @NgayKT DATE,
 @TienCoc DECIMAL(18,2)
 )
 AS
 BEGIN
BEGIN TRY
 
    BEGIN TRANSACTION
 
    IF EXISTS
    (
        SELECT *
        FROM PHONG
        WHERE MaPhong = @MaPhong
        AND TrangThai = N'Đã thuê'
    )
    BEGIN
        RAISERROR(N'Phòng đã được thuê',16,1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
 
    INSERT INTO HOP_DONG
    (
        MaKhach,
        MaPhong,
        NgayBatDau,
        NgayKetThuc,
        TienCoc,
        TrangThai
    )
    VALUES
    (
        @MaKhach,
        @MaPhong,
        @NgayBD,
        @NgayKT,
        @TienCoc,
        N'Đang thuê'
    );
 
    UPDATE PHONG
    SET TrangThai = N'Đã thuê'
    WHERE MaPhong = @MaPhong;
 
    COMMIT TRANSACTION;
 
END TRY
 
BEGIN CATCH
 
    ROLLBACK TRANSACTION;
 
    PRINT ERROR_MESSAGE();
 
END CATCH
 
END;
 GO
-- =========================================
 -- PROCEDURE TRẢ PHÒNG
 -- GIAO TÁC 2
 -- =========================================
CREATE PROCEDURE SP_TraPhong
 (
 @MaHD INT,
 @MaPhong INT
 )
 AS
 BEGIN
BEGIN TRY
 
    BEGIN TRANSACTION
 
    UPDATE HOP_DONG
    SET TrangThai = N'Đã kết thúc'
    WHERE MaHD = @MaHD;
 
    UPDATE PHONG
    SET TrangThai = N'Trống'
    WHERE MaPhong = @MaPhong;
 
    COMMIT TRANSACTION;
 
END TRY
 
BEGIN CATCH
 
    ROLLBACK TRANSACTION;
 
    PRINT ERROR_MESSAGE();
 
END CATCH
 
END;
 GO
-- =========================================
 -- PROCEDURE THANH TOÁN HÓA ĐƠN
 -- GIAO TÁC 3
 -- =========================================
CREATE PROCEDURE SP_ThanhToanHoaDon
 (
 @MaHoaDon INT,
 @SoTien DECIMAL(18,2),
 @PhuongThuc NVARCHAR(50)
 )
 AS
 BEGIN
BEGIN TRY
 
    BEGIN TRANSACTION
 
    INSERT INTO THANH_TOAN
    (
        MaHoaDon,
        NgayThanhToan,
        SoTien,
        PhuongThuc
    )
    VALUES
    (
        @MaHoaDon,
        GETDATE(),
        @SoTien,
        @PhuongThuc
    );
 
    UPDATE HOA_DON
    SET TrangThai = N'Đã thanh toán'
    WHERE MaHoaDon = @MaHoaDon;
 
    COMMIT TRANSACTION;
 
END TRY
 
BEGIN CATCH
 
    ROLLBACK TRANSACTION;
 
    PRINT ERROR_MESSAGE();
 
END CATCH
 
END;
 GO
-- =========================================
 -- PROCEDURE TẠO HÓA ĐƠN
 -- GIAO TÁC 4
 -- =========================================
CREATE PROCEDURE SP_TaoHoaDon
 (
 @MaPhong INT,
 @Thang INT,
 @Nam INT,
 @TienPhong DECIMAL(18,2),
 @TienDien DECIMAL(18,2),
 @TienNuoc DECIMAL(18,2),
 @TienDichVu DECIMAL(18,2)
 )
 AS
 BEGIN
BEGIN TRY
 
    BEGIN TRANSACTION
 
    INSERT INTO HOA_DON
    (
        MaPhong,
        Thang,
        Nam,
        TienPhong,
        TienDien,
        TienNuoc,
        TienDichVu,
        TongTien,
        TrangThai
    )
    VALUES
    (
        @MaPhong,
        @Thang,
        @Nam,
        @TienPhong,
        @TienDien,
        @TienNuoc,
        @TienDichVu,
        @TienPhong + @TienDien + @TienNuoc + @TienDichVu,
        N'Chưa thanh toán'
    );
 
    COMMIT TRANSACTION;
 
END TRY
 
BEGIN CATCH
 
    ROLLBACK TRANSACTION;
 
    PRINT ERROR_MESSAGE();
 
END CATCH
 
END;
 GO
-- =========================================
 -- THỐNG KÊ PHÒNG TRỐNG
 -- =========================================
SELECT *
 FROM VW_PhongTrong;
-- =========================================
 -- THỐNG KÊ KHÁCH ĐANG THUÊ
 -- =========================================
SELECT *
 FROM VW_KhachDangThue;
-- =========================================
 -- THỐNG KÊ DOANH THU THÁNG
 -- =========================================
SELECT
 Thang,
 Nam,
 SUM(TongTien) AS DoanhThu
 FROM HOA_DON
 WHERE TrangThai = N'Đã thanh toán'
 GROUP BY Thang,Nam;
-- =========================================
 -- HÓA ĐƠN CHƯA THANH TOÁN
 -- =========================================
SELECT *
 FROM HOA_DON
 WHERE TrangThai = N'Chưa thanh toán';


-- =====================================
-- DỮ LIỆU KHU TRỌ
-- =====================================

INSERT INTO KHU_TRO(TenKhu, DiaChi, SoLuongPhong)
VALUES
(N'Khu Trọ A', N'Gò Vấp', 5),
(N'Khu Trọ B', N'Quận 12', 5);

-- =====================================
-- DỮ LIỆU PHÒNG
-- =====================================

INSERT INTO PHONG(MaKhu, TenPhong, GiaPhong, TrangThai)
VALUES
(1,N'A101',2500000,N'Trống'),
(1,N'A102',2500000,N'Đã thuê'),
(1,N'A103',2800000,N'Trống'),
(1,N'A104',2800000,N'Đã thuê'),
(1,N'A105',3000000,N'Trống'),

(2,N'B101',2200000,N'Đã thuê'),
(2,N'B102',2200000,N'Trống'),
(2,N'B103',2500000,N'Đã thuê'),
(2,N'B104',2700000,N'Trống'),
(2,N'B105',3000000,N'Trống');

-- =====================================
-- DỮ LIỆU KHÁCH THUÊ
-- =====================================

INSERT INTO KHACH_THUE
(
    HoTen,
    CCCD,
    SDT,
    NgaySinh,
    QueQuan
)
VALUES
(N'Nguyễn Văn An','111111111111','0901111111','2000-01-01',N'Hà Nội'),
(N'Trần Văn Bình','111111111112','0901111112','2000-02-02',N'Đà Nẵng'),
(N'Lê Minh Cường','111111111113','0901111113','2000-03-03',N'Huế'),
(N'Phạm Quốc Dũng','111111111114','0901111114','1999-04-04',N'Cần Thơ'),
(N'Hoàng Anh Khoa','111111111115','0901111115','2001-05-05',N'Đồng Nai'),
(N'Ngô Thành Long','111111111116','0901111116','1998-06-06',N'Bình Dương'),
(N'Đặng Quốc Nam','111111111117','0901111117','1997-07-07',N'Tây Ninh'),
(N'Võ Minh Phúc','111111111118','0901111118','1999-08-08',N'Long An'),
(N'Bùi Gia Huy','111111111119','0901111119','2000-09-09',N'Vũng Tàu'),
(N'Đỗ Nhật Minh','111111111120','0901111120','2001-10-10',N'TP.HCM');

-- =====================================
-- DỮ LIỆU HỢP ĐỒNG
-- =====================================

INSERT INTO HOP_DONG
(
    MaKhach,
    MaPhong,
    NgayBatDau,
    NgayKetThuc,
    TienCoc,
    TrangThai
)
VALUES
(1,2,'2025-01-01','2025-12-31',5000000,N'Đang thuê'),
(2,4,'2025-02-01','2026-01-31',5000000,N'Đang thuê'),
(3,6,'2025-03-01','2026-02-28',4000000,N'Đang thuê'),
(4,8,'2025-04-01','2026-03-31',4500000,N'Đang thuê');

-- =====================================
-- DỮ LIỆU CHỈ SỐ ĐIỆN NƯỚC
-- =====================================

INSERT INTO CHI_SO_DIEN_NUOC
(
    MaPhong,
    Thang,
    Nam,
    DienCu,
    DienMoi,
    NuocCu,
    NuocMoi
)
VALUES
(2,5,2026,100,150,20,25),
(4,5,2026,120,180,25,30),
(6,5,2026,80,130,15,22),
(8,5,2026,150,210,30,38),
(1,5,2026,50,90,10,14),
(3,5,2026,60,110,12,18),
(5,5,2026,70,125,14,20),
(7,5,2026,90,140,16,24),
(9,5,2026,100,170,18,26),
(10,5,2026,110,190,20,29);

-- =====================================
-- DỮ LIỆU HÓA ĐƠN
-- =====================================

INSERT INTO HOA_DON
(
    MaPhong,
    Thang,
    Nam,
    TienPhong,
    TienDien,
    TienNuoc,
    TienDichVu,
    TongTien,
    TrangThai
)
VALUES
(2,5,2026,2500000,175000,100000,50000,2825000,N'Đã thanh toán'),
(4,5,2026,2800000,210000,120000,50000,3180000,N'Đã thanh toán'),
(6,5,2026,2200000,180000,90000,50000,2520000,N'Chưa thanh toán'),
(8,5,2026,2500000,250000,150000,50000,2950000,N'Chưa thanh toán'),
(1,5,2026,2500000,150000,80000,50000,2780000,N'Chưa thanh toán'),
(3,5,2026,2800000,190000,100000,50000,3140000,N'Chưa thanh toán'),
(5,5,2026,3000000,200000,120000,50000,3370000,N'Chưa thanh toán'),
(7,5,2026,2200000,160000,90000,50000,2500000,N'Chưa thanh toán'),
(9,5,2026,2700000,220000,130000,50000,3100000,N'Chưa thanh toán'),
(10,5,2026,3000000,250000,150000,50000,3450000,N'Chưa thanh toán');

-- =====================================
-- DỮ LIỆU THANH TOÁN
-- =====================================

INSERT INTO THANH_TOAN
(
    MaHoaDon,
    NgayThanhToan,
    SoTien,
    PhuongThuc
)
VALUES
(1,'2026-05-10',2825000,N'Tiền mặt'),
(2,'2026-05-12',3180000,N'Chuyển khoản');

INSERT INTO HOP_DONG
(
    MaKhach,
    MaPhong,
    NgayBatDau,
    NgayKetThuc,
    TienCoc,
    TrangThai
)
VALUES
(5,1,'2026-01-01','2026-12-31',5000000,N'Đang thuê'),
(6,3,'2026-01-15','2027-01-14',5000000,N'Đang thuê'),
(7,5,'2026-02-01','2027-01-31',4000000,N'Đang thuê'),
(8,7,'2026-02-10','2027-02-09',4000000,N'Đang thuê'),
(9,9,'2026-03-01','2027-02-28',4500000,N'Đang thuê'),
(10,10,'2026-03-15','2027-03-14',5000000,N'Đang thuê');
UPDATE PHONG
SET TrangThai=N'Đã thuê'
WHERE MaPhong IN (1,2,3,4,5,6,7,8,9,10);


INSERT INTO CHI_SO_DIEN_NUOC
(
    MaPhong,
    Thang,
    Nam,
    DienCu,
    DienMoi,
    NuocCu,
    NuocMoi
)
VALUES
(1,6,2026,90,140,14,18),
(2,6,2026,150,210,25,32),
(3,6,2026,110,170,18,24),
(4,6,2026,180,250,30,38),
(5,6,2026,125,190,20,27),
(6,6,2026,130,195,22,29),
(7,6,2026,140,205,24,31),
(8,6,2026,210,280,38,46),
(9,6,2026,170,240,26,35),
(10,6,2026,190,270,29,39);

INSERT INTO HOA_DON
(
    MaPhong,
    Thang,
    Nam,
    TienPhong,
    TienDien,
    TienNuoc,
    TienDichVu,
    TongTien,
    TrangThai
)
VALUES
(1,6,2026,2500000,175000,100000,50000,2825000,N'Chưa thanh toán'),
(2,6,2026,2500000,210000,120000,50000,2880000,N'Chưa thanh toán'),
(3,6,2026,2800000,190000,100000,50000,3140000,N'Chưa thanh toán'),
(4,6,2026,2800000,250000,150000,50000,3250000,N'Chưa thanh toán'),
(5,6,2026,3000000,200000,120000,50000,3370000,N'Chưa thanh toán'),
(6,6,2026,2200000,180000,90000,50000,2520000,N'Chưa thanh toán'),
(7,6,2026,2200000,170000,100000,50000,2520000,N'Chưa thanh toán'),
(8,6,2026,2500000,260000,150000,50000,2960000,N'Chưa thanh toán'),
(9,6,2026,2700000,220000,130000,50000,3100000,N'Chưa thanh toán'),
(10,6,2026,3000000,250000,150000,50000,3450000,N'Chưa thanh toán');


INSERT INTO THANH_TOAN
(
    MaHoaDon,
    NgayThanhToan,
    SoTien,
    PhuongThuc
)
VALUES
(3,'2026-06-05',2520000,N'Chuyển khoản'),
(4,'2026-06-06',2950000,N'Tiền mặt'),
(5,'2026-06-07',2780000,N'Chuyển khoản'),
(6,'2026-06-08',3140000,N'Momo'),
(7,'2026-06-09',3370000,N'Chuyển khoản');

UPDATE HOA_DON
SET TrangThai=N'Đã thanh toán'
WHERE MaHoaDon IN (3,4,5,6,7);
UPDATE PHONG
SET TrangThai=N'Trống'
WHERE MaPhong IN (1,3,5);



