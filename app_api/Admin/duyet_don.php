<?php
require_once '../config/db.php';
header('Content-Type: application/json');

try {
    $data = json_decode(file_get_contents("php://input"), true);
    $donHangId = $data['id'] ?? 0;

    if (!$donHangId) {
        echo json_encode(['status' => 'error', 'message' => 'Thiếu ID đơn hàng']);
        exit;
    }

    $stmt = $pdo->prepare("UPDATE DonHang SET trangThai = 'da_duyet' WHERE id = :id");
    $stmt->bindParam(':id', $donHangId, PDO::PARAM_INT);
    $stmt->execute();

    echo json_encode(['status' => 'success', 'message' => 'Đã duyệt đơn']);
} catch (Exception $e) {
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}
?>
