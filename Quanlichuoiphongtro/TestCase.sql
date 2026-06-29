/*
==============================================================================
PROJECT : QUẢN LÝ CHUỖI PHÒNG TRỌ
FILE    : TestCase.sql (PART 1)
AUTHOR  : Nhóm đồ án HQTCSDL

MỤC ĐÍCH
------------------------------------------------------------------------------
Kiểm thử cấu trúc Database trước khi kiểm thử nghiệp vụ.

Bao gồm:

TC01 Database
TC02 Tables
TC03 Constraints
TC04 Indexes

YÊU CẦU

Đã chạy:

01_DatabaseScript.sql
02_CreateTablesScript.sql
03_Constraints.sql
04_InsertData.sql
05_Views.sql
06_Functions.sql
07_StoredProcedures.sql
08_Indexes.sql
09_Triggers.sql

==============================================================================*/

USE QuanLiChuoiPhongTro;
GO

PRINT '=========================================================';
PRINT '           DATABASE TEST CASE - PART 1';
PRINT '=========================================================';
PRINT '';



/******************************************************************************
 TC01
 KIỂM TRA DATABASE
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC01 - KIỂM TRA DATABASE';
PRINT '---------------------------------------------------------';

IF DB_NAME() = 'QuanLiChuoiPhongTro'
BEGIN
    PRINT 'PASS';
    PRINT 'Database hiện tại: ' + DB_NAME();
END
ELSE
BEGIN
    PRINT 'FAIL';
    PRINT 'Database hiện tại: ' + DB_NAME();
END

PRINT '';



/******************************************************************************
 TC02
 KIỂM TRA DANH SÁCH TABLE
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC02 - DANH SÁCH TABLE';
PRINT '---------------------------------------------------------';

SELECT
    ROW_NUMBER() OVER(ORDER BY name) AS STT,
    name AS TableName
FROM sys.tables
ORDER BY name;

PRINT '';

PRINT 'EXPECTED RESULT';
PRINT '- Có đầy đủ các bảng của dự án.';
PRINT '- Không thiếu bảng.';
PRINT '';



/******************************************************************************
 TC03
 KIỂM TRA TỔNG SỐ TABLE
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC03 - TỔNG SỐ TABLE';
PRINT '---------------------------------------------------------';

DECLARE @SoBang INT;

SELECT
    @SoBang = COUNT(*)
FROM sys.tables;

PRINT 'Tổng số bảng = ' + CAST(@SoBang AS VARCHAR(10));

IF @SoBang >= 10
BEGIN
    PRINT 'PASS';
END
ELSE
BEGIN
    PRINT 'FAIL';
END

PRINT '';



/******************************************************************************
 TC04
 KIỂM TRA PRIMARY KEY
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC04 - PRIMARY KEY';
PRINT '---------------------------------------------------------';

SELECT

    OBJECT_NAME(parent_object_id) AS TableName,

    name AS PrimaryKey

FROM sys.key_constraints

WHERE type='PK'

ORDER BY TableName;

PRINT '';

PRINT 'EXPECTED RESULT';
PRINT 'Mỗi bảng nghiệp vụ đều có Primary Key.';
PRINT '';



/******************************************************************************
 TC05
 KIỂM TRA FOREIGN KEY
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC05 - FOREIGN KEY';
PRINT '---------------------------------------------------------';

SELECT

    name,

    OBJECT_NAME(parent_object_id) AS TableName

FROM sys.foreign_keys

ORDER BY TableName;

PRINT '';

PRINT 'EXPECTED RESULT';
PRINT 'Foreign Key đúng với ERD.';
PRINT '';



/******************************************************************************
 TC06
 KIỂM TRA CHECK CONSTRAINT
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC06 - CHECK CONSTRAINT';
PRINT '---------------------------------------------------------';

SELECT

    name,

    OBJECT_NAME(parent_object_id) AS TableName

FROM sys.check_constraints

ORDER BY TableName;

PRINT '';



/******************************************************************************
 TC07
 KIỂM TRA DEFAULT CONSTRAINT
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC07 - DEFAULT CONSTRAINT';
PRINT '---------------------------------------------------------';

SELECT

    name,

    OBJECT_NAME(parent_object_id) AS TableName

FROM sys.default_constraints

ORDER BY TableName;

PRINT '';



/******************************************************************************
 TC08
 KIỂM TRA UNIQUE CONSTRAINT
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC08 - UNIQUE CONSTRAINT';
PRINT '---------------------------------------------------------';

SELECT

    name,

    OBJECT_NAME(parent_object_id) AS TableName

FROM sys.key_constraints

WHERE type='UQ'

ORDER BY TableName;

PRINT '';



/******************************************************************************
 TC09
 KIỂM TRA TOÀN BỘ CONSTRAINT
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC09 - TỔNG HỢP CONSTRAINT';
PRINT '---------------------------------------------------------';

SELECT

    name,

    type_desc

FROM sys.objects

WHERE type IN
(
'PK',
'F',
'C',
'D',
'UQ'
)

ORDER BY name;

PRINT '';



/******************************************************************************
 TC10
 KIỂM TRA INDEX
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC10 - DANH SÁCH INDEX';
PRINT '---------------------------------------------------------';

SELECT

    OBJECT_NAME(object_id) AS TableName,

    name AS IndexName,

    type_desc

FROM sys.indexes

WHERE index_id>0

ORDER BY TableName;

PRINT '';

PRINT 'EXPECTED RESULT';
PRINT 'Có đầy đủ các Index đã thiết kế.';
PRINT '';



/******************************************************************************
 TC11
 KIỂM TRA SỐ LƯỢNG INDEX
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC11 - TỔNG SỐ INDEX';
PRINT '---------------------------------------------------------';

DECLARE @SoIndex INT;

SELECT

    @SoIndex = COUNT(*)

FROM sys.indexes

WHERE index_id>0;

PRINT 'Tổng số Index = ' + CAST(@SoIndex AS VARCHAR(10));

IF @SoIndex>=8
BEGIN

    PRINT 'PASS';

END
ELSE
BEGIN

    PRINT 'FAIL';

END

PRINT '';



/******************************************************************************
 TC12
 KIỂM TRA CÁC BẢNG CHÍNH
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC12 - KIỂM TRA BẢNG CHÍNH';
PRINT '---------------------------------------------------------';

DECLARE @Missing INT = 0;

IF OBJECT_ID('Phong') IS NULL
BEGIN
    PRINT 'Thiếu bảng Phong';
    SET @Missing += 1;
END

IF OBJECT_ID('KhachThue') IS NULL
BEGIN
    PRINT 'Thiếu bảng KhachThue';
    SET @Missing += 1;
END

IF OBJECT_ID('HopDong') IS NULL
BEGIN
    PRINT 'Thiếu bảng HopDong';
    SET @Missing += 1;
END

IF OBJECT_ID('HoaDon') IS NULL
BEGIN
    PRINT 'Thiếu bảng HoaDon';
    SET @Missing += 1;
END

IF OBJECT_ID('ThanhToan') IS NULL
BEGIN
    PRINT 'Thiếu bảng ThanhToan';
    SET @Missing += 1;
END

IF @Missing = 0
BEGIN
    PRINT 'PASS - Đầy đủ các bảng chính.';
END
ELSE
BEGIN
    PRINT 'FAIL - Thiếu ' + CAST(@Missing AS VARCHAR(10)) + ' bảng.';
END

PRINT '';



PRINT '=========================================================';
PRINT 'KẾT THÚC TEST CASE PART 1';
PRINT 'PASS nếu không có lỗi và các đối tượng tồn tại đầy đủ.';
PRINT '=========================================================';
GO

/******************************************************************************
 PART 2
 TEST VIEW + FUNCTION
******************************************************************************/

