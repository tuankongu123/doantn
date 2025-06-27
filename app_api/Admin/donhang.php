<?php
require_once '../config/db.php';
header('Content-Type: application/json');
ob_clean();

// Chuyển mysqli sang PDO
try {
    $pdo = new PDO("mysql:host=localhost;dbname=app_data;charset=utf8mb4", "root", "");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $trangThai = $_GET['trangThai'] ?? null;

    $sql = "SELECT dh.id, dh.ngayTao, dh.tongTien, dh.trangThai, nd.hoTen 
            FROM DonHang dh 
            JOIN NguoiDung nd ON dh.nguoiDungId = nd.id";

    if ($trangThai && $trangThai !== 'tat_ca') {
        $sql .= " WHERE dh.trangThai = :trangThai";
    }

    $stmt = $pdo->prepare($sql);
    if ($trangThai && $trangThai !== 'tat_ca') {
        $stmt->bindParam(':trangThai', $trangThai);
    }

    $stmt->execute();
    $donHangs = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode(['status' => 'success', 'data' => $donHangs]);
} catch (Exception $e) {
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}
?>