-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th6 27, 2025 lúc 09:11 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `app_data`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `baocaothongke`
--

CREATE TABLE `baocaothongke` (
  `id` int(11) NOT NULL,
  `loai` varchar(100) DEFAULT NULL,
  `giaTri` decimal(12,2) DEFAULT NULL,
  `thoiGian` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chitietdonhang`
--

CREATE TABLE `chitietdonhang` (
  `id` int(11) NOT NULL,
  `donHangId` int(11) DEFAULT NULL,
  `sanPhamId` int(11) DEFAULT NULL,
  `soLuong` int(11) DEFAULT NULL,
  `gia` decimal(10,2) DEFAULT NULL,
  `diaChi` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `chitietdonhang`
--
-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `danhgiasanpham`
--

CREATE TABLE `danhgiasanpham` (
  `id` int(11) NOT NULL,
  `sanPhamId` int(11) DEFAULT NULL,
  `nguoiDungId` int(11) DEFAULT NULL,
  `diemSo` int(11) DEFAULT NULL,
  `binhLuan` text DEFAULT NULL,
  `ngayTao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `danhmucsanpham`
--

CREATE TABLE `danhmucsanpham` (
  `id` int(11) NOT NULL,
  `ten` varchar(100) DEFAULT NULL,
  `moTa` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `danhmucsanpham`
--

INSERT INTO `danhmucsanpham` (`id`, `ten`, `moTa`) VALUES
(1, 'Tã & Bỉm', 'Sản phẩm vệ sinh cho bé'),
(2, 'Sữa & Dinh dưỡng', 'Sữa bột, sữa tươi, bổ sung vitamin'),
(3, 'Đồ chơi', 'Đồ chơi giáo dục, trí tuệ'),
(4, 'Quần áo', 'Thời trang cho trẻ sơ sinh và trẻ nhỏ'),
(5, 'Đồ dùng', 'Đồ dùng cho bé: bình sữa, khăn, gối...');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `donhang`
--

CREATE TABLE `donhang` (
  `id` int(11) NOT NULL,
  `nguoiDungId` int(11) DEFAULT NULL,
  `tongTien` decimal(10,2) DEFAULT NULL,
  `phuongThucTt` enum('cod','vi') DEFAULT NULL,
  `trangThai` enum('cho_duyet','da_duyet','dang_giao','da_xong','huy') DEFAULT 'cho_duyet',
  `ngayTao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `donhang`
--
-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `giatrithuoctinh`
--

CREATE TABLE `giatrithuoctinh` (
  `id` int(11) NOT NULL,
  `sanPhamId` int(11) DEFAULT NULL,
  `thuocTinhId` int(11) DEFAULT NULL,
  `giaTri` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `giatrithuoctinh`
--

INSERT INTO `giatrithuoctinh` (`id`, `sanPhamId`, `thuocTinhId`, `giaTri`) VALUES
(1, 1, 1, 'NB'),
(2, 1, 4, '0-3 tháng'),
(3, 3, 4, '1+ tuổi'),
(4, 7, 2, 'Cotton'),
(5, 8, 3, 'Xanh - Trắng');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `giohang`
--

CREATE TABLE `giohang` (
  `id` int(11) NOT NULL,
  `nguoiDungId` int(11) DEFAULT NULL,
  `sanPhamId` int(11) DEFAULT NULL,
  `soLuong` int(11) DEFAULT NULL,
  `ngayTao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `hosobe`
--

CREATE TABLE `hosobe` (
  `id` int(11) NOT NULL,
  `nguoiDungId` int(11) DEFAULT NULL,
  `tenBe` varchar(100) NOT NULL,
  `ngaySinh` date DEFAULT NULL,
  `gioiTinh` enum('Nam','Nữ') DEFAULT NULL,
  `canNang` int(11) DEFAULT NULL,
  `ghiChu` text DEFAULT NULL,
  `ngayTao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `khohang`
--

CREATE TABLE `khohang` (
  `id` int(11) NOT NULL,
  `sanPhamId` int(11) DEFAULT NULL,
  `soLuong` int(11) DEFAULT NULL,
  `capNhatLanCuoi` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `khuyenmai`
--

CREATE TABLE `khuyenmai` (
  `id` int(11) NOT NULL,
  `ten` varchar(100) DEFAULT NULL,
  `moTa` text DEFAULT NULL,
  `ngayBatDau` date DEFAULT NULL,
  `ngayKetThuc` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `lichnhacmuasam`
--

CREATE TABLE `lichnhacmuasam` (
  `id` int(11) NOT NULL,
  `nguoiDungId` int(11) DEFAULT NULL,
  `noiDung` text DEFAULT NULL,
  `thoiGian` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `loaisanpham`
--

CREATE TABLE `loaisanpham` (
  `id` int(11) NOT NULL,
  `danhMucId` int(11) DEFAULT NULL,
  `ten` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `loaisanpham`
--

INSERT INTO `loaisanpham` (`id`, `danhMucId`, `ten`) VALUES
(1, 1, 'Tã dán'),
(2, 1, 'Tã quần'),
(3, 2, 'Sữa bột'),
(4, 2, 'Sữa pha sẵn'),
(5, 3, 'Đồ chơi gỗ'),
(6, 3, 'Xếp hình'),
(7, 4, 'Bộ đồ sơ sinh'),
(8, 4, 'Quần áo mùa hè'),
(9, 5, 'Bình sữa'),
(10, 5, 'Khăn xô');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `muadinhky`
--

CREATE TABLE `muadinhky` (
  `id` int(11) NOT NULL,
  `nguoiDungId` int(11) DEFAULT NULL,
  `sanPhamId` int(11) DEFAULT NULL,
  `dinhKyNgay` int(11) DEFAULT NULL,
  `ngayBatDau` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `nguoidung`
--

CREATE TABLE `nguoidung` (
  `firebaseUid` varchar(128) DEFAULT NULL,
  `id` int(11) NOT NULL,
  `hinhAnh` text DEFAULT NULL,
  `hoTen` varchar(100) DEFAULT NULL,
  `soDienThoai` varchar(15) DEFAULT NULL,
  `gioiTinh` enum('Nam','Nữ') DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `ngaySinh` date DEFAULT NULL,
  `vaiTro` enum('user','admin') DEFAULT 'user',
  `xacThuc` tinyint(1) DEFAULT 0,
  `ngayTao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `nguoidung`
--

INSERT INTO `nguoidung` (`firebaseUid`, `id`, `hinhAnh`, `hoTen`, `soDienThoai`, `gioiTinh`, `email`, `ngaySinh`, `vaiTro`, `xacThuc`, `ngayTao`) VALUES
('sei42SOgx7XwoAWWg1A6KngNdyg1', 1, NULL, '', '0987654321', '', '', NULL, 'user', 1, '2025-06-19 20:57:58'),
('uid_admin_67890', 2, NULL, '', '0912345678', '', '', NULL, 'admin', 1, '2025-06-19 20:58:48');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `nguoidungvoucher`
--

CREATE TABLE `nguoidungvoucher` (
  `id` int(11) NOT NULL,
  `nguoiDungId` int(11) DEFAULT NULL,
  `voucherId` int(11) DEFAULT NULL,
  `ngayDung` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `otp`
--

CREATE TABLE `otp` (
  `id` int(11) NOT NULL,
  `soDienThoai` varchar(15) DEFAULT NULL,
  `maOtp` varchar(10) DEFAULT NULL,
  `thoiGianGui` datetime DEFAULT NULL,
  `daDung` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sanpham`
--

CREATE TABLE `sanpham` (
  `id` int(11) NOT NULL,
  `loaiId` int(11) DEFAULT NULL,
  `danhMucId` int(11) DEFAULT NULL,
  `thuongHieuId` int(11) DEFAULT NULL,
  `ten` varchar(150) DEFAULT NULL,
  `moTa` text DEFAULT NULL,
  `gia` decimal(10,2) DEFAULT NULL,
  `hinhAnh` text DEFAULT NULL,
  `soLuong` int(11) DEFAULT NULL,
  `trangThai` enum('active','off') DEFAULT 'active',
  `ngayTao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `sanpham`
--

INSERT INTO `sanpham` (`id`, `loaiId`, `danhMucId`, `thuongHieuId`, `ten`, `moTa`, `gia`, `hinhAnh`, `soLuong`, `trangThai`, `ngayTao`) VALUES
(1, 1, 1, 1, 'Tã dán Pampers NB90', 'Tã dán cho trẻ sơ sinh dưới 5kg', 220000.00, 'ta_dan_pampers_nb90.jfif', 92, 'active', '2025-06-26 21:10:30'),
(2, 2, 1, 2, 'Tã quần Bobby XL62', 'Tã quần dành cho bé 9-14kg', 265000.00, 'ta_quan_bobby_xl62.jfif', 120, 'active', '2025-06-26 21:10:30'),
(3, 3, 2, 2, 'Sữa Friso Gold 4 (900g)', 'Sữa dành cho bé trên 2 tuổi giúp phát triển trí não', 485000.00, 'sua_friso_gold_4_900g.jfif', 76, 'active', '2025-06-26 21:10:30'),
(4, 4, 2, 3, 'Sữa bột Dielac Alpha Step 2 (900g)', 'Dành cho trẻ từ 6-12 tháng tuổi', 295000.00, 'sua_dielac_alpha_2_900g.jfif', 92, 'active', '2025-06-26 21:10:30'),
(5, 5, 4, 6, 'Bộ đồ sơ sinh cotton mùa hè', 'Thoáng mát, phù hợp thời tiết nắng nóng', 125000.00, 'bo_so_sinh_mua_he.jfif', 65, 'active', '2025-06-26 21:10:30'),
(6, 6, 4, 6, 'Bộ quần áo bé trai 6 tháng', 'Chất vải thun cotton mềm mịn, size vừa cho bé 5-7kg', 110000.00, 'bo_quan_ao_be_trai_6m.jfif', 90, 'active', '2025-06-26 21:10:30'),
(7, 7, 3, 5, 'Đồ chơi xếp hình Lego Duplo', 'Giúp trẻ phát triển tư duy logic và vận động tinh', 499000.00, 'do_choi_lego_duplo.jfif', 70, 'active', '2025-06-26 21:10:30'),
(8, 8, 3, 5, 'Gấu bông hoạt hình', 'Gấu bông an toàn, lông không rụng, mềm mại', 165000.00, 'gau_bong_hoat_hinh.jfif', 107, 'active', '2025-06-26 21:10:30'),
(9, 9, 5, 1, 'Bình sữa Philips Avent 260ml', 'Bình sữa nhựa cao cấp không BPA, chống sặc tốt', 89000.00, 'binh_sua_philips_avent_260ml.jfif', 75, 'active', '2025-06-26 21:10:30'),
(10, 10, 5, 2, 'Máy hâm sữa Fatzbaby', 'Máy hâm sữa nhanh, giữ nhiệt hiệu quả', 465000.00, 'may_ham_sua_fatzbaby.jfif', 39, 'active', '2025-06-26 21:10:30');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sanphamkhuyenmai`
--

CREATE TABLE `sanphamkhuyenmai` (
  `id` int(11) NOT NULL,
  `khuyenMaiId` int(11) DEFAULT NULL,
  `sanPhamId` int(11) DEFAULT NULL,
  `giamGia` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sodiachi`
--

CREATE TABLE `sodiachi` (
  `id` int(11) NOT NULL,
  `nguoiDungId` int(11) DEFAULT NULL,
  `tenNguoiNhan` varchar(100) DEFAULT NULL,
  `soDienThoai` varchar(15) DEFAULT NULL,
  `diaChi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `sodiachi`
--

INSERT INTO `sodiachi` (`id`, `nguoiDungId`, `tenNguoiNhan`, `soDienThoai`, `diaChi`) VALUES
(1, 1, 'nhan', '09694272711', 'Trường Cao đẳng Kỹ thuật Cao Thắng, 65, Huỳnh Thúc Kháng, Thành phố Hồ Chí Minh, HC 00084, Việt Nam'),
(2, 1, 'Lan', '0969427271', 'Trường Đại học Bách khoa, Đại học Quốc gia Thành phố Hồ Chí Minh, 268, Lý Thường Kiệt, Quận 11, Thành phố Hồ Chí Minh, 70000, Việt Nam');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `thongbao`
--

CREATE TABLE `thongbao` (
  `id` int(11) NOT NULL,
  `nguoiDungId` int(11) DEFAULT NULL,
  `tieuDe` varchar(150) DEFAULT NULL,
  `noiDung` text DEFAULT NULL,
  `daDoc` tinyint(1) DEFAULT 0,
  `ngayTao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `thuoctinh`
--

CREATE TABLE `thuoctinh` (
  `id` int(11) NOT NULL,
  `ten` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `thuoctinh`
--

INSERT INTO `thuoctinh` (`id`, `ten`) VALUES
(1, 'Size'),
(2, 'Chất liệu'),
(3, 'Màu sắc'),
(4, 'Độ tuổi sử dụng');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `thuonghieu`
--

CREATE TABLE `thuonghieu` (
  `id` int(11) NOT NULL,
  `ten` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `thuonghieu`
--

INSERT INTO `thuonghieu` (`id`, `ten`) VALUES
(1, 'Pampers'),
(2, 'Huggies'),
(3, 'Abbott'),
(4, 'Nestlé'),
(5, 'Lego'),
(6, 'Fisher-Price');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tichdiem`
--

CREATE TABLE `tichdiem` (
  `id` int(11) NOT NULL,
  `nguoiDungId` int(11) DEFAULT NULL,
  `diem` int(11) DEFAULT NULL,
  `moTa` text DEFAULT NULL,
  `ngayTao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tinnhanchatbot`
--

CREATE TABLE `tinnhanchatbot` (
  `id` int(11) NOT NULL,
  `nguoiDungId` int(11) DEFAULT NULL,
  `noiDung` text DEFAULT NULL,
  `laBot` tinyint(1) DEFAULT NULL,
  `ngayTao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `voucher`
--

CREATE TABLE `voucher` (
  `id` int(11) NOT NULL,
  `ma` varchar(50) DEFAULT NULL,
  `giaTri` decimal(10,2) DEFAULT NULL,
  `hanSuDung` date DEFAULT NULL,
  `gioiHan` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `yeucauhoantra`
--

CREATE TABLE `yeucauhoantra` (
  `id` int(11) NOT NULL,
  `donHangId` int(11) DEFAULT NULL,
  `lyDo` text DEFAULT NULL,
  `trangThai` enum('cho_duyet','chap_thuan','tu_choi') DEFAULT 'cho_duyet',
  `ngayTao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `baocaothongke`
--
ALTER TABLE `baocaothongke`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `chitietdonhang`
--
ALTER TABLE `chitietdonhang`
  ADD PRIMARY KEY (`id`),
  ADD KEY `donHangId` (`donHangId`),
  ADD KEY `sanPhamId` (`sanPhamId`);

--
-- Chỉ mục cho bảng `danhgiasanpham`
--
ALTER TABLE `danhgiasanpham`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sanPhamId` (`sanPhamId`),
  ADD KEY `nguoiDungId` (`nguoiDungId`);

--
-- Chỉ mục cho bảng `danhmucsanpham`
--
ALTER TABLE `danhmucsanpham`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `donhang`
--
ALTER TABLE `donhang`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nguoiDungId` (`nguoiDungId`);

--
-- Chỉ mục cho bảng `giatrithuoctinh`
--
ALTER TABLE `giatrithuoctinh`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sanPhamId` (`sanPhamId`),
  ADD KEY `thuocTinhId` (`thuocTinhId`);

--
-- Chỉ mục cho bảng `giohang`
--
ALTER TABLE `giohang`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nguoiDungId` (`nguoiDungId`),
  ADD KEY `sanPhamId` (`sanPhamId`);

--
-- Chỉ mục cho bảng `hosobe`
--
ALTER TABLE `hosobe`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nguoiDungId` (`nguoiDungId`);

--
-- Chỉ mục cho bảng `khohang`
--
ALTER TABLE `khohang`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sanPhamId` (`sanPhamId`);

--
-- Chỉ mục cho bảng `khuyenmai`
--
ALTER TABLE `khuyenmai`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `lichnhacmuasam`
--
ALTER TABLE `lichnhacmuasam`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nguoiDungId` (`nguoiDungId`);

--
-- Chỉ mục cho bảng `loaisanpham`
--
ALTER TABLE `loaisanpham`
  ADD PRIMARY KEY (`id`),
  ADD KEY `danhMucId` (`danhMucId`);

--
-- Chỉ mục cho bảng `muadinhky`
--
ALTER TABLE `muadinhky`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nguoiDungId` (`nguoiDungId`),
  ADD KEY `sanPhamId` (`sanPhamId`);

--
-- Chỉ mục cho bảng `nguoidung`
--
ALTER TABLE `nguoidung`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `firebaseUid` (`firebaseUid`),
  ADD UNIQUE KEY `soDienThoai` (`soDienThoai`);

--
-- Chỉ mục cho bảng `nguoidungvoucher`
--
ALTER TABLE `nguoidungvoucher`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nguoiDungId` (`nguoiDungId`),
  ADD KEY `voucherId` (`voucherId`);

--
-- Chỉ mục cho bảng `otp`
--
ALTER TABLE `otp`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `sanpham`
--
ALTER TABLE `sanpham`
  ADD PRIMARY KEY (`id`),
  ADD KEY `loaiId` (`loaiId`),
  ADD KEY `danhMucId` (`danhMucId`),
  ADD KEY `thuongHieuId` (`thuongHieuId`);

--
-- Chỉ mục cho bảng `sanphamkhuyenmai`
--
ALTER TABLE `sanphamkhuyenmai`
  ADD PRIMARY KEY (`id`),
  ADD KEY `khuyenMaiId` (`khuyenMaiId`),
  ADD KEY `sanPhamId` (`sanPhamId`);

--
-- Chỉ mục cho bảng `sodiachi`
--
ALTER TABLE `sodiachi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nguoiDungId` (`nguoiDungId`);

--
-- Chỉ mục cho bảng `thongbao`
--
ALTER TABLE `thongbao`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nguoiDungId` (`nguoiDungId`);

--
-- Chỉ mục cho bảng `thuoctinh`
--
ALTER TABLE `thuoctinh`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `thuonghieu`
--
ALTER TABLE `thuonghieu`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `tichdiem`
--
ALTER TABLE `tichdiem`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nguoiDungId` (`nguoiDungId`);

--
-- Chỉ mục cho bảng `tinnhanchatbot`
--
ALTER TABLE `tinnhanchatbot`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nguoiDungId` (`nguoiDungId`);

--
-- Chỉ mục cho bảng `voucher`
--
ALTER TABLE `voucher`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `yeucauhoantra`
--
ALTER TABLE `yeucauhoantra`
  ADD PRIMARY KEY (`id`),
  ADD KEY `donHangId` (`donHangId`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `baocaothongke`
--
ALTER TABLE `baocaothongke`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `chitietdonhang`
--
ALTER TABLE `chitietdonhang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `danhgiasanpham`
--
ALTER TABLE `danhgiasanpham`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `danhmucsanpham`
--
ALTER TABLE `danhmucsanpham`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `donhang`
--
ALTER TABLE `donhang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT cho bảng `giatrithuoctinh`
--
ALTER TABLE `giatrithuoctinh`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `giohang`
--
ALTER TABLE `giohang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `hosobe`
--
ALTER TABLE `hosobe`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `khohang`
--
ALTER TABLE `khohang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `khuyenmai`
--
ALTER TABLE `khuyenmai`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `lichnhacmuasam`
--
ALTER TABLE `lichnhacmuasam`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `loaisanpham`
--
ALTER TABLE `loaisanpham`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT cho bảng `muadinhky`
--
ALTER TABLE `muadinhky`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `nguoidung`
--
ALTER TABLE `nguoidung`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `nguoidungvoucher`
--
ALTER TABLE `nguoidungvoucher`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `otp`
--
ALTER TABLE `otp`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `sanpham`
--
ALTER TABLE `sanpham`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT cho bảng `sanphamkhuyenmai`
--
ALTER TABLE `sanphamkhuyenmai`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `sodiachi`
--
ALTER TABLE `sodiachi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `thongbao`
--
ALTER TABLE `thongbao`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `thuoctinh`
--
ALTER TABLE `thuoctinh`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `thuonghieu`
--
ALTER TABLE `thuonghieu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `tichdiem`
--
ALTER TABLE `tichdiem`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `tinnhanchatbot`
--
ALTER TABLE `tinnhanchatbot`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `voucher`
--
ALTER TABLE `voucher`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `yeucauhoantra`
--
ALTER TABLE `yeucauhoantra`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `chitietdonhang`
--
ALTER TABLE `chitietdonhang`
  ADD CONSTRAINT `chitietdonhang_ibfk_1` FOREIGN KEY (`donHangId`) REFERENCES `donhang` (`id`),
  ADD CONSTRAINT `chitietdonhang_ibfk_2` FOREIGN KEY (`sanPhamId`) REFERENCES `sanpham` (`id`);

--
-- Các ràng buộc cho bảng `danhgiasanpham`
--
ALTER TABLE `danhgiasanpham`
  ADD CONSTRAINT `danhgiasanpham_ibfk_1` FOREIGN KEY (`sanPhamId`) REFERENCES `sanpham` (`id`),
  ADD CONSTRAINT `danhgiasanpham_ibfk_2` FOREIGN KEY (`nguoiDungId`) REFERENCES `nguoidung` (`id`);

--
-- Các ràng buộc cho bảng `donhang`
--
ALTER TABLE `donhang`
  ADD CONSTRAINT `donhang_ibfk_1` FOREIGN KEY (`nguoiDungId`) REFERENCES `nguoidung` (`id`);

--
-- Các ràng buộc cho bảng `giatrithuoctinh`
--
ALTER TABLE `giatrithuoctinh`
  ADD CONSTRAINT `giatrithuoctinh_ibfk_1` FOREIGN KEY (`sanPhamId`) REFERENCES `sanpham` (`id`),
  ADD CONSTRAINT `giatrithuoctinh_ibfk_2` FOREIGN KEY (`thuocTinhId`) REFERENCES `thuoctinh` (`id`);

--
-- Các ràng buộc cho bảng `giohang`
--
ALTER TABLE `giohang`
  ADD CONSTRAINT `giohang_ibfk_1` FOREIGN KEY (`nguoiDungId`) REFERENCES `nguoidung` (`id`),
  ADD CONSTRAINT `giohang_ibfk_2` FOREIGN KEY (`sanPhamId`) REFERENCES `sanpham` (`id`);

--
-- Các ràng buộc cho bảng `hosobe`
--
ALTER TABLE `hosobe`
  ADD CONSTRAINT `hosobe_ibfk_1` FOREIGN KEY (`nguoiDungId`) REFERENCES `nguoidung` (`id`);

--
-- Các ràng buộc cho bảng `khohang`
--
ALTER TABLE `khohang`
  ADD CONSTRAINT `khohang_ibfk_1` FOREIGN KEY (`sanPhamId`) REFERENCES `sanpham` (`id`);

--
-- Các ràng buộc cho bảng `lichnhacmuasam`
--
ALTER TABLE `lichnhacmuasam`
  ADD CONSTRAINT `lichnhacmuasam_ibfk_1` FOREIGN KEY (`nguoiDungId`) REFERENCES `nguoidung` (`id`);

--
-- Các ràng buộc cho bảng `loaisanpham`
--
ALTER TABLE `loaisanpham`
  ADD CONSTRAINT `loaisanpham_ibfk_1` FOREIGN KEY (`danhMucId`) REFERENCES `danhmucsanpham` (`id`);

--
-- Các ràng buộc cho bảng `muadinhky`
--
ALTER TABLE `muadinhky`
  ADD CONSTRAINT `muadinhky_ibfk_1` FOREIGN KEY (`nguoiDungId`) REFERENCES `nguoidung` (`id`),
  ADD CONSTRAINT `muadinhky_ibfk_2` FOREIGN KEY (`sanPhamId`) REFERENCES `sanpham` (`id`);

--
-- Các ràng buộc cho bảng `nguoidungvoucher`
--
ALTER TABLE `nguoidungvoucher`
  ADD CONSTRAINT `nguoidungvoucher_ibfk_1` FOREIGN KEY (`nguoiDungId`) REFERENCES `nguoidung` (`id`),
  ADD CONSTRAINT `nguoidungvoucher_ibfk_2` FOREIGN KEY (`voucherId`) REFERENCES `voucher` (`id`);

--
-- Các ràng buộc cho bảng `sanpham`
--
ALTER TABLE `sanpham`
  ADD CONSTRAINT `sanpham_ibfk_1` FOREIGN KEY (`loaiId`) REFERENCES `loaisanpham` (`id`),
  ADD CONSTRAINT `sanpham_ibfk_2` FOREIGN KEY (`danhMucId`) REFERENCES `danhmucsanpham` (`id`),
  ADD CONSTRAINT `sanpham_ibfk_3` FOREIGN KEY (`thuongHieuId`) REFERENCES `thuonghieu` (`id`);

--
-- Các ràng buộc cho bảng `sanphamkhuyenmai`
--
ALTER TABLE `sanphamkhuyenmai`
  ADD CONSTRAINT `sanphamkhuyenmai_ibfk_1` FOREIGN KEY (`khuyenMaiId`) REFERENCES `khuyenmai` (`id`),
  ADD CONSTRAINT `sanphamkhuyenmai_ibfk_2` FOREIGN KEY (`sanPhamId`) REFERENCES `sanpham` (`id`);

--
-- Các ràng buộc cho bảng `sodiachi`
--
ALTER TABLE `sodiachi`
  ADD CONSTRAINT `sodiachi_ibfk_1` FOREIGN KEY (`nguoiDungId`) REFERENCES `nguoidung` (`id`);

--
-- Các ràng buộc cho bảng `thongbao`
--
ALTER TABLE `thongbao`
  ADD CONSTRAINT `thongbao_ibfk_1` FOREIGN KEY (`nguoiDungId`) REFERENCES `nguoidung` (`id`);

--
-- Các ràng buộc cho bảng `tichdiem`
--
ALTER TABLE `tichdiem`
  ADD CONSTRAINT `tichdiem_ibfk_1` FOREIGN KEY (`nguoiDungId`) REFERENCES `nguoidung` (`id`);

--
-- Các ràng buộc cho bảng `tinnhanchatbot`
--
ALTER TABLE `tinnhanchatbot`
  ADD CONSTRAINT `tinnhanchatbot_ibfk_1` FOREIGN KEY (`nguoiDungId`) REFERENCES `nguoidung` (`id`);

--
-- Các ràng buộc cho bảng `yeucauhoantra`
--
ALTER TABLE `yeucauhoantra`
  ADD CONSTRAINT `yeucauhoantra_ibfk_1` FOREIGN KEY (`donHangId`) REFERENCES `donhang` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
