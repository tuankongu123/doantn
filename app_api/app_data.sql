
-- Drop if exist
DROP DATABASE IF EXISTS app_data;
CREATE DATABASE app_data CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE app_data;

-- Bảng Thương hiệu
CREATE TABLE ThuongHieu (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ten VARCHAR(100) NOT NULL
);

-- Bảng Danh mục
CREATE TABLE DanhMucSanPham (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ten VARCHAR(100),
    moTa TEXT
);

-- Bảng Loại sản phẩm
CREATE TABLE LoaiSanPham (
    id INT AUTO_INCREMENT PRIMARY KEY,
    danhMucId INT,
    ten VARCHAR(100),
    FOREIGN KEY (danhMucId) REFERENCES DanhMucSanPham(id)
);

-- Bảng Sản phẩm
CREATE TABLE SanPham (
    id INT AUTO_INCREMENT PRIMARY KEY,
    loaiId INT,
    danhMucId INT,
    thuongHieuId INT,
    ten VARCHAR(150),
    moTa TEXT,
    gia DECIMAL(10,2),
    hinhAnh TEXT,
    soLuong INT,
    trangThai ENUM('active','off') DEFAULT 'active',
    ngayTao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (loaiId) REFERENCES LoaiSanPham(id),
    FOREIGN KEY (danhMucId) REFERENCES DanhMucSanPham(id),
    FOREIGN KEY (thuongHieuId) REFERENCES ThuongHieu(id)
);

-- Bảng Thuộc tính
CREATE TABLE ThuocTinh (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ten VARCHAR(100)
);

-- Giá trị thuộc tính
CREATE TABLE GiaTriThuocTinh (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sanPhamId INT,
    thuocTinhId INT,
    giaTri VARCHAR(255),
    FOREIGN KEY (sanPhamId) REFERENCES SanPham(id),
    FOREIGN KEY (thuocTinhId) REFERENCES ThuocTinh(id)
);

-- Thêm dữ liệu mẫu
INSERT INTO ThuongHieu (ten) VALUES 
('Pampers'), ('Huggies'), ('Abbott'), ('Nestlé'), ('Lego'), ('Fisher-Price');

INSERT INTO DanhMucSanPham (ten, moTa) VALUES 
('Tã & Bỉm', 'Sản phẩm vệ sinh cho bé'),
('Sữa & Dinh dưỡng', 'Sữa bột, sữa tươi, bổ sung vitamin'),
('Đồ chơi', 'Đồ chơi giáo dục, trí tuệ'),
('Quần áo', 'Thời trang cho trẻ sơ sinh và trẻ nhỏ'),
('Đồ dùng', 'Đồ dùng cho bé: bình sữa, khăn, gối...');

INSERT INTO LoaiSanPham (danhMucId, ten) VALUES 
(1, 'Tã dán'), (1, 'Tã quần'), 
(2, 'Sữa bột'), (2, 'Sữa pha sẵn'),
(3, 'Đồ chơi gỗ'), (3, 'Xếp hình'), 
(4, 'Bộ đồ sơ sinh'), (4, 'Quần áo mùa hè'),
(5, 'Bình sữa'), (5, 'Khăn xô');

INSERT INTO SanPham (loaiId, danhMucId, thuongHieuId, ten, moTa, gia, hinhAnh, soLuong) VALUES 
(1, 1, 1, 'Tã dán Pampers NB90', 'Tã dán cho trẻ sơ sinh dưới 5kg', 220000, 'ta_dan_pampers_nb90.jfif', 100),
(2, 1, 2, 'Tã quần Bobby XL62', 'Tã quần dành cho bé 9-14kg', 265000, 'ta_quan_bobby_xl62.jfif', 120),
(3, 2, 2, 'Sữa Friso Gold 4 (900g)', 'Sữa dành cho bé trên 2 tuổi giúp phát triển trí não', 485000, 'sua_friso_gold_4_900g.jfif', 80),
(4, 2, 3, 'Sữa bột Dielac Alpha Step 2 (900g)', 'Dành cho trẻ từ 6-12 tháng tuổi', 295000, 'sua_dielac_alpha_2_900g.jfif', 95),
(5, 4, 6, 'Bộ đồ sơ sinh cotton mùa hè', 'Thoáng mát, phù hợp thời tiết nắng nóng', 125000, 'bo_so_sinh_mua_he.jfif', 65),
(6, 4, 6, 'Bộ quần áo bé trai 6 tháng', 'Chất vải thun cotton mềm mịn, size vừa cho bé 5-7kg', 110000, 'bo_quan_ao_be_trai_6m.jfif', 90),
(7, 3, 5, 'Đồ chơi xếp hình Lego Duplo', 'Giúp trẻ phát triển tư duy logic và vận động tinh', 499000, 'do_choi_lego_duplo.jfif', 70),
(8, 3, 5, 'Gấu bông hoạt hình', 'Gấu bông an toàn, lông không rụng, mềm mại', 165000, 'gau_bong_hoat_hinh.jfif', 110),
(9, 5, 1, 'Bình sữa Philips Avent 260ml', 'Bình sữa nhựa cao cấp không BPA, chống sặc tốt', 89000, 'binh_sua_philips_avent_260ml.jfif', 75),
(10, 5, 2, 'Máy hâm sữa Fatzbaby', 'Máy hâm sữa nhanh, giữ nhiệt hiệu quả', 465000, 'may_ham_sua_fatzbaby.jfif', 40);


