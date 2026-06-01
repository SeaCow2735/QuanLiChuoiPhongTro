-- Tạo database
CREATE DATABASE QLSV;
GO

-- Sử dụng database
USE QLSV;
GO

-- =========================
-- Tạo bảng Khoa
-- =========================
CREATE TABLE Khoa
(
    MaKhoa VARCHAR(10) PRIMARY KEY,
    TenKhoa NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(200),
    DienThoai VARCHAR(15)
);
GO

-- =========================
-- Tạo bảng SinhVien
-- =========================
CREATE TABLE SinhVien
(
    MaSV VARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    NgaySinh DATE,
    MaKhoa VARCHAR(10),

    CONSTRAINT FK_SinhVien_Khoa
        FOREIGN KEY (MaKhoa)
        REFERENCES Khoa(MaKhoa)
);
GO

-- =========================
-- Tạo bảng MonHoc
-- =========================
CREATE TABLE MonHoc
(
    MaMon VARCHAR(10) PRIMARY KEY,
    TenMon NVARCHAR(100) NOT NULL,
    SoTinChi INT,
    TenGV NVARCHAR(100)
);
GO

-- =========================
-- Tạo bảng DangKyHoc
-- =========================
CREATE TABLE DangKyHoc
(
    MaSV VARCHAR(10),
    MaMon VARCHAR(10),
    HocKy NVARCHAR(20),

    CONSTRAINT PK_DangKyHoc
        PRIMARY KEY (MaSV, MaMon, HocKy),

    CONSTRAINT FK_DangKyHoc_SinhVien
        FOREIGN KEY (MaSV)
        REFERENCES SinhVien(MaSV),

    CONSTRAINT FK_DangKyHoc_MonHoc
        FOREIGN KEY (MaMon)
        REFERENCES MonHoc(MaMon)
);
GO