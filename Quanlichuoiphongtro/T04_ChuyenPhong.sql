/*
==================================================
PROJECT : QUAN LY CHUOI PHONG TRO
FILE    : T04_ChuyenPhong.sql
PURPOSE : Transfer Transaction
==================================================
*/
USE QuanLiChuoiPhongTro;
GO
BEGIN TRY

    BEGIN TRANSACTION;

    DECLARE @PhongCu VARCHAR(10)='P001';
    DECLARE @PhongMoi VARCHAR(10)='P002';

    INSERT INTO LichSuChuyenPhong
    (
        MaLichSu,
        MaHopDong,
        MaNhanVien,
        MaPhongCu,
        MaPhongMoi,
        NgayChuyenPhong,
        LyDoChuyenPhong
    )
    VALUES
    (
        'LS999',
        'HD001',
        'NV001',
        @PhongCu,
        @PhongMoi,
        GETDATE(),
        N'Nâng cấp phòng'
    );

    UPDATE HopDong
    SET MaPhong=@PhongMoi
    WHERE MaHopDong='HD001';

    UPDATE Phong
    SET TrangThai=N'Trống'
    WHERE MaPhong=@PhongCu;

    UPDATE Phong
    SET TrangThai=N'Đang thuê'
    WHERE MaPhong=@PhongMoi;

    COMMIT;

END TRY

BEGIN CATCH

    ROLLBACK;

    THROW;

END CATCH
GO