-- Thêm thuộc tính
INSERT INTO ThuocTinh (ten) VALUES 
('Size'), 
('Chất liệu'), 
('Màu sắc'), 
('Độ tuổi sử dụng'),
('Cân nặng phù hợp');

-- Gán giá trị thuộc tính cho sản phẩm
INSERT INTO GiaTriThuocTinh (sanPhamId, thuocTinhId, giaTri) VALUES
-- Sản phẩm 1
(1, 1, 'NB'),
(1, 4, '0-6 tháng'),
(1, 5, '0-5kg'),

-- Sản phẩm 2
(2, 1, 'XL'),
(2, 4, '6-12 tháng'),
(2, 5, '9-14kg'),

-- Sản phẩm 3
(3, 4, '24+ tháng'),
(3, 5, '13+kg'),

-- Sản phẩm 4
(4, 4, '6-12 tháng'),
(4, 5, '7-9kg'),

-- Sản phẩm 5
(5, 1, 'S'),
(5, 2, 'Cotton'),
(5, 3, 'Trắng'),
(5, 4, '0-6 tháng'),
(5, 5, '0-6kg'),

-- Sản phẩm 6
(6, 1, 'M'),
(6, 2, 'Thun lạnh'),
(6, 3, 'Xanh dương'),
(6, 4, '6-9 tháng'),
(6, 5, '6-8kg'),

-- Sản phẩm 7
(7, 2, 'Nhựa ABS'),
(7, 4, '24-48 tháng'),

-- Sản phẩm 8
(8, 2, 'Lông nhân tạo'),
(8, 3, 'Nâu - Trắng'),
(8, 4, '24-48 tháng'),

-- Sản phẩm 9
(9, 2, 'Nhựa PP'),
(9, 4, '0-6 tháng'),

-- Sản phẩm 10
(10, 2, 'Nhựa cao cấp'),
(10, 4, '0-12 tháng');



-- Người dùng
CREATE TABLE NguoiDung (
    firebaseUid VARCHAR(128) UNIQUE,
    id INT AUTO_INCREMENT PRIMARY KEY,
    hinhAnh TEXT,
    hoTen VARCHAR(100),
    soDienThoai VARCHAR(15) UNIQUE,
    gioiTinh ENUM('Nam', 'Nữ'),
    email VARCHAR(100),
    ngaySinh DATE,
    vaiTro ENUM('user','admin') DEFAULT 'user',
    xacThuc BOOLEAN DEFAULT FALSE,
    ngayTao DATETIME DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO NguoiDung (
    firebaseUid, hoTen, soDienThoai, gioiTinh, email, ngaySinh, vaiTro, xacThuc, ngayTao
) VALUES 
(
    'sei42SOgx7XwoAWWg1A6KngNdyg1',
    '',
    '0987654321',
    '',
    '',
    NULL,
    'user',
    1,
    '2025-06-19 20:57:58'
),
(
    'uid_admin_67890',
    '',
    '0912345678',
    '',
    '',
    NULL,
    'admin',
    1,
    '2025-06-19 20:58:48'
);
-- OTP gửi qua SMS
CREATE TABLE OTP (
    id INT AUTO_INCREMENT PRIMARY KEY,
    soDienThoai VARCHAR(15),
    maOtp VARCHAR(10),
    thoiGianGui DATETIME,
    daDung BOOLEAN DEFAULT FALSE
);


-- Đánh giá sản phẩm
CREATE TABLE DanhGiaSanPham (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sanPhamId INT,
    nguoiDungId INT,
    diemSo INT,
    binhLuan TEXT,
    ngayTao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sanPhamId) REFERENCES SanPham(id),
    FOREIGN KEY (nguoiDungId) REFERENCES NguoiDung(id)
);

-- Giỏ hàng
CREATE TABLE GioHang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nguoiDungId INT,
    sanPhamId INT,
    soLuong INT,
    ngayTao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (nguoiDungId) REFERENCES NguoiDung(id),
    FOREIGN KEY (sanPhamId) REFERENCES SanPham(id)
);

-- Đơn hàng
CREATE TABLE DonHang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nguoiDungId INT,
    tongTien DECIMAL(10,2),
    phuongThucTt ENUM('cod','vi'),
    trangThai ENUM('cho_duyet','da_duyet','dang_giao','da_xong','huy') DEFAULT 'cho_duyet',
    ngayTao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (nguoiDungId) REFERENCES NguoiDung(id)
);

