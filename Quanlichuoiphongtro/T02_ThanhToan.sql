/*
==================================================
PROJECT : QUAN LY CHUOI PHONG TRO
FILE    : T02_ThanhToan.sql
PURPOSE : Payment Transaction
==================================================
*/
USE QuanLiChuoiPhongTro;
GO
BEGIN TRY

    BEGIN TRANSACTION;

    DECLARE @MaHoaDon VARCHAR(10)='H001';
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
        NgayThanhToan,
        PhuongThucThanhToan
    )
    VALUES
    (
        'TT999',
        @MaHoaDon,
        'NV001',
        @TongTien,
        GETDATE(),
        N'Chuyển khoản'
    );

    UPDATE HoaDon
    SET TrangThai=N'Đã thanh toán'
    WHERE MaHoaDon=@MaHoaDon;

    COMMIT;

END TRY

BEGIN CATCH

    ROLLBACK;

    THROW;

END CATCH
GO