/*
==================================================
PROJECT : QUAN LY CHUOI PHONG TRO
FILE    : 07_StoredProcedures.sql
AUTHOR  : DBA Team
PURPOSE : Stored Procedure
==================================================
*/

USE QuanLiChuoiPhongTro;
GO

CREATE OR ALTER PROCEDURE SP_ThemKhachThue
(
    @MaKhachThue VARCHAR(10),
    @HoTen NVARCHAR(100),
    @CCCD VARCHAR(12),
    @NgaySinh DATE,
    @SoDienThoai VARCHAR(15),
    @DiaChi NVARCHAR(255),
    @Email VARCHAR(100)
)
AS
BEGIN

SET NOCOUNT ON;

BEGIN TRY

    IF EXISTS
    (
        SELECT 1
        FROM KhachThue
        WHERE CCCD=@CCCD
    )
    BEGIN
        PRINT N'CCCD đã tồn tại';
        RETURN -2;
    END

    INSERT INTO KhachThue
    (
        MaKhachThue,
        HoTen,
        CCCD,
        NgaySinh,
        SoDienThoai,
        DiaChi,
        Email
    )
    VALUES
    (
        @MaKhachThue,
        @HoTen,
        @CCCD,
        @NgaySinh,
        @SoDienThoai,
        @DiaChi,
        @Email
    );

    PRINT N'Thêm khách thuê thành công';

    RETURN 0;

END TRY

BEGIN CATCH

    PRINT ERROR_MESSAGE();

    RETURN -99;

END CATCH

END
GO


CREATE OR ALTER PROCEDURE SP_CapNhatKhachThue
(
    @MaKhachThue VARCHAR(10),
    @HoTen NVARCHAR(100),
    @SoDienThoai VARCHAR(15),
    @DiaChi NVARCHAR(255),
    @Email VARCHAR(100)
)
AS
BEGIN

BEGIN TRY

    IF NOT EXISTS
    (
        SELECT 1
        FROM KhachThue
        WHERE MaKhachThue=@MaKhachThue
    )
    RETURN -1;

    UPDATE KhachThue
    SET
        HoTen=@HoTen,
        SoDienThoai=@SoDienThoai,
        DiaChi=@DiaChi,
        Email=@Email
    WHERE MaKhachThue=@MaKhachThue;

    RETURN 0;

END TRY

BEGIN CATCH

    RETURN -99;

END CATCH

END
GO



CREATE OR ALTER PROCEDURE SP_XoaKhachThue
(
    @MaKhachThue VARCHAR(10)
)
AS
BEGIN

BEGIN TRY

    IF EXISTS
    (
        SELECT 1
        FROM HopDong
        WHERE MaKhachThue=@MaKhachThue
    )
    BEGIN
        PRINT N'Khách thuê còn hợp đồng';
        RETURN -3;
    END

    DELETE FROM KhachThue
    WHERE MaKhachThue=@MaKhachThue;

    RETURN 0;

END TRY

BEGIN CATCH

    RETURN -99;

END CATCH

END
GO


CREATE OR ALTER PROCEDURE SP_XemKhachThue
(
    @MaKhachThue VARCHAR(10)
)
AS
BEGIN

SELECT *
FROM KhachThue
WHERE MaKhachThue=@MaKhachThue;

END
GO



CREATE OR ALTER PROCEDURE SP_ThemPhong
(
    @MaPhong VARCHAR(10),
    @MaKhuTro VARCHAR(10),
    @TenPhong NVARCHAR(50),
    @LoaiPhong NVARCHAR(50),
    @DienTich FLOAT,
    @GiaThue DECIMAL(18,2)
)
AS
BEGIN

BEGIN TRY

    IF @GiaThue<=0
        RETURN -3;

    INSERT INTO Phong
    (
        MaPhong,
        MaKhuTro,
        TenPhong,
        LoaiPhong,
        DienTich,
        GiaThue
    )
    VALUES
    (
        @MaPhong,
        @MaKhuTro,
        @TenPhong,
        @LoaiPhong,
        @DienTich,
        @GiaThue
    );

    RETURN 0;

END TRY

BEGIN CATCH

    RETURN -99;

END CATCH

END
GO