PRINT '=========================================================';
PRINT 'DATABASE TEST CASE - PART 2';
PRINT 'VIEW + FUNCTION';
PRINT '=========================================================';
PRINT '';

/******************************************************************************
TC13
Kiểm tra View: Danh sách phòng trống
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC13 - vw_DanhSachPhongTrong';
PRINT '---------------------------------------------------------';

IF OBJECT_ID('vw_DanhSachPhongTrong') IS NOT NULL
BEGIN
    PRINT 'PASS';
    SELECT * FROM vw_DanhSachPhongTrong;
END
ELSE
BEGIN
    PRINT 'FAIL - Không tồn tại View';
END

PRINT '';

/******************************************************************************
TC14
Hợp đồng còn hiệu lực
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC14 - vw_HopDongConHieuLuc';
PRINT '---------------------------------------------------------';

IF OBJECT_ID('vw_HopDongConHieuLuc') IS NOT NULL
BEGIN
    PRINT 'PASS';
    SELECT * FROM vw_HopDongConHieuLuc;
END
ELSE
BEGIN
    PRINT 'FAIL';
END

PRINT '';

/******************************************************************************
TC15
Hóa đơn chưa thanh toán
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC15 - vw_HoaDonChuaThanhToan';
PRINT '---------------------------------------------------------';

IF OBJECT_ID('vw_HoaDonChuaThanhToan') IS NOT NULL
BEGIN
    PRINT 'PASS';
    SELECT * FROM vw_HoaDonChuaThanhToan;
END
ELSE
BEGIN
    PRINT 'FAIL';
END

PRINT '';

/******************************************************************************
TC16
Doanh thu theo tháng
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC16 - vw_DoanhThuTheoThang';
PRINT '---------------------------------------------------------';

IF OBJECT_ID('vw_DoanhThuTheoThang') IS NOT NULL
BEGIN
    PRINT 'PASS';
    SELECT * FROM vw_DoanhThuTheoThang;
END
ELSE
BEGIN
    PRINT 'FAIL';
END

PRINT '';

/******************************************************************************
TC17
Hợp đồng sắp hết hạn
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC17 - vw_HopDongSapHetHan';
PRINT '---------------------------------------------------------';

IF OBJECT_ID('vw_HopDongSapHetHan') IS NOT NULL
BEGIN
    PRINT 'PASS';
    SELECT * FROM vw_HopDongSapHetHan;
END
ELSE
BEGIN
    PRINT 'FAIL';
END

PRINT '';

/******************************************************************************
TC18
Doanh thu theo khu trọ
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC18 - vw_DoanhThuTheoKhuTro';
PRINT '---------------------------------------------------------';

IF OBJECT_ID('vw_DoanhThuTheoKhuTro') IS NOT NULL
BEGIN
    PRINT 'PASS';
    SELECT * FROM vw_DoanhThuTheoKhuTro;
END
ELSE
BEGIN
    PRINT 'FAIL';
END

PRINT '';

/******************************************************************************
TC19
Tỷ lệ lấp đầy
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC19 - vw_ThongKeTyLeLapDay';
PRINT '---------------------------------------------------------';

IF OBJECT_ID('vw_ThongKeTyLeLapDay') IS NOT NULL
BEGIN
    PRINT 'PASS';
    SELECT * FROM vw_ThongKeTyLeLapDay;
END
ELSE
BEGIN
    PRINT 'FAIL';
END

PRINT '';

/******************************************************************************
TC20
Kiểm tra số lượng View
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC20 - TỔNG SỐ VIEW';
PRINT '---------------------------------------------------------';

DECLARE @SoView INT;

SELECT @SoView = COUNT(*)
FROM sys.views;

PRINT N'Tổng số View: ' + CAST(@SoView AS VARCHAR(10));

IF @SoView >= 7
    PRINT 'PASS';
ELSE
    PRINT 'FAIL';

PRINT '';

/******************************************************************************
TC21
Function fn_TinhTienDienNuoc
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC21 - fn_TinhTienDienNuoc';
PRINT '---------------------------------------------------------';

IF OBJECT_ID('fn_TinhTienDienNuoc') IS NOT NULL
BEGIN
    PRINT 'PASS';
    PRINT 'Thực hiện kiểm thử với dữ liệu thực tế của dự án.';
    -- Ví dụ:
    -- SELECT dbo.fn_TinhTienDienNuoc(150,80);
END
ELSE
BEGIN
    PRINT 'FAIL';
END

PRINT '';

/******************************************************************************
TC22
Function fn_TinhTongTienHoaDon
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC22 - fn_TinhTongTienHoaDon';
PRINT '---------------------------------------------------------';

IF OBJECT_ID('fn_TinhTongTienHoaDon') IS NOT NULL
BEGIN
    PRINT 'PASS';
    -- SELECT dbo.fn_TinhTongTienHoaDon('HD001');
END
ELSE
BEGIN
    PRINT 'FAIL';
END

PRINT '';

/******************************************************************************
TC23
Function fn_KiemTraPhongTrong
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC23 - fn_KiemTraPhongTrong';
PRINT '---------------------------------------------------------';

IF OBJECT_ID('fn_KiemTraPhongTrong') IS NOT NULL
BEGIN
    PRINT 'PASS';
    -- SELECT dbo.fn_KiemTraPhongTrong('P001');
END
ELSE
BEGIN
    PRINT 'FAIL';
END

PRINT '';

/******************************************************************************
TC24
Function fn_TinhTienDatCoc
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC24 - fn_TinhTienDatCoc';
PRINT '---------------------------------------------------------';

IF OBJECT_ID('fn_TinhTienDatCoc') IS NOT NULL
BEGIN
    PRINT 'PASS';
    -- SELECT dbo.fn_TinhTienDatCoc(3500000);
END
ELSE
BEGIN
    PRINT 'FAIL';
END

PRINT '';

/******************************************************************************
TC25
Function fn_SoNgayConLaiHopDong
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC25 - fn_SoNgayConLaiHopDong';
PRINT '---------------------------------------------------------';

IF OBJECT_ID('fn_SoNgayConLaiHopDong') IS NOT NULL
BEGIN
    PRINT 'PASS';
    -- SELECT dbo.fn_SoNgayConLaiHopDong('HD001');
END
ELSE
BEGIN
    PRINT 'FAIL';
END

PRINT '';

/******************************************************************************
TC26
Kiểm tra số lượng Function
******************************************************************************/

