<?php
require_once '../config/db.php';
header('Content-Type: application/json');

if (!isset($_GET['keyword'])) {
    echo json_encode(['status' => 'error', 'message' => 'Thiếu từ khóa']);
    exit;
}

$keyword = '%' . $_GET['keyword'] . '%';

try {
    $pdo = (new Database())->getConnection();
    $stmt = $pdo->prepare("SELECT * FROM SanPham WHERE ten LIKE ?");
    $stmt->execute([$keyword]);

    $sanPhams = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'status' => 'success',
        'data' => $sanPhams
    ]);
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}
?>
