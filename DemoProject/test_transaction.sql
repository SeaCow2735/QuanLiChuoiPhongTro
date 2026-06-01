-- Dữ liệu test giao tác THUÊ PHÒNG --
UPDATE PHONG
SET TrangThai=N'Trống'
WHERE MaPhong IN (1,3,5);

EXEC SP_ThuePhong
    @MaKhach = 1,
    @MaPhong = 1,
    @NgayBD = '2026-07-01',
    @NgayKT = '2027-06-30',
    @TienCoc = 5000000;
-- Trigger -- 
EXEC SP_ThuePhong
    @MaKhach = 2,
    @MaPhong = 2,
    @NgayBD = '2026-07-01',
    @NgayKT = '2027-06-30',
    @TienCoc = 5000000;

-- Dữ liệu test giao tác TRẢ PHÒNG --  
EXEC SP_TraPhong
    @MaHD = 1,
    @MaPhong = 2;
SELECT *
FROM PHONG
WHERE MaPhong = 2;

SELECT *
FROM HOP_DONG
WHERE MaHD = 1;

-- Dữ liệu test giao tác THANH TOÁN -- 
SELECT *
FROM HOA_DON
WHERE TrangThai = N'Chưa thanh toán';
 EXEC SP_ThanhToanHoaDon
    @MaHoaDon = 11,
    @SoTien = 2825000,
    @PhuongThuc = N'Momo';

-- Test thống kê doanh thu 
SELECT
    Thang,
    Nam,
    SUM(TongTien) AS DoanhThu
FROM HOA_DON
WHERE TrangThai = N'Đã thanh toán'
GROUP BY Thang,Nam;

