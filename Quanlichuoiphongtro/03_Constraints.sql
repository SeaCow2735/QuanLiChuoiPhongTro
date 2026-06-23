/* =========================================================
   Task: TV4-03 - Thêm Foreign Key & Constraint
   Database: QuanLiChuoiPhongTro
   Nguồn: ConstraintList.docx (TV3-05)
   Điều kiện: Chạy SAU 02_CreateTables.sql (toàn bộ 11 bảng
              phải tồn tại trước khi chạy file này).
   Thứ tự: 01 -> 02 -> 03
   ========================================================= */

USE QuanLiChuoiPhongTro;
GO

-- =========================================================
-- 1. KHUTRO
-- =========================================================
ALTER TABLE KhuTro ADD CONSTRAINT UQ_KhuTro_TenKhuTro UNIQUE (TenKhuTro);
GO
ALTER TABLE KhuTro ADD CONSTRAINT CK_KhuTro_SoDienThoai CHECK (LEN(SoDienThoai) >= 10);
GO

-- =========================================================
-- 2. PHONG
-- =========================================================
ALTER TABLE Phong ADD CONSTRAINT FK_Phong_KhuTro
    FOREIGN KEY (MaKhuTro) REFERENCES KhuTro(MaKhuTro);
GO
ALTER TABLE Phong ADD CONSTRAINT UQ_Phong_KhuTro_TenPhong UNIQUE (MaKhuTro, TenPhong);
GO
ALTER TABLE Phong ADD CONSTRAINT CK_Phong_DienTich CHECK (DienTich > 0);
GO
ALTER TABLE Phong ADD CONSTRAINT CK_Phong_GiaThue CHECK (GiaThue > 0);
GO
ALTER TABLE Phong ADD CONSTRAINT CK_Phong_TrangThai
    CHECK (TrangThai IN (N'Trống', N'Đang thuê', N'Bảo trì'));
GO
ALTER TABLE Phong ADD CONSTRAINT DF_Phong_TrangThai DEFAULT (N'Trống') FOR TrangThai;
GO

-- =========================================================
-- 3. NHANVIEN
-- =========================================================
ALTER TABLE NhanVien ADD CONSTRAINT FK_NhanVien_KhuTro
    FOREIGN KEY (MaKhuTro) REFERENCES KhuTro(MaKhuTro);
GO
ALTER TABLE NhanVien ADD CONSTRAINT UQ_NhanVien_SoDienThoai UNIQUE (SoDienThoai);
GO
ALTER TABLE NhanVien ADD CONSTRAINT UQ_NhanVien_Email UNIQUE (Email);
GO
ALTER TABLE NhanVien ADD CONSTRAINT CK_NhanVien_VaiTro
    CHECK (VaiTro IN (N'Admin', N'Manager', N'Staff'));
GO
ALTER TABLE NhanVien ADD CONSTRAINT DF_NhanVien_VaiTro DEFAULT (N'Staff') FOR VaiTro;
GO

-- =========================================================
-- 4. KHACHTHUE
-- =========================================================
ALTER TABLE KhachThue ADD CONSTRAINT UQ_KhachThue_CCCD UNIQUE (CCCD);
GO
ALTER TABLE KhachThue ADD CONSTRAINT CK_KhachThue_CCCD CHECK (LEN(CCCD) = 12);
GO
ALTER TABLE KhachThue ADD CONSTRAINT UQ_KhachThue_SoDienThoai UNIQUE (SoDienThoai);
GO
ALTER TABLE KhachThue ADD CONSTRAINT UQ_KhachThue_Email UNIQUE (Email);
GO
ALTER TABLE KhachThue ADD CONSTRAINT CK_KhachThue_NgaySinh CHECK (NgaySinh < GETDATE());
GO

-- =========================================================
-- 5. HOPDONG
-- =========================================================
ALTER TABLE HopDong ADD CONSTRAINT FK_HopDong_NhanVien
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien);
GO
ALTER TABLE HopDong ADD CONSTRAINT FK_HopDong_KhachThue
    FOREIGN KEY (MaKhachThue) REFERENCES KhachThue(MaKhachThue);
GO
ALTER TABLE HopDong ADD CONSTRAINT FK_HopDong_Phong
    FOREIGN KEY (MaPhong) REFERENCES Phong(MaPhong);
