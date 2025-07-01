<?php
include("../config/db.php");
header("Content-Type: application/json");

if (!isset($_POST['id'])) {
    echo json_encode(['status' => 'error', 'message' => 'Thiếu ID đơn hàng']);
    exit;
}

$donHangId = intval($_POST['id']);

// Lấy chi tiết đơn hàng
$stmt = $conn->prepare("SELECT sanPhamId, soLuong FROM ChiTietDonHang WHERE donHangId = ?");
$stmt->bind_param("i", $donHangId);
$stmt->execute();
$result = $stmt->get_result();
$chiTiet = $result->fetch_all(MYSQLI_ASSOC);

// Kiểm tra tồn kho
foreach ($chiTiet as $item) {
    $sanPhamId = $item['sanPhamId'];
    $soLuong = $item['soLuong'];

    $stmt_check = $conn->prepare("SELECT soLuong FROM SanPham WHERE id = ?");
    $stmt_check->bind_param("i", $sanPhamId);
    $stmt_check->execute();
    $rs = $stmt_check->get_result()->fetch_assoc();

    if (!$rs || $rs['soLuong'] < $soLuong) {
        echo json_encode([
            'status' => 'error',
            'message' => "Sản phẩm ID $sanPhamId không đủ số lượng trong kho."
        ]);
        exit;
    }
}

// Trừ kho
foreach ($chiTiet as $item) {
    $stmt_update = $conn->prepare("UPDATE SanPham SET soLuong = soLuong - ? WHERE id = ?");
    $stmt_update->bind_param("ii", $item['soLuong'], $item['sanPhamId']);
    $stmt_update->execute();
}

// Cập nhật trạng thái
$stmt = $conn->prepare("UPDATE DonHang SET trangThai = 'da_duyet' WHERE id = ?");
$stmt->bind_param("i", $donHangId);
$stmt->execute();

echo json_encode(['status' => 'success', 'message' => 'Đã duyệt đơn hàng']);
?>