<?php
include("../config/db.php");
header("Content-Type: application/json");

if (!isset($_POST['id'])) {
    http_response_code(400);
    echo json_encode(['status' => 'error', 'message' => 'Thiếu ID đơn hàng']);
    exit;
}

$id = intval($_POST['id']);
$sql = "UPDATE DonHang SET trangThai = 'da_duyet' WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $id);

if ($stmt->execute()) {
    echo json_encode(['status' => 'success', 'message' => 'Đơn hàng đã được duyệt']);
} else {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Lỗi khi duyệt đơn']);
}
?>