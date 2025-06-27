<?php
require_once '../config/db.php';
header('Content-Type: application/json');

try {
    $donHangId = $_GET['id'] ?? 0;

    $stmt = $pdo->prepare("
        SELECT sp.ten AS tenSanPham, ct.soLuong, ct.gia 
        FROM ChiTietDonHang ct
        JOIN SanPham sp ON sp.id = ct.sanPhamId
        WHERE ct.donHangId = :donHangId
    ");
    $stmt->bindParam(':donHangId', $donHangId, PDO::PARAM_INT);
    $stmt->execute();
    $chiTiet = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode(['status' => 'success', 'data' => $chiTiet]);
} catch (Exception $e) {
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}
?>
