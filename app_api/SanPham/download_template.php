<?php
require __DIR__ . '/../vendor/autoload.php';

use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

// Lấy loại file mẫu từ query string
$type = $_GET['type'] ?? 'sanPham';

// Tạo spreadsheet
$spreadsheet = new Spreadsheet();
$sheet = $spreadsheet->getActiveSheet();

switch ($type) {
    case 'sanPham':
        $sheet->setTitle("Sản phẩm");
        $sheet->fromArray([
            ['Tên sản phẩm', 'Giá', 'Số lượng', 'Mô tả', 'Hình ảnh', 'Danh mục ID', 'Loại ID', 'Thương hiệu ID'],
        ]);
        $filename = 'mau_san_pham.xlsx';
        break;

    case 'loaiSanPham':
        $sheet->setTitle("Loại sản phẩm");
        $sheet->fromArray([
            ['Danh mục ID', 'Tên loại sản phẩm'],
        ]);
        $filename = 'mau_loai_san_pham.xlsx';
        break;

    case 'voucher':
        $sheet->setTitle("Voucher");
        $sheet->fromArray([
            ['Mã voucher', 'Giá trị', 'Hạn sử dụng (YYYY-MM-DD)', 'Giới hạn lượt dùng'],
        ]);
        $filename = 'mau_voucher.xlsx';
        break;

    case 'khuyenMai':
        $sheet->setTitle("Khuyến mãi");
        $sheet->fromArray([
            ['Tên chương trình', 'Mô tả', 'Ngày bắt đầu (YYYY-MM-DD)', 'Ngày kết thúc (YYYY-MM-DD)'],
        ]);
        $filename = 'mau_khuyen_mai.xlsx';
        break;

    default:
        http_response_code(400);
        echo "Loại không hợp lệ.";
        exit;
}

// Xuất file Excel
header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
header("Content-Disposition: attachment; filename=\"$filename\"");
header('Cache-Control: max-age=0');

$writer = new Xlsx($spreadsheet);
$writer->save("php://output");
exit;