CREATE OR ALTER PROCEDURE SP_CapNhatPhong
(
    @MaPhong VARCHAR(10),
    @GiaThue DECIMAL(18,2),
    @TrangThai NVARCHAR(20)
)
AS
BEGIN

BEGIN TRY

    UPDATE Phong
    SET
        GiaThue=@GiaThue,
        TrangThai=@TrangThai
    WHERE MaPhong=@MaPhong;

    RETURN 0;

END TRY

BEGIN CATCH

    RETURN -99;

END CATCH

END
GO



CREATE OR ALTER PROCEDURE SP_TaoHopDong
(
    @MaHopDong VARCHAR(10),
    @MaNhanVien VARCHAR(10),
    @MaKhachThue VARCHAR(10),
    @MaPhong VARCHAR(10),
    @NgayBatDau DATE,
    @NgayKetThuc DATE,
    @GiaThueThoa DECIMAL(18,2)
)
AS
BEGIN

BEGIN TRY

    IF dbo.fn_KiemTraPhongTrong(@MaPhong)=0
    BEGIN
        PRINT N'Phòng không khả dụng';
        RETURN -3;
    END

    INSERT INTO HopDong
    (
        MaHopDong,
        MaNhanVien,
        MaKhachThue,
        MaPhong,
        NgayBatDau,
        NgayKetThuc,
        GiaThueThoa
    )
    VALUES
    (
        @MaHopDong,
        @MaNhanVien,
        @MaKhachThue,
        @MaPhong,
        @NgayBatDau,
        @NgayKetThuc,
        @GiaThueThoa
    );

    RETURN 0;

END TRY

BEGIN CATCH

    RETURN -99;

END CATCH

END
GO



CREATE OR ALTER PROCEDURE SP_XemHopDong
(
    @MaHopDong VARCHAR(10)
)
AS
BEGIN

SELECT *
FROM HopDong
WHERE MaHopDong=@MaHopDong;

END
GO



CREATE OR ALTER PROCEDURE SP_TaoHoaDon
(
    @MaHoaDon VARCHAR(10),
    @MaHopDong VARCHAR(10),
    @MaNhanVien VARCHAR(10),
    @Thang INT,
    @Nam INT,
    @TienPhong DECIMAL(18,2),
    @TienDichVu DECIMAL(18,2),
    @HanThanhToan DATE
)
AS
BEGIN

BEGIN TRY

    INSERT INTO HoaDon
    (
        MaHoaDon,
        MaHopDong,
        MaNhanVien,
        ThangHoaDon,
        NamHoaDon,
        TienPhong,
        TienDichVu,
        TongTien,
        TrangThai,
        HanThanhToan
    )
    VALUES
    (
        @MaHoaDon,
        @MaHopDong,
        @MaNhanVien,
        @Thang,
        @Nam,
        @TienPhong,
        @TienDichVu,
        dbo.fn_TinhTongTienHoaDon
        (
            @TienPhong,
            @TienDichVu
        ),
        N'Chưa thanh toán',
        @HanThanhToan
    );

    RETURN 0;

END TRY

BEGIN CATCH

    RETURN -99;

END CATCH

END
GO



CREATE OR ALTER PROCEDURE SP_ThanhToanHoaDon
(
    @MaThanhToan VARCHAR(10),
    @MaHoaDon VARCHAR(10),
    @MaNhanVien VARCHAR(10),
    @PhuongThucThanhToan NVARCHAR(50)
)
AS
BEGIN

BEGIN TRY

    DECLARE @TongTien DECIMAL(18,2);

    SELECT
        @TongTien=TongTien
    FROM HoaDon
    WHERE MaHoaDon=@MaHoaDon;

    INSERT INTO ThanhToan
    (
        MaThanhToan,
        MaHoaDon,
        MaNhanVien,
        SoTienThanhToan,
        PhuongThucThanhToan
    )
    VALUES
    (
        @MaThanhToan,
        @MaHoaDon,
        @MaNhanVien,
        @TongTien,
        @PhuongThucThanhToan
    );

    UPDATE HoaDon
    SET TrangThai=N'Đã thanh toán'
    WHERE MaHoaDon=@MaHoaDon;

    RETURN 0;

END TRY

BEGIN CATCH

    RETURN -99;

END CATCH

END
GO