GO
ALTER TABLE HopDong ADD CONSTRAINT CK_HopDong_NgayKetThuc CHECK (NgayKetThuc > NgayBatDau);
GO
ALTER TABLE HopDong ADD CONSTRAINT CK_HopDong_GiaThueThoa CHECK (GiaThueThoa > 0);
GO
ALTER TABLE HopDong ADD CONSTRAINT CK_HopDong_TrangThai
    CHECK (TrangThai IN (N'Hiệu lực', N'Hết hạn', N'Đã hủy'));
GO
ALTER TABLE HopDong ADD CONSTRAINT DF_HopDong_TrangThai DEFAULT (N'Hiệu lực') FOR TrangThai;
GO

-- =========================================================
-- 6. HOADON
-- =========================================================
ALTER TABLE HoaDon ADD CONSTRAINT FK_HoaDon_HopDong
    FOREIGN KEY (MaHopDong) REFERENCES HopDong(MaHopDong);
GO
ALTER TABLE HoaDon ADD CONSTRAINT FK_HoaDon_NhanVien
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien);
GO
ALTER TABLE HoaDon ADD CONSTRAINT UQ_HoaDon_HopDong_Thang_Nam
    UNIQUE (MaHopDong, ThangHoaDon, NamHoaDon);
GO
ALTER TABLE HoaDon ADD CONSTRAINT CK_HoaDon_ThangHoaDon CHECK (ThangHoaDon BETWEEN 1 AND 12);
GO
ALTER TABLE HoaDon ADD CONSTRAINT CK_HoaDon_NamHoaDon CHECK (NamHoaDon >= 2020);
GO
ALTER TABLE HoaDon ADD CONSTRAINT CK_HoaDon_TienPhong CHECK (TienPhong >= 0);
GO
ALTER TABLE HoaDon ADD CONSTRAINT CK_HoaDon_TienDichVu CHECK (TienDichVu >= 0);
GO
ALTER TABLE HoaDon ADD CONSTRAINT CK_HoaDon_TongTien CHECK (TongTien >= 0);
GO
ALTER TABLE HoaDon ADD CONSTRAINT CK_HoaDon_HanThanhToan CHECK (HanThanhToan >= NgayLap);
GO
ALTER TABLE HoaDon ADD CONSTRAINT CK_HoaDon_TrangThai
    CHECK (TrangThai IN (N'Chưa thanh toán', N'Đã thanh toán', N'Quá hạn'));
GO
ALTER TABLE HoaDon ADD CONSTRAINT DF_HoaDon_NgayLap DEFAULT (GETDATE()) FOR NgayLap;
GO

-- =========================================================
-- 7. THANHTOAN
-- =========================================================
ALTER TABLE ThanhToan ADD CONSTRAINT FK_ThanhToan_HoaDon
    FOREIGN KEY (MaHoaDon) REFERENCES HoaDon(MaHoaDon);
GO
ALTER TABLE ThanhToan ADD CONSTRAINT FK_ThanhToan_NhanVien
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien);
GO
ALTER TABLE ThanhToan ADD CONSTRAINT UQ_ThanhToan_HoaDon UNIQUE (MaHoaDon);
GO
ALTER TABLE ThanhToan ADD CONSTRAINT CK_ThanhToan_SoTien CHECK (SoTienThanhToan > 0);
GO
ALTER TABLE ThanhToan ADD CONSTRAINT CK_ThanhToan_PhuongThuc
    CHECK (PhuongThucThanhToan IN (N'Tiền mặt', N'Chuyển khoản', N'Ví điện tử'));
GO
ALTER TABLE ThanhToan ADD CONSTRAINT DF_ThanhToan_NgayThanhToan DEFAULT (GETDATE()) FOR NgayThanhToan;
GO

-- =========================================================
-- 8. DATCOC
-- =========================================================
ALTER TABLE DatCoc ADD CONSTRAINT FK_DatCoc_HopDong
    FOREIGN KEY (MaHopDong) REFERENCES HopDong(MaHopDong);