-- Chi tiết đơn hàng
CREATE TABLE ChiTietDonHang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    donHangId INT,
    sanPhamId INT,
    soLuong INT,
    gia DECIMAL(10,2),
    diaChi TEXT,
    FOREIGN KEY (donHangId) REFERENCES DonHang(id),
    FOREIGN KEY (sanPhamId) REFERENCES SanPham(id)
);

-- Yêu cầu hoàn trả
CREATE TABLE YeuCauHoanTra (
    id INT AUTO_INCREMENT PRIMARY KEY,
    donHangId INT,
    lyDo TEXT,
    trangThai ENUM('cho_duyet','chap_thuan','tu_choi') DEFAULT 'cho_duyet',
    ngayTao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (donHangId) REFERENCES DonHang(id)
);

-- Lịch nhắc mua sắm
CREATE TABLE LichNhacMuaSam (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nguoiDungId INT,
    noiDung TEXT,
    thoiGian DATETIME,
    FOREIGN KEY (nguoiDungId) REFERENCES NguoiDung(id)
);

-- Tích điểm
CREATE TABLE TichDiem (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nguoiDungId INT,
    diem INT,
    moTa TEXT,
    ngayTao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (nguoiDungId) REFERENCES NguoiDung(id)
);

-- Mua định kỳ
CREATE TABLE MuaDinhKy (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nguoiDungId INT,
    sanPhamId INT,
    dinhKyNgay INT,
    ngayBatDau DATE,
    FOREIGN KEY (nguoiDungId) REFERENCES NguoiDung(id),
    FOREIGN KEY (sanPhamId) REFERENCES SanPham(id)
);

-- Voucher
CREATE TABLE Voucher (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ma VARCHAR(50),
    giaTri DECIMAL(10,2),
    hanSuDung DATE,
    gioiHan INT
);

-- Người dùng đã dùng voucher
CREATE TABLE NguoiDungVoucher (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nguoiDungId INT,
    voucherId INT,
    ngayDung DATETIME,
    FOREIGN KEY (nguoiDungId) REFERENCES NguoiDung(id),
    FOREIGN KEY (voucherId) REFERENCES Voucher(id)
);

-- Tin nhắn chatbot
CREATE TABLE TinNhanChatbot (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nguoiDungId INT,
    noiDung TEXT,
    laBot BOOLEAN,
    ngayTao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (nguoiDungId) REFERENCES NguoiDung(id)
);

-- Thông báo
CREATE TABLE ThongBao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nguoiDungId INT,
    tieuDe VARCHAR(150),
    noiDung TEXT,
    daDoc BOOLEAN DEFAULT FALSE,
    ngayTao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (nguoiDungId) REFERENCES NguoiDung(id)
);

-- Kho hàng
CREATE TABLE KhoHang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sanPhamId INT,
    soLuong INT,
    capNhatLanCuoi DATETIME,
    FOREIGN KEY (sanPhamId) REFERENCES SanPham(id)
);

-- Khuyến mãi
CREATE TABLE KhuyenMai (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ten VARCHAR(100),
    moTa TEXT,
    ngayBatDau DATE,
    ngayKetThuc DATE
);

-- Báo cáo thống kê
CREATE TABLE BaoCaoThongKe (
    id INT AUTO_INCREMENT PRIMARY KEY,
    loai VARCHAR(100),
    giaTri DECIMAL(12,2),
    thoiGian DATE
);

-- Sổ địa chỉ người dùng
CREATE TABLE SoDiaChi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nguoiDungId INT,
    tenNguoiNhan VARCHAR(100),
    soDienThoai VARCHAR(15),
    diaChi TEXT,
    FOREIGN KEY (nguoiDungId) REFERENCES NguoiDung(id)
);
INSERT INTO SoDiaChi (nguoiDungId, tenNguoiNhan, soDienThoai, diaChi) VALUES
(1, 'nhan', '09694272711', 'Trường Cao đẳng Kỹ thuật Cao Thắng, 65, Huỳnh Thúc Kháng, Thành phố Hồ Chí Minh, HC 00084, Việt Nam'),
(1, 'Lan', '0969427271', 'Trường Đại học Bách khoa, Đại học Quốc gia Thành phố Hồ Chí Minh, 268, Lý Thường Kiệt, Quận 11, Thành phố Hồ Chí Minh, 70000, Việt Nam');
CREATE TABLE HoSoBe (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nguoiDungId INT,
    tenBe VARCHAR(100) NOT NULL,
    ngaySinh DATE,
    gioiTinh ENUM('Nam', 'Nữ'),
    canNang INT,
    ghiChu TEXT, 
    ngayTao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (nguoiDungId) REFERENCES NguoiDung(id)
);
CREATE TABLE SanPhamKhuyenMai (
    id INT AUTO_INCREMENT PRIMARY KEY,
    khuyenMaiId INT,
    sanPhamId INT,
    giamGia DECIMAL(10,2), -- số tiền giảm, hoặc bạn có thể dùng phần trăm nếu thích
    FOREIGN KEY (khuyenMaiId) REFERENCES KhuyenMai(id),
    FOREIGN KEY (sanPhamId) REFERENCES SanPham(id)
);