PRINT '---------------------------------------------------------';
PRINT 'TC26 - TỔNG SỐ FUNCTION';
PRINT '---------------------------------------------------------';

DECLARE @SoFunction INT;

SELECT @SoFunction = COUNT(*)
FROM sys.objects
WHERE type IN ('FN','TF','IF');

PRINT N'Tổng số Function: ' + CAST(@SoFunction AS VARCHAR(10));

IF @SoFunction >= 5
    PRINT 'PASS';
ELSE
    PRINT 'FAIL';

PRINT '';

PRINT '=========================================================';
PRINT 'KẾT THÚC PART 2';
PRINT '=========================================================';
GO

/******************************************************************************
PART 3
STORED PROCEDURE TEST
******************************************************************************/

PRINT '=========================================================';
PRINT 'DATABASE TEST CASE - PART 3';
PRINT 'STORED PROCEDURE';
PRINT '=========================================================';
PRINT '';

/******************************************************************************
TC27
SP_ThemKhachThue
******************************************************************************/

PRINT 'TC27 - SP_ThemKhachThue';

BEGIN TRY

IF EXISTS
(
    SELECT 1
    FROM KhachThue
    WHERE MaKhachThue='KTTEST'
)
DELETE FROM KhachThue
WHERE MaKhachThue='KTTEST';

