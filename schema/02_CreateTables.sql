/* =========================================================
   Task: TV4-02 - Viết script CREATE TABLE (tất cả bảng)
   Database: QuanLiChuoiPhongTro
   Nguồn: RelationalSchema.docx (TV3-01) + ConstraintList.docx (TV3-05)
   Quy ước NOT NULL áp dụng ở bước này:
     - Mọi PRIMARY KEY
     - Mọi FOREIGN KEY (toàn bộ quan hệ trong ERD đều bắt buộc)
     - Cột có NOT NULL tường minh trong ConstraintList
     - Cột có DEFAULT (vì luôn có giá trị, không để trống)
   FOREIGN KEY, UNIQUE, CHECK, DEFAULT chi tiết -> 03_Constraints.sql
   ========================================================= */

USE QuanLiChuoiPhongTro;
GO

-- =========================================================
-- 1. KhuTro
-- =========================================================
IF OBJECT_ID('dbo.KhuTro', 'U') IS NULL
BEGIN
    CREATE TABLE KhuTro (
        MaKhuTro      VARCHAR(10)    NOT NULL PRIMARY KEY,
        TenKhuTro     NVARCHAR(100)  NOT NULL,
        DiaChi        NVARCHAR(255)  NOT NULL,
        SoDienThoai   VARCHAR(15)    NOT NULL,
        MoTa          NVARCHAR(500)  NULL
    );
END
GO

-- =========================================================
-- 2. Phong
-- =========================================================
IF OBJECT_ID('dbo.Phong', 'U') IS NULL
BEGIN
    CREATE TABLE Phong (
        MaPhong       VARCHAR(10)    NOT NULL PRIMARY KEY,
        MaKhuTro      VARCHAR(10)    NOT NULL,   -- FK -> KhuTro (TV4-03)
        TenPhong      NVARCHAR(50)   NOT NULL,
        LoaiPhong     NVARCHAR(50)   NULL,
        DienTich      FLOAT          NULL,       -- CHECK > 0 (TV4-03)
        GiaThue       DECIMAL(15,2)  NULL,       -- CHECK > 0 (TV4-03)
        TrangThai     NVARCHAR(20)   NOT NULL    -- CHECK IN (...) + DEFAULT 'Trống' (TV4-03)
    );
END
GO

-- =========================================================
-- 3. NhanVien
-- =========================================================
IF OBJECT_ID('dbo.NhanVien', 'U') IS NULL
BEGIN
    CREATE TABLE NhanVien (
        MaNhanVien    VARCHAR(10)    NOT NULL PRIMARY KEY,
        MaKhuTro      VARCHAR(10)    NOT NULL,   -- FK -> KhuTro (TV4-03)
        HoTen         NVARCHAR(100)  NOT NULL,
        VaiTro        NVARCHAR(50)   NOT NULL,   -- CHECK IN (...) + DEFAULT 'Staff' (TV4-03)
        SoDienThoai   VARCHAR(15)    NULL,       -- UNIQUE (TV4-03)
        Email         VARCHAR(100)   NULL,       -- UNIQUE (TV4-03)
        MatKhau       VARCHAR(255)   NOT NULL
    );
END
GO

-- =========================================================
-- 4. KhachThue
-- =========================================================
IF OBJECT_ID('dbo.KhachThue', 'U') IS NULL
BEGIN
    CREATE TABLE KhachThue (
        MaKhachThue   VARCHAR(10)    NOT NULL PRIMARY KEY,
        HoTen         NVARCHAR(100)  NOT NULL,
        CCCD          VARCHAR(12)    NULL,       -- UNIQUE + CHECK len=12 (TV4-03)
        NgaySinh      DATE           NULL,       -- CHECK < GETDATE() (TV4-03)
        SoDienThoai   VARCHAR(15)    NULL,       -- UNIQUE (TV4-03)
        DiaChi        NVARCHAR(255)  NULL,
        Email         VARCHAR(100)   NULL        -- UNIQUE (TV4-03)
    );
END
GO

-- =========================================================
-- 5. HopDong
-- =========================================================
IF OBJECT_ID('dbo.HopDong', 'U') IS NULL
BEGIN
    CREATE TABLE HopDong (
        MaHopDong     VARCHAR(10)    NOT NULL PRIMARY KEY,
        MaNhanVien    VARCHAR(10)    NOT NULL,   -- FK -> NhanVien (TV4-03)
        MaKhachThue   VARCHAR(10)    NOT NULL,   -- FK -> KhachThue (TV4-03)
        MaPhong       VARCHAR(10)    NOT NULL,   -- FK -> Phong (TV4-03)
        NgayBatDau    DATE           NOT NULL,
        NgayKetThuc   DATE           NULL,       -- CHECK > NgayBatDau (TV4-03)
        DienTich      FLOAT          NULL,
        GiaThueThoa   DECIMAL(15,2)  NULL,       -- CHECK > 0 (TV4-03)
        TrangThai     NVARCHAR(20)   NOT NULL    -- CHECK IN (...) + DEFAULT 'Hiệu lực' (TV4-03)
    );
END
GO

