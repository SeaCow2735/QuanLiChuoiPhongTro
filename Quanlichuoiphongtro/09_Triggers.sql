/*
==================================================
PROJECT : QUAN LY CHUOI PHONG TRO
FILE    : 09_Triggers.sql
AUTHOR  : DBA Team
PURPOSE : 
==================================================
*/
USE QuanLiChuoiPhongTro;
GO

CREATE TABLE AuditLogHopDong
(
    LogID INT IDENTITY(1,1),

    MaHopDong VARCHAR(10),

    HanhDong NVARCHAR(50),

    GiaTriCu NVARCHAR(MAX),

    GiaTriMoi NVARCHAR(MAX),

    NguoiThucHien SYSNAME,

    ThoiGian DATETIME
        DEFAULT GETDATE(),

    CONSTRAINT PK_AuditLogHopDong
    PRIMARY KEY(LogID)
);
GO

CREATE OR ALTER TRIGGER TRG_CapNhatTrangThaiPhong
ON HopDong
AFTER INSERT
AS
BEGIN

    UPDATE p
    SET TrangThai=N'Đang thuê'
    FROM Phong p
    INNER JOIN inserted i
        ON p.MaPhong=i.MaPhong;

END
GO

CREATE OR ALTER TRIGGER TRG_KhongXoaPhongDangThue
ON Phong
INSTEAD OF DELETE
AS
BEGIN

    IF EXISTS
    (
        SELECT 1
        FROM deleted
        WHERE TrangThai=N'Đang thuê'
    )
    BEGIN

        RAISERROR
        (
            N'Không thể xóa phòng đang thuê',
            16,
            1
        );

        RETURN;

    END

    DELETE FROM Phong
    WHERE MaPhong IN
    (
        SELECT MaPhong
        FROM deleted
    );

END
GO

    CREATE OR ALTER TRIGGER TRG_KiemTraTienCoc
ON DatCoc
AFTER INSERT
AS
BEGIN

    IF EXISTS
    (
        SELECT 1
        FROM inserted
        WHERE SoTienCoc<1000000
    )
    BEGIN

        RAISERROR
        (
            N'Tiền cọc tối thiểu 1 triệu',
            16,
            1
        );

        ROLLBACK TRANSACTION;

    END

END
GO

CREATE OR ALTER TRIGGER TRG_GhiLogHopDong
ON HopDong
AFTER UPDATE
AS
BEGIN

    INSERT INTO AuditLogHopDong
    (
        MaHopDong,
        HanhDong,
        GiaTriCu,
        GiaTriMoi,
        NguoiThucHien
    )
    SELECT
        i.MaHopDong,
        N'UPDATE',
        d.TrangThai,
        i.TrangThai,
        SYSTEM_USER
    FROM inserted i
    INNER JOIN deleted d
        ON i.MaHopDong=d.MaHopDong;

END
GO

