/*
==================================================
PROJECT : QUAN LY CHUOI PHONG TRO
FILE    : T05_DatCoc.sql
PURPOSE : Security Deposit Transaction
==================================================
*/
USE QuanLiChuoiPhongTro;
GO
BEGIN TRY

    BEGIN TRANSACTION;

    INSERT INTO DatCoc
    (
        MaDatCoc,
        MaHopDong,
        SoTienCoc,
        NgayDatCoc,
        TrangThai
    )
    VALUES
    (
        'DC888',
        'HD002',
        5000000,
        GETDATE(),
        N'Đang giữ'
    );

    COMMIT;

END TRY

BEGIN CATCH

    ROLLBACK;

    THROW;

END CATCH
GO