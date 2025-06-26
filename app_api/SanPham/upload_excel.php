<?php
require '../../vendor/autoload.php'; // Đường dẫn thư viện PhpSpreadsheet
include("../config/db.php");

use PhpOffice\PhpSpreadsheet\IOFactory;

header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['status' => 'error', 'message' => 'Chỉ hỗ trợ POST']);
    exit;
}

if (!isset($_FILES['file'])) {
    echo json_encode(['status' => 'error', 'message' => 'Không có file']);
    exit;
}

$fileTmp = $_FILES['file']['tmp_name'];

try {
    $spreadsheet = IOFactory::load($fileTmp);
    $sheet = $spreadsheet->getActiveSheet();
    $rows = $sheet->toArray();

    $lois = [];
    for ($i = 1; $i < count($rows); $i++) {
        $row = $rows[$i];
        $ten = trim($row[0] ?? '');
        $gia = floatval($row[1] ?? 0);
        $soLuong = intval($row[2] ?? 0);
        $moTa = trim($row[3] ?? '');
        $hinhAnh = trim($row[4] ?? '');
        $danhMucId = intval($row[5] ?? 0);
        $loaiId = intval($row[6] ?? 0);
        $thuongHieuId = intval($row[7] ?? 0);

        if (!$ten || !$gia || !$soLuong || !$danhMucId || !$loaiId || !$thuongHieuId) {
            $lois[] = [
                'dong' => $i + 1,
                'loi' => 'Thiếu hoặc sai định dạng ở cột bắt buộc',
            ];
            continue;
        }

        $stmt = $conn->prepare("INSERT INTO SanPham (ten, gia, soLuong, moTa, hinhAnh, danhMucId, loaiId, thuongHieuId) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("sdissiii", $ten, $gia, $soLuong, $moTa, $hinhAnh, $danhMucId, $loaiId, $thuongHieuId);
        $stmt->execute();
    }

   if (count($lois) > 0) {
    echo json_encode([
        'status' => 'error', 
        'message' => 'Có lỗi khi nhập dữ liệu',
        'errors' => $lois // Đổi từ 'loi' thành 'errors' để đồng bộ với Dart
    ]);
    exit;
}

} catch (Exception $e) {
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}
?>
