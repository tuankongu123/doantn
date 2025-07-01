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

// Cộng lại kho
foreach ($chiTiet as $item) {
    $stmt_update = $conn->prepare("UPDATE SanPham SET soLuong = soLuong + ? WHERE id = ?");
    $stmt_update->bind_param("ii", $item['soLuong'], $item['sanPhamId']);
    $stmt_update->execute();
}

// Cập nhật trạng thái
$stmt = $conn->prepare("UPDATE DonHang SET trangThai = 'da_huy' WHERE id = ?");
$stmt->bind_param("i", $donHangId);
$stmt->execute();

echo json_encode(['status' => 'success', 'message' => 'Đã hủy đơn hàng và hoàn kho']);
?>