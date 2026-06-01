SELECT DKH.MaMon
FROM SinhVien SV
JOIN DangKyHoc DKH 
    ON SV.MaSV = DKH.MaSV
WHERE SV.HoTen = N'Nguyễn Thị Hoài';