/*
==================================================
PROJECT : QUAN LY CHUOI PHONG TRO
FILE    : 06_Functions.sql
AUTHOR  : DBA Team
PURPOSE : Functions
==================================================
*/

USE QuanLiChuoiPhongTro;
GO

CREATE FUNCTION fn_TinhTienDienNuoc
(
    @ChiSoDau FLOAT,
    @ChiSoCuoi FLOAT,
    @DonGia DECIMAL(18,2)
)
RETURNS DECIMAL(18,2)
AS
BEGIN

    DECLARE @Tien DECIMAL(18,2);

    SET @Tien =
        (@ChiSoCuoi-@ChiSoDau)
        *
        @DonGia;

    RETURN @Tien;

END
GO

CREATE FUNCTION fn_TinhTongTienHoaDon
(
    @TienPhong DECIMAL(18,2),
    @TienDichVu DECIMAL(18,2)
)
RETURNS DECIMAL(18,2)
AS
BEGIN

    RETURN
    (
        ISNULL(@TienPhong,0)
        +
        ISNULL(@TienDichVu,0)
    );

END
GO

CREATE FUNCTION fn_KiemTraPhongTrong
(
    @MaPhong VARCHAR(10)
)
RETURNS BIT
AS
BEGIN

    DECLARE @Result BIT=0;

    IF EXISTS
    (
        SELECT 1
        FROM Phong
        WHERE MaPhong=@MaPhong
        AND TrangThai=N'Trống'
    )
        SET @Result=1;

    RETURN @Result;

END
GO

CREATE FUNCTION fn_TinhTienDatCoc
(
    @GiaThue DECIMAL(18,2)
)
RETURNS DECIMAL(18,2)
AS
BEGIN

    RETURN @GiaThue * 2;
END
GO

CREATE FUNCTION fn_SoNgayConLaiHopDong
(
    @MaHopDong VARCHAR(10)
)
RETURNS INT
AS
BEGIN

    DECLARE @SoNgay INT;

    SELECT
        @SoNgay =
        DATEDIFF
        (
            DAY,
            GETDATE(),
            NgayKetThuc
        )
    FROM HopDong
    WHERE MaHopDong=@MaHopDong;

    RETURN @SoNgay;

END
GO

