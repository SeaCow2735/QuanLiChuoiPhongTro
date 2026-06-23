/*
==================================================
PROJECT : QUAN LY CHUOI PHONG TRO
FILE    : T03_TraPhong.sql
PURPOSE : Move Out Transaction
==================================================
*/
USE QuanLiChuoiPhongTro;
GO
BEGIN TRY

    BEGIN TRANSACTION;

    UPDATE HopDong
    SET
        TrangThai=N'Hết hạn'
    WHERE MaHopDong='HD001';

    UPDATE DatCoc
    SET
        TrangThai=N'Đã hoàn',
        NgayHoanCoc=GETDATE()
    WHERE MaHopDong='HD001';

    UPDATE Phong
    SET TrangThai=N'Trống'
    WHERE MaPhong=
    (
        SELECT MaPhong
        FROM HopDong
        WHERE MaHopDong='HD001'
    );

    COMMIT;

END TRY

BEGIN CATCH

    ROLLBACK;

    THROW;

END CATCH
GO