GO
ALTER TABLE DatCoc ADD CONSTRAINT UQ_DatCoc_HopDong UNIQUE (MaHopDong);
GO
ALTER TABLE DatCoc ADD CONSTRAINT CK_DatCoc_SoTienCoc CHECK (SoTienCoc > 0);
GO
ALTER TABLE DatCoc ADD CONSTRAINT CK_DatCoc_NgayHoanCoc CHECK (NgayHoanCoc >= NgayDatCoc);
GO
ALTER TABLE DatCoc ADD CONSTRAINT CK_DatCoc_TrangThai
    CHECK (TrangThai IN (N'Đang giữ', N'Đã hoàn', N'Đã khấu trừ'));
GO
ALTER TABLE DatCoc ADD CONSTRAINT DF_DatCoc_TrangThai DEFAULT (N'Đang giữ') FOR TrangThai;
GO

-- =========================================================
-- 9. LICHSUCHUYENPHONG
-- =========================================================
ALTER TABLE LichSuChuyenPhong ADD CONSTRAINT FK_LSCP_HopDong
    FOREIGN KEY (MaHopDong) REFERENCES HopDong(MaHopDong);
GO
ALTER TABLE LichSuChuyenPhong ADD CONSTRAINT FK_LSCP_NhanVien
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien);
GO
ALTER TABLE LichSuChuyenPhong ADD CONSTRAINT FK_LSCP_PhongCu
    FOREIGN KEY (MaPhongCu) REFERENCES Phong(MaPhong);
GO
ALTER TABLE LichSuChuyenPhong ADD CONSTRAINT FK_LSCP_PhongMoi
    FOREIGN KEY (MaPhongMoi) REFERENCES Phong(MaPhong);
GO
ALTER TABLE LichSuChuyenPhong ADD CONSTRAINT CK_LSCP_PhongKhacNhau
    CHECK (MaPhongCu <> MaPhongMoi);
GO
ALTER TABLE LichSuChuyenPhong ADD CONSTRAINT DF_LSCP_NgayChuyenPhong DEFAULT (GETDATE()) FOR NgayChuyenPhong;
GO

-- =========================================================
-- 10. DICHVU
-- =========================================================
ALTER TABLE DichVu ADD CONSTRAINT UQ_DichVu_TenDichVu UNIQUE (TenDichVu);
GO
ALTER TABLE DichVu ADD CONSTRAINT CK_DichVu_DonGia CHECK (DonGia >= 0);
GO
ALTER TABLE DichVu ADD CONSTRAINT CK_DichVu_LoaiDichVu
    CHECK (LoaiDichVu IN (N'Điện', N'Nước', N'Internet', N'Khác'));
GO

-- =========================================================
-- 11. CHISODICHVU
-- =========================================================
ALTER TABLE ChiSoDichVu ADD CONSTRAINT FK_ChiSo_Phong
    FOREIGN KEY (MaPhong) REFERENCES Phong(MaPhong);
GO
ALTER TABLE ChiSoDichVu ADD CONSTRAINT FK_ChiSo_DichVu
    FOREIGN KEY (MaDichVu) REFERENCES DichVu(MaDichVu);
GO
ALTER TABLE ChiSoDichVu ADD CONSTRAINT UQ_ChiSo_Phong_DichVu_Thang_Nam
    UNIQUE (MaPhong, MaDichVu, ThangGhi, NamGhi);
GO
ALTER TABLE ChiSoDichVu ADD CONSTRAINT CK_ChiSo_ChiSoCuoi CHECK (ChiSoCuoi >= ChiSoDau);
GO
ALTER TABLE ChiSoDichVu ADD CONSTRAINT CK_ChiSo_SoTieuThu CHECK (SoTieuThu >= 0);
GO
ALTER TABLE ChiSoDichVu ADD CONSTRAINT CK_ChiSo_ThangGhi CHECK (ThangGhi BETWEEN 1 AND 12);
GO
ALTER TABLE ChiSoDichVu ADD CONSTRAINT CK_ChiSo_NamGhi CHECK (NamGhi >= 2020);
GO
ALTER TABLE ChiSoDichVu ADD CONSTRAINT DF_ChiSo_ThangGhi DEFAULT (MONTH(GETDATE())) FOR ThangGhi;
GO
ALTER TABLE ChiSoDichVu ADD CONSTRAINT DF_ChiSo_NamGhi DEFAULT (YEAR(GETDATE())) FOR NamGhi;
GO
