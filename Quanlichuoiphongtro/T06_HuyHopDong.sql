/*
==================================================
PROJECT : QUAN LY CHUOI PHONG TRO
FILE    : T06_HuyHopDong.sql
PURPOSE : Cancel Contract Transaction
==================================================
*/
USE QuanLiChuoiPhongTro;
GO
BEGIN TRY

    BEGIN TRANSACTION;

    UPDATE HopDong
    SET TrangThai=N'Đã hủy'
    WHERE MaHopDong='HD002';

    UPDATE Phong
    SET TrangThai=N'Trống'
    WHERE MaPhong=
    (
        SELECT MaPhong
        FROM HopDong
        WHERE MaHopDong='HD002'
    );

    UPDATE DatCoc
    SET TrangThai=N'Đã khấu trừ'
    WHERE MaHopDong='HD002';

    COMMIT;

END TRY

BEGIN CATCH

    ROLLBACK;

    THROW;

END CATCH
GO