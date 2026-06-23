/*
==================================================
PROJECT : QUAN LY CHUOI PHONG TRO
FILE    : 05_Views.sql
AUTHOR  : DBA Team
PURPOSE : Business Views
==================================================
*/

USE QuanLiChuoiPhongTro;
GO

CREATE VIEW vw_DanhSachPhongTrong
AS
SELECT
    p.MaPhong,
    p.TenPhong,
    p.LoaiPhong,
    p.DienTich,
    p.GiaThue,
    p.TrangThai,
    kt.MaKhuTro,
    kt.TenKhuTro,
    kt.DiaChi
FROM Phong p
INNER JOIN KhuTro kt
    ON p.MaKhuTro = kt.MaKhuTro
WHERE p.TrangThai = N'Trống';
GO

CREATE VIEW vw_HopDongConHieuLuc
AS
SELECT
    hd.MaHopDong,
    kt.HoTen,
    p.TenPhong,
    hd.NgayBatDau,
    hd.NgayKetThuc,
    hd.GiaThueThoa,
    hd.TrangThai
FROM HopDong hd
INNER JOIN KhachThue kt
    ON hd.MaKhachThue = kt.MaKhachThue
INNER JOIN Phong p
    ON hd.MaPhong = p.MaPhong
WHERE hd.TrangThai = N'Hiệu lực';
GO

CREATE VIEW vw_HoaDonChuaThanhToan
AS
SELECT
    h.MaHoaDon,
    h.MaHopDong,
    h.ThangHoaDon,
    h.NamHoaDon,
    h.TongTien,
    h.HanThanhToan,
    kt.HoTen,
    p.TenPhong
FROM HoaDon h
INNER JOIN HopDong hd
    ON h.MaHopDong = hd.MaHopDong
INNER JOIN KhachThue kt
    ON hd.MaKhachThue = kt.MaKhachThue
INNER JOIN Phong p
    ON hd.MaPhong = p.MaPhong
WHERE h.TrangThai = N'Chưa thanh toán';
GO

CREATE VIEW vw_DoanhThuTheoThang
AS
SELECT
    YEAR(NgayThanhToan) Nam,
    MONTH(NgayThanhToan) Thang,
    COUNT(*) SoGiaoDich,
    SUM(SoTienThanhToan) TongDoanhThu
FROM ThanhToan
GROUP BY
    YEAR(NgayThanhToan),
    MONTH(NgayThanhToan);
GO

CREATE VIEW vw_HopDongSapHetHan
AS
SELECT
    *
FROM HopDong
WHERE
    TrangThai = N'Hiệu lực'
    AND DATEDIFF(DAY,GETDATE(),NgayKetThuc)<=30;
GO

CREATE VIEW vw_DoanhThuTheoKhuTro
AS
SELECT
    kt.MaKhuTro,
    kt.TenKhuTro,
    SUM(tt.SoTienThanhToan) TongDoanhThu
FROM ThanhToan tt
INNER JOIN HoaDon hd
    ON tt.MaHoaDon = hd.MaHoaDon
INNER JOIN HopDong h
    ON hd.MaHopDong = h.MaHopDong
INNER JOIN Phong p
    ON h.MaPhong = p.MaPhong
INNER JOIN KhuTro kt
    ON p.MaKhuTro = kt.MaKhuTro
GROUP BY
    kt.MaKhuTro,
    kt.TenKhuTro;
GO

CREATE VIEW vw_ThongKeTyLeLapDay
AS
SELECT
    kt.MaKhuTro,
    kt.TenKhuTro,

    COUNT(*) TongPhong,

    SUM(
        CASE
            WHEN p.TrangThai=N'Đang thuê'
            THEN 1
            ELSE 0
        END
    ) SoPhongDangThue,

    CAST(
    SUM(
        CASE
            WHEN p.TrangThai=N'Đang thuê'
            THEN 1
            ELSE 0
        END
    ) *100.0
    /
    COUNT(*)
    AS DECIMAL(5,2)
    ) TyLeLapDay
FROM KhuTro kt
INNER JOIN Phong p
    ON kt.MaKhuTro=p.MaKhuTro
GROUP BY
    kt.MaKhuTro,
    kt.TenKhuTro;
GO