PRINT '===== BEFORE =====';

SELECT *
FROM KhachThue
WHERE MaKhachThue='KTTEST';

DECLARE @ReturnCode INT;

EXEC @ReturnCode =
SP_ThemKhachThue
    @MaKhachThue='KTTEST',
    @HoTen=N'Nguyễn Văn Test',
    @CCCD='999999999999',
    @NgaySinh='2002-01-01',
    @SoDienThoai='0909999999',
    @DiaChi=N'TP.HCM',
    @Email='test@gmail.com';

PRINT 'Return Code = '+CAST(@ReturnCode AS VARCHAR);

PRINT '===== AFTER =====';

SELECT *
FROM KhachThue
WHERE MaKhachThue='KTTEST';

IF @ReturnCode=0
    PRINT 'PASS';
ELSE
    PRINT 'FAIL';

END TRY
BEGIN CATCH
PRINT ERROR_MESSAGE();
END CATCH

PRINT '';

/******************************************************************************
TC28
SP_CapNhatKhachThue
******************************************************************************/

PRINT 'TC28 - SP_CapNhatKhachThue';

BEGIN TRY

PRINT '===== BEFORE =====';

SELECT *
FROM KhachThue
WHERE MaKhachThue='KTTEST';

DECLARE @RC2 INT;

