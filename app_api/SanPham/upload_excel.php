<?php
require '../../vendor/autoload.php';
include("../config/db.php");

use PhpOffice\PhpSpreadsheet\IOFactory;

header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['status' => 'error', 'message' => 'Chỉ hỗ trợ phương thức POST']);
    exit;
}

if (!isset($_FILES['file'])) {
    http_response_code(400);
    echo json_encode(['status' => 'error', 'message' => 'Không có file được tải lên']);
    exit;
}

$allowedExtensions = ['xlsx', 'xls', 'csv'];
$fileExtension = strtolower(pathinfo($_FILES['file']['name'], PATHINFO_EXTENSION));

if (!in_array($fileExtension, $allowedExtensions)) {
    http_response_code(400);
    echo json_encode(['status' => 'error', 'message' => 'Chỉ chấp nhận file Excel (xlsx, xls, csv)']);
    exit;
}

if ($_FILES['file']['size'] > 5 * 1024 * 1024) {
    http_response_code(400);
    echo json_encode(['status' => 'error', 'message' => 'File quá lớn. Tối đa 5MB']);
    exit;
}

try {
    $conn->begin_transaction();
    $fileTmp = $_FILES['file']['tmp_name'];
    $spreadsheet = IOFactory::load($fileTmp);
    $sheet = $spreadsheet->getActiveSheet();
    $rows = $sheet->toArray();

    $errors = [];
    $successCount = 0;
    $totalRows = count($rows);

    // Lấy tên file upload để phân biệt api
    $targetTable = $_GET['type'] ?? 'sanpham';

    for ($i = 1; $i < $totalRows; $i++) {
        $row = $rows[$i];

        if ($targetTable === 'sanpham') {
            $ten = trim($row[0] ?? '');
            $gia = isset($row[1]) ? floatval(str_replace(',', '', $row[1])) : 0;
            $soLuong = isset($row[2]) ? intval($row[2]) : 0;
            $moTa = trim($row[3] ?? '');
            $hinhAnh = trim($row[4] ?? '');
            $danhMucId = isset($row[5]) ? intval($row[5]) : 0;
            $loaiId = isset($row[6]) ? intval($row[6]) : 0;
            $thuongHieuId = isset($row[7]) ? intval($row[7]) : 0;

            $currentErrors = [];
            if (empty($ten)) $currentErrors[] = "Thiếu tên";
            if ($gia <= 0) $currentErrors[] = "Giá không hợp lệ";
            if ($danhMucId <= 0 || $thuongHieuId <= 0) $currentErrors[] = "Danh mục / thương hiệu sai";

            if (!empty($currentErrors)) {
                $errors[] = ['dong' => $i + 1, 'loi' => implode(", ", $currentErrors), 'du_lieu' => $row];
                continue;
            }

            $stmt = $conn->prepare("INSERT INTO SanPham (ten, gia, soLuong, moTa, hinhAnh, danhMucId, loaiId, thuongHieuId) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
            $stmt->bind_param("sdissiii", $ten, $gia, $soLuong, $moTa, $hinhAnh, $danhMucId, $loaiId, $thuongHieuId);
        }
        elseif ($targetTable === 'loaisanpham') {
            $danhMucId = intval($row[0] ?? 0);
            $ten = trim($row[1] ?? '');

            if ($danhMucId <= 0 || empty($ten)) {
                $errors[] = ['dong' => $i + 1, 'loi' => 'Thiếu dữ liệu danh mục hoặc tên', 'du_lieu' => $row];
                continue;
            }

            $stmt = $conn->prepare("INSERT INTO LoaiSanPham (danhMucId, ten) VALUES (?, ?)");
            $stmt->bind_param("is", $danhMucId, $ten);
        }
        elseif ($targetTable === 'voucher') {
            $ma = trim($row[0] ?? '');
            $giaTri = floatval($row[1] ?? 0);
            $han = trim($row[2] ?? '');
            $gioiHan = intval($row[3] ?? 0);

            if (empty($ma) || $giaTri <= 0 || empty($han)) {
                $errors[] = ['dong' => $i + 1, 'loi' => 'Thiếu mã, giá trị hoặc hạn sử dụng', 'du_lieu' => $row];
                continue;
            }

            $stmt = $conn->prepare("INSERT INTO Voucher (ma, giaTri, hanSuDung, gioiHan) VALUES (?, ?, ?, ?)");
            $stmt->bind_param("sdsi", $ma, $giaTri, $han, $gioiHan);
        }
        elseif ($targetTable === 'khuyenmai') {
            $ten = trim($row[0] ?? '');
            $moTa = trim($row[1] ?? '');
            $ngayBatDau = trim($row[2] ?? '');
            $ngayKetThuc = trim($row[3] ?? '');

            if (empty($ten) || empty($ngayBatDau) || empty($ngayKetThuc)) {
                $errors[] = ['dong' => $i + 1, 'loi' => 'Thiếu tên hoặc ngày bắt đầu/kết thúc', 'du_lieu' => $row];
                continue;
            }

            $stmt = $conn->prepare("INSERT INTO KhuyenMai (ten, moTa, ngayBatDau, ngayKetThuc) VALUES (?, ?, ?, ?)");
            $stmt->bind_param("ssss", $ten, $moTa, $ngayBatDau, $ngayKetThuc);
        }

        if (!$stmt->execute()) {
            $errors[] = ['dong' => $i + 1, 'loi' => 'Lỗi database: ' . $stmt->error, 'du_lieu' => $row];
        } else {
            $successCount++;
        }
    }

    if (!empty($errors)) {
        $conn->rollback();
        http_response_code(400);
        echo json_encode([
            'status' => 'partial',
            'message' => 'Thêm một phần, có lỗi',
            'success_count' => $successCount,
            'error_count' => count($errors),
            'errors' => $errors
        ]);
    } else {
        $conn->commit();
        echo json_encode([
            'status' => 'success',
            'message' => 'Nhập dữ liệu thành công',
            'success_count' => $successCount
        ]);
    }
} catch (Exception $e) {
    $conn->rollback();
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'message' => 'Lỗi server: ' . $e->getMessage()
    ]);
}
?>
