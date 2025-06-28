<?php
require_once '../config/db.php';
header('Content-Type: application/json');

try {
    $donHangId = $_GET['id'] ?? 0;

    $stmt = $conn->prepare("
        SELECT sp.ten AS tenSanPham, ct.soLuong, ct.gia 
        FROM ChiTietDonHang ct
        JOIN SanPham sp ON sp.id = ct.sanPhamId
        WHERE ct.donHangId = ?
    ");
    $stmt->bind_param("i", $donHangId);
    $stmt->execute();
    $result = $stmt->get_result();
    $chiTiet = [];

    while ($row = $result->fetch_assoc()) {
        $chiTiet[] = $row;
    }

    echo json_encode(['status' => 'success', 'data' => $chiTiet]);
} catch (Exception $e) {
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}
?>