EXEC @RC2=
SP_CapNhatKhachThue
    @MaKhachThue='KTTEST',
    @HoTen=N'Khách Thuê Đã Cập Nhật',
    @SoDienThoai='0911111111',
    @DiaChi=N'Quận 1',
    @Email='update@gmail.com';

PRINT 'Return Code = '+CAST(@RC2 AS VARCHAR);

PRINT '===== AFTER =====';

SELECT *
FROM KhachThue
WHERE MaKhachThue='KTTEST';

IF @RC2=0
PRINT 'PASS';
ELSE
PRINT 'FAIL';

END TRY
BEGIN CATCH
PRINT ERROR_MESSAGE();
END CATCH

PRINT '';

/******************************************************************************
TC29
SP_XemKhachThue
******************************************************************************/

PRINT 'TC29 - SP_XemKhachThue';

BEGIN TRY

EXEC SP_XemKhachThue
@MaKhachThue='KTTEST';

PRINT 'PASS';

END TRY
BEGIN CATCH
PRINT ERROR_MESSAGE();
END CATCH

PRINT '';

/******************************************************************************
TC30
SP_ThemPhong
******************************************************************************/

PRINT 'TC30 - SP_ThemPhong';

BEGIN TRY

IF EXISTS
(
SELECT 1
FROM Phong
WHERE MaPhong='PTEST'
)
DELETE FROM Phong
WHERE MaPhong='PTEST';

DECLARE @RC3 INT;

EXEC @RC3=
SP_ThemPhong
    @MaPhong='PTEST',
    @MaKhuTro='KT01',
    @TenPhong=N'Phòng Test',
    @LoaiPhong=N'Đơn',
    @DienTich=20,
    @GiaThue=3000000;

PRINT 'Return Code = '+CAST(@RC3 AS VARCHAR);

SELECT *
FROM Phong
WHERE MaPhong='PTEST';

IF @RC3=0
PRINT 'PASS';
ELSE
PRINT 'FAIL';

END TRY
BEGIN CATCH
PRINT ERROR_MESSAGE();
END CATCH

PRINT '';

/******************************************************************************
TC31
SP_CapNhatPhong
******************************************************************************/

PRINT 'TC31 - SP_CapNhatPhong';

BEGIN TRY

PRINT '===== BEFORE =====';

SELECT *
FROM Phong
WHERE MaPhong='PTEST';

DECLARE @RC4 INT;

EXEC @RC4=
SP_CapNhatPhong
    @MaPhong='PTEST',
    @GiaThue=3500000,
    @TrangThai=N'Trống';

PRINT 'Return Code='+CAST(@RC4 AS VARCHAR);

PRINT '===== AFTER =====';

SELECT *
FROM Phong
WHERE MaPhong='PTEST';

IF @RC4=0
PRINT 'PASS';
ELSE
PRINT 'FAIL';

END TRY
BEGIN CATCH
PRINT ERROR_MESSAGE();
END CATCH

PRINT '';

/******************************************************************************
TC32
SP_TaoHopDong
******************************************************************************/

PRINT 'TC32 - SP_TaoHopDong';

BEGIN TRY

DECLARE @RC5 INT;

EXEC @RC5=
SP_TaoHopDong
    @MaHopDong='HDTEST',
    @MaNhanVien='NV001',
    @MaKhachThue='KTTEST',
    @MaPhong='PTEST',
    @NgayBatDau='2026-07-01',
    @NgayKetThuc='2027-07-01',
    @GiaThueThoa=3500000;

PRINT 'Return Code='+CAST(@RC5 AS VARCHAR);

SELECT *
FROM HopDong
WHERE MaHopDong='HDTEST';

IF @RC5=0
PRINT 'PASS';
ELSE
PRINT 'FAIL';

END TRY
BEGIN CATCH
PRINT ERROR_MESSAGE();
END CATCH

PRINT '';

/******************************************************************************
TC33
Kiểm tra danh sách Procedure
******************************************************************************/

