
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
('Độ tuổi sử dụng');

-- Gán giá trị thuộc tính cho sản phẩm
INSERT INTO GiaTriThuocTinh (sanPhamId, thuocTinhId, giaTri) VALUES 
(1, 1, 'NB'), 
(1, 4, '0-3 tháng'),
(3, 4, '1+ tuổi'), 
(7, 2, 'Cotton'), 
(8, 3, 'Xanh - Trắng');



-- Người dùng
CREATE TABLE NguoiDung (
    firebaseUid VARCHAR(128) UNIQUE,
    id INT AUTO_INCREMENT PRIMARY KEY,
    hoTen VARCHAR(100),
    soDienThoai VARCHAR(15) UNIQUE,
    diaChi TEXT,
    vaiTro ENUM('user','admin') DEFAULT 'user',
    xacThuc BOOLEAN DEFAULT FALSE,
    ngayTao DATETIME DEFAULT CURRENT_TIMESTAMP
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
    trangThai ENUM('cho_duyet','dang_giao','da_xong','huy') DEFAULT 'cho_duyet',
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
    diaChi TEXT,
    FOREIGN KEY (nguoiDungId) REFERENCES NguoiDung(id)
);
