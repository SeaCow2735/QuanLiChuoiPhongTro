/*
==================================================
PROJECT : QUAN LY CHUOI PHONG TRO
FILE    : 08_Indexes.sql
AUTHOR  : DBA Team
PURPOSE : Performance Tuning
==================================================
*/
USE QuanLiChuoiPhongTro;
GO


CREATE NONCLUSTERED INDEX IX_Phong_TrangThai
ON Phong(TrangThai);
GO

CREATE NONCLUSTERED INDEX IX_HopDong_MaKhachThue
ON HopDong(MaKhachThue);
GO

CREATE NONCLUSTERED INDEX IX_HoaDon_MaHopDong
ON HoaDon(MaHopDong);
GO

CREATE NONCLUSTERED INDEX IX_ThanhToan_NgayThanhToan
ON ThanhToan(NgayThanhToan);
GO

CREATE NONCLUSTERED INDEX IX_HoaDon_TrangThai
ON HoaDon(TrangThai);
GO

CREATE NONCLUSTERED INDEX IX_ChiSoDichVu_Report
ON ChiSoDichVu
(
    MaPhong,
    ThangGhi,
    NamGhi
);
GO

CREATE NONCLUSTERED INDEX IX_HopDong_TrangThai
ON HopDong
(
    TrangThai,
    NgayKetThuc
);
GO

CREATE NONCLUSTERED INDEX IX_HoaDon_Report
ON HoaDon
(
    NamHoaDon,
    ThangHoaDon,
    TrangThai
)
INCLUDE
(
    TongTien,
    MaHopDong
);
GO


CREATE NONCLUSTERED INDEX IX_ThanhToan_DoanhThu
ON ThanhToan
(
    NgayThanhToan
)
INCLUDE
(
    SoTienThanhToan
);
GO