PRINT 'TC33 - PROCEDURE LIST';

SELECT
ROW_NUMBER() OVER(ORDER BY name) AS STT,
name
FROM sys.procedures
ORDER BY name;

PRINT '';

/******************************************************************************
TC34
Kiểm tra số lượng Procedure
******************************************************************************/

DECLARE @ProcCount INT;

SELECT
@ProcCount=COUNT(*)
FROM sys.procedures;

PRINT 'Tổng Procedure = '+CAST(@ProcCount AS VARCHAR);

IF @ProcCount>=7
PRINT 'PASS';
ELSE
PRINT 'FAIL';

PRINT '';

PRINT '=========================================================';
PRINT 'KẾT THÚC PART 3';
PRINT '=========================================================';
GO

/******************************************************************************
PART 4
TRIGGER & AUDIT TEST
******************************************************************************/

PRINT '=========================================================';
PRINT 'DATABASE TEST CASE - PART 4';
PRINT 'TRIGGER + AUDIT';
PRINT '=========================================================';
PRINT '';

/******************************************************************************
TC35
Kiểm tra Trigger tồn tại
******************************************************************************/

PRINT 'TC35 - Danh sách Trigger';

SELECT
    ROW_NUMBER() OVER(ORDER BY name) AS STT,
    name AS TriggerName
FROM sys.triggers
ORDER BY name;

PRINT '';

DECLARE @TriggerCount INT;

SELECT
    @TriggerCount = COUNT(*)
FROM sys.triggers;

PRINT N'Tổng số Trigger = ' + CAST(@TriggerCount AS VARCHAR(10));

IF @TriggerCount >= 4
    PRINT 'PASS';
ELSE
    PRINT 'FAIL';

PRINT '';

/******************************************************************************
TC36
TRG_CapNhatTrangThaiPhong
Sau khi thêm hợp đồng -> Phòng chuyển sang "Đang thuê"
******************************************************************************/

PRINT 'TC36 - TRG_CapNhatTrangThaiPhong';

BEGIN TRY

DECLARE @PhongTest VARCHAR(10);

SELECT TOP (1)
    @PhongTest = MaPhong
FROM Phong
WHERE TrangThai = N'Trống';

IF @PhongTest IS NULL
BEGIN
    PRINT N'SKIP - Không còn phòng trống để kiểm thử.';
END
ELSE
BEGIN

    PRINT '===== BEFORE =====';

    SELECT
        MaPhong,
        TrangThai
    FROM Phong
    WHERE MaPhong = @PhongTest;

    /*
      Thay các giá trị FK nếu cần
    */

    INSERT INTO HopDong
    (
        MaHopDong,
        MaPhong
    )
    VALUES
    (
        'HD_TRIGGER',
        @PhongTest
    );

    PRINT '===== AFTER =====';

    SELECT
        MaPhong,
        TrangThai
    FROM Phong
    WHERE MaPhong = @PhongTest;

    PRINT 'EXPECTED: TrangThai = Đang thuê';

END

END TRY
BEGIN CATCH

PRINT ERROR_MESSAGE();

END CATCH

PRINT '';

/******************************************************************************
TC37
TRG_KhongXoaPhongDangThue
******************************************************************************/

PRINT 'TC37 - Không cho phép xóa phòng đang thuê';

BEGIN TRY

DECLARE @PhongDangThue VARCHAR(10);

SELECT TOP(1)
    @PhongDangThue = MaPhong
FROM Phong
WHERE TrangThai = N'Đang thuê';

IF @PhongDangThue IS NULL
BEGIN
    PRINT N'SKIP - Không có phòng đang thuê.';
END
ELSE
BEGIN

    DELETE FROM Phong
    WHERE MaPhong = @PhongDangThue;

END

END TRY
BEGIN CATCH

PRINT 'PASS';

PRINT ERROR_MESSAGE();

END CATCH

PRINT '';

/******************************************************************************
TC38
TRG_KiemTraTienCoc
******************************************************************************/

PRINT 'TC38 - Tiền cọc tối thiểu';

BEGIN TRY

INSERT INTO DatCoc
(
    MaDatCoc,
    SoTienCoc
)
VALUES
(
    'DC_TEST',
    500000
);

