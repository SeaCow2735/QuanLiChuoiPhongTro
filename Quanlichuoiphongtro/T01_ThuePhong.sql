/*
==================================================
PROJECT : QUAN LY CHUOI PHONG TRO
FILE    : T01_ThuePhong.sql
PURPOSE : Room Rental Transaction
==================================================
*/
USE QuanLiChuoiPhongTro;
GO

SET XACT_ABORT ON;  -- Thêm dòng này để tự động rollback khi có lỗi
GO

BEGIN TRY

    BEGIN TRANSACTION;

    DECLARE @MaPhong VARCHAR(10) = 'P001';

    IF NOT EXISTS
    (
        SELECT 1
        FROM Phong
        WHERE MaPhong = @MaPhong
          AND TrangThai = N'Trống'
    )
    BEGIN
        THROW 50001, N'Phòng không khả dụng', 1;
    END

    INSERT INTO HopDong
    (
        MaHopDong,
        MaNhanVien,
        MaKhachThue,
        MaPhong,
        NgayBatDau,
        NgayKetThuc,
        GiaThueThoa,
        TrangThai
    )
    VALUES
    (
        'HD999',
        'NV001',
        'KT001',
        'P001',
        GETDATE(),
        DATEADD(MONTH, 12, GETDATE()),
        3500000,
        N'Hiệu lực'
    );

    UPDATE Phong
    SET TrangThai = N'Đang thuê'
    WHERE MaPhong = 'P001';

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
        'DC999',
        'HD999',
        7000000,
        GETDATE(),
        N'Đang giữ'
    );

    COMMIT TRANSACTION;

    PRINT N'Thuê phòng thành công';

END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0  -- Kiểm tra trước khi rollback
        ROLLBACK TRANSACTION;

    PRINT ERROR_MESSAGE();

    THROW;  -- Re-throw lỗi gốc lên caller

END CATCH;
GO