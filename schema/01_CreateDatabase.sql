/* =========================================================
   Task: TV4-01 - Tạo CREATE DATABASE & cấu trúc file
   Mục đích: Tạo database QuanLiChuoiPhongTro nếu chưa tồn tại
   Quy ước: Đây là file đầu tiên (01_) trong chuỗi script,
            chạy theo thứ tự 01 -> 02 -> 03 -> ...
   ========================================================= */

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'QuanLiChuoiPhongTro')
BEGIN
    CREATE DATABASE QuanLiChuoiPhongTro;
END
GO 

USE QuanLiChuoiPhongTro;
GO