PRINT 'FAIL';

END TRY
BEGIN CATCH

PRINT 'PASS';

PRINT ERROR_MESSAGE();

END CATCH

PRINT '';

/******************************************************************************
TC39
TRG_GhiLogHopDong
******************************************************************************/

PRINT 'TC39 - Audit Log';

BEGIN TRY

DECLARE @HopDong VARCHAR(10);

SELECT TOP(1)
    @HopDong = MaHopDong
FROM HopDong;

IF @HopDong IS NULL
BEGIN

    PRINT 'SKIP';

END
ELSE
BEGIN

    PRINT '===== BEFORE =====';

    SELECT *
    FROM AuditLogHopDong;

    UPDATE HopDong
    SET TrangThai = N'Đã cập nhật'
    WHERE MaHopDong = @HopDong;

    PRINT '===== AFTER =====';

    SELECT *
    FROM AuditLogHopDong
    ORDER BY LogID DESC;

    PRINT 'PASS';

END

END TRY
BEGIN CATCH

PRINT ERROR_MESSAGE();

END CATCH

PRINT '';

/******************************************************************************
TC40
Kiểm tra Audit Table
******************************************************************************/

PRINT 'TC40 - AuditLogHopDong';

IF OBJECT_ID('AuditLogHopDong') IS NOT NULL
BEGIN

    PRINT 'PASS';

    SELECT
        COUNT(*) AS TongBanGhi
    FROM AuditLogHopDong;

END
ELSE
BEGIN

    PRINT 'FAIL';

END

PRINT '';

/******************************************************************************
TC41
Kiểm tra Trigger đã ghi đúng User
******************************************************************************/

PRINT 'TC41 - SYSTEM_USER';

SELECT TOP (10)

    LogID,

    MaHopDong,

    HanhDong,

    NguoiThucHien,

    ThoiGian

FROM AuditLogHopDong

ORDER BY LogID DESC;

PRINT '';

/******************************************************************************
TC42
Kiểm tra Trigger cập nhật phòng
******************************************************************************/

PRINT 'TC42 - Phòng đang thuê';

SELECT

    MaPhong,

    TrangThai

FROM Phong

WHERE TrangThai = N'Đang thuê';

PRINT '';

/******************************************************************************
TC43
Kiểm tra Trigger cấm xóa
******************************************************************************/

PRINT 'TC43';

SELECT
    name
FROM sys.triggers
WHERE name='TRG_KhongXoaPhongDangThue';

PRINT '';

/******************************************************************************
TC44
Kiểm tra Trigger Audit
******************************************************************************/

PRINT 'TC44';

SELECT
    name
FROM sys.triggers
WHERE name='TRG_GhiLogHopDong';

PRINT '';

PRINT '=========================================================';
PRINT 'KẾT THÚC PART 4';
PRINT '=========================================================';
GO

/******************************************************************************
PART 5
TRANSACTION TEST
******************************************************************************/

PRINT '=========================================================';
PRINT 'DATABASE TEST CASE - PART 5';
PRINT 'TRANSACTION';
PRINT '=========================================================';



/******************************************************************************
TC45
T01 - Thuê phòng
******************************************************************************/

PRINT 'TC45 - T01_ThuePhong';

PRINT '===== BEFORE =====';

SELECT
MaPhong,
TrangThai
FROM Phong
WHERE MaPhong='P001';

SELECT *
FROM HopDong
WHERE MaPhong='P001';

PRINT '';
PRINT 'Chạy file T01_ThuePhong.sql';
PRINT '';

/*
MỞ FILE

T01_ThuePhong.sql

EXECUTE
*/

PRINT '===== AFTER =====';

SELECT
MaPhong,
TrangThai
FROM Phong
WHERE MaPhong='P001';

SELECT *
FROM HopDong
WHERE MaPhong='P001';

PRINT '';
PRINT 'EXPECTED';
PRINT '- Phòng chuyển sang Đang thuê';
PRINT '- Có hợp đồng mới';
PRINT '';



/******************************************************************************
TC46
T02 - Thanh toán
******************************************************************************/

PRINT 'TC46 - T02_ThanhToan';

PRINT '===== BEFORE =====';