-- =========================================================
-- 6. HoaDon
-- =========================================================
IF OBJECT_ID('dbo.HoaDon', 'U') IS NULL
BEGIN
    CREATE TABLE HoaDon (
        MaHoaDon       VARCHAR(10)    NOT NULL PRIMARY KEY,
        MaHopDong      VARCHAR(10)    NOT NULL,  -- FK -> HopDong (TV4-03)
        MaNhanVien     VARCHAR(10)    NOT NULL,  -- FK -> NhanVien (TV4-03)
        ThangHoaDon    INT            NULL,      -- CHECK BETWEEN 1-12 (TV4-03)
        NamHoaDon      INT            NULL,      -- CHECK >= 2020 (TV4-03)
        TienPhong      DECIMAL(15,2)  NULL,      -- CHECK >= 0 (TV4-03)
        TienDichVu     DECIMAL(15,2)  NULL,      -- CHECK >= 0 (TV4-03)
        TongTien       DECIMAL(15,2)  NULL,      -- CHECK >= 0 (TV4-03)
        TrangThai      NVARCHAR(20)   NULL,      -- CHECK IN (...) (TV4-03)
        NgayLap        DATE           NOT NULL,  -- DEFAULT GETDATE() (TV4-03)
        HanThanhToan   DATE           NULL       -- CHECK >= NgayLap (TV4-03)
    );
END
GO

-- =========================================================
-- 7. ThanhToan
-- =========================================================
IF OBJECT_ID('dbo.ThanhToan', 'U') IS NULL
BEGIN
    CREATE TABLE ThanhToan (
        MaThanhToan          VARCHAR(10)    NOT NULL PRIMARY KEY,
        MaHoaDon             VARCHAR(10)    NOT NULL,  -- FK + UNIQUE -> HoaDon (TV4-03)
        MaNhanVien           VARCHAR(10)    NOT NULL,  -- FK -> NhanVien (TV4-03)
        SoTienThanhToan      DECIMAL(15,2)  NULL,      -- CHECK > 0 (TV4-03)
        NgayThanhToan        DATETIME       NOT NULL,  -- DEFAULT GETDATE() (TV4-03)
        PhuongThucThanhToan  NVARCHAR(50)   NULL,      -- CHECK IN (...) (TV4-03)
        GhiChu               NVARCHAR(255)  NULL
    );
END
GO

-- =========================================================
-- 8. DatCoc
-- =========================================================
IF OBJECT_ID('dbo.DatCoc', 'U') IS NULL
BEGIN
    CREATE TABLE DatCoc (
        MaDatCoc      VARCHAR(10)    NOT NULL PRIMARY KEY,
        MaHopDong     VARCHAR(10)    NOT NULL,  -- FK + UNIQUE -> HopDong (TV4-03)
        SoTienCoc     DECIMAL(15,2)  NULL,      -- CHECK > 0 (TV4-03)
        NgayDatCoc    DATE           NULL,
        TrangThai     NVARCHAR(20)   NOT NULL,  -- CHECK IN (...) + DEFAULT 'Đang giữ' (TV4-03)
        NgayHoanCoc   DATE           NULL,      -- CHECK >= NgayDatCoc (TV4-03)
        GhiChu        NVARCHAR(255)  NULL
    );
END
GO

-- =========================================================
-- 9. LichSuChuyenPhong
-- =========================================================
IF OBJECT_ID('dbo.LichSuChuyenPhong', 'U') IS NULL
BEGIN
    CREATE TABLE LichSuChuyenPhong (
        MaLichSu          VARCHAR(10)    NOT NULL PRIMARY KEY,
        MaHopDong         VARCHAR(10)    NOT NULL,  -- FK -> HopDong (TV4-03)
        MaNhanVien        VARCHAR(10)    NOT NULL,  -- FK -> NhanVien (TV4-03)
        MaPhongCu         VARCHAR(10)    NOT NULL,  -- FK -> Phong (TV4-03)
        MaPhongMoi        VARCHAR(10)    NOT NULL,  -- FK -> Phong (TV4-03)
        NgayChuyenPhong   DATE           NOT NULL,  -- DEFAULT GETDATE() (TV4-03)
        LyDoChuyenPhong   NVARCHAR(255)  NULL,
        ChenhLechGia      DECIMAL(15,2)  NULL
    );
END
GO

-- =========================================================
-- 10. DichVu
-- =========================================================
IF OBJECT_ID('dbo.DichVu', 'U') IS NULL
BEGIN
    CREATE TABLE DichVu (
        MaDichVu      VARCHAR(10)    NOT NULL PRIMARY KEY,
        TenDichVu     NVARCHAR(100)  NOT NULL,  -- UNIQUE (TV4-03)
        DonViTinh     NVARCHAR(20)   NULL,
        DonGia        DECIMAL(15,2)  NULL,      -- CHECK >= 0 (TV4-03)
        LoaiDichVu    NVARCHAR(20)   NULL,      -- CHECK IN (...) (TV4-03)
        MoTa          NVARCHAR(255)  NULL
    );
END
GO

-- =========================================================
-- 11. ChiSoDichVu  (bảng trung gian Phong n-n DichVu)
-- =========================================================
IF OBJECT_ID('dbo.ChiSoDichVu', 'U') IS NULL
BEGIN
    CREATE TABLE ChiSoDichVu (
        MaChiSo       VARCHAR(10)  NOT NULL PRIMARY KEY,
        MaPhong       VARCHAR(10)  NOT NULL,  -- FK -> Phong (TV4-03)
        MaDichVu      VARCHAR(10)  NOT NULL,  -- FK -> DichVu (TV4-03)
        ChiSoDau      FLOAT        NULL,
        ChiSoCuoi     FLOAT        NULL,      -- CHECK >= ChiSoDau (TV4-03)
        SoTieuThu     FLOAT        NULL,      -- CHECK >= 0 (TV4-03)
        ThangGhi      INT          NOT NULL,  -- CHECK BETWEEN 1-12 + DEFAULT MONTH(GETDATE()) (TV4-03)
        NamGhi        INT          NOT NULL   -- CHECK >= 2020 + DEFAULT YEAR(GETDATE()) (TV4-03)
    );
END
GO