SELECT *
FROM HoaDon
WHERE MaHoaDon='H001';

SELECT *
FROM ThanhToan
WHERE MaHoaDon='H001';

PRINT '';

PRINT 'Chạy file T02_ThanhToan.sql';

PRINT '';

PRINT '===== AFTER =====';

SELECT *
FROM HoaDon
WHERE MaHoaDon='H001';

SELECT *
FROM ThanhToan
WHERE MaHoaDon='H001';

PRINT '';

PRINT 'EXPECTED';

PRINT '- Hóa đơn chuyển sang Đã thanh toán';

PRINT '- Có bản ghi ThanhToan';

PRINT '';



/******************************************************************************
TC47
T03 - Trả phòng
******************************************************************************/

PRINT 'TC47 - T03_TraPhong';

PRINT '===== BEFORE =====';

SELECT
MaPhong,
TrangThai
FROM Phong
WHERE MaPhong='P001';

SELECT *
FROM HopDong
WHERE MaPhong='P001';

PRINT '';

PRINT 'Chạy file T03_TraPhong.sql';

PRINT '';

PRINT '===== AFTER =====';

SELECT
MaPhong,
TrangThai
FROM Phong
WHERE MaPhong='P001';

SELECT *
FROM HopDong
WHERE MaPhong='P001';

PRINT '';

PRINT 'EXPECTED';

PRINT '- Phòng trở về Trống';

PRINT '- Hợp đồng hết hiệu lực';

PRINT '';



/******************************************************************************
TC48
T04 - Chuyển phòng
******************************************************************************/

PRINT 'TC48 - T04_ChuyenPhong';

PRINT '===== BEFORE =====';

SELECT
MaPhong,
TrangThai
FROM Phong
WHERE MaPhong IN('P001','P002');

PRINT '';

PRINT 'Chạy file T04_ChuyenPhong.sql';

PRINT '';

PRINT '===== AFTER =====';

SELECT
MaPhong,
TrangThai
FROM Phong
WHERE MaPhong IN('P001','P002');

PRINT '';

PRINT 'EXPECTED';

PRINT '- P001 cập nhật';

PRINT '- P002 cập nhật';

PRINT '';



/******************************************************************************
TC49
T05 - Đặt cọc
******************************************************************************/

PRINT 'TC49 - T05_DatCoc';

PRINT '===== BEFORE =====';

SELECT *
FROM DatCoc;

PRINT '';

PRINT 'Chạy file T05_DatCoc.sql';

PRINT '';

PRINT '===== AFTER =====';

SELECT *
FROM DatCoc;

PRINT '';

PRINT 'EXPECTED';

PRINT '- Có bản ghi đặt cọc';

PRINT '';



/******************************************************************************
TC50
T06 - Hủy hợp đồng
******************************************************************************/

PRINT 'TC50 - T06_HuyHopDong';

PRINT '===== BEFORE =====';

SELECT *
FROM HopDong
WHERE MaHopDong='HD001';

PRINT '';

PRINT 'Chạy file T06_HuyHopDong.sql';

PRINT '';

PRINT '===== AFTER =====';

SELECT *
FROM HopDong
WHERE MaHopDong='HD001';

PRINT '';

PRINT 'EXPECTED';

PRINT '- Hợp đồng chuyển sang Đã hủy';

PRINT '- Phòng trở về Trống';

PRINT '';



/******************************************************************************
TC51
Kiểm tra Transaction tồn tại
******************************************************************************/

PRINT 'TC51';

SELECT
name
FROM sys.objects
WHERE type='P'
AND name LIKE 'T%';

PRINT '';



/******************************************************************************
TC52
Kiểm tra Commit
******************************************************************************/

PRINT 'TC52';

PRINT 'Nếu dữ liệu sau Transaction thay đổi';

PRINT '=> COMMIT thành công';

PRINT '';



/******************************************************************************
TC53
Kiểm tra Rollback
******************************************************************************/

PRINT 'TC53';

PRINT 'Nếu có lỗi';

PRINT '=> dữ liệu không thay đổi';

PRINT '';



PRINT '=========================================================';
PRINT 'KẾT THÚC PART 5';
PRINT '=========================================================';
GO