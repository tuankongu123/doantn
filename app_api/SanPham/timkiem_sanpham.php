<?php
require_once '../config/db.php'; // kết nối CSDL bằng MySQLi
header('Content-Type: application/json; charset=utf-8');

if (!isset($_GET['keyword'])) {
    echo json_encode(['status' => 'error', 'message' => 'Thiếu từ khóa']);
    exit;
}

$keyword = '%' . $_GET['keyword'] . '%';

// Sử dụng prepared statement để tránh SQL injection
$sql = "SELECT * FROM SanPham WHERE ten LIKE ?";
$stmt = $conn->prepare($sql);

if ($stmt) {
    $stmt->bind_param("s", $keyword);
    $stmt->execute();
    $result = $stmt->get_result();

    $sanPhams = [];
    while ($row = $result->fetch_assoc()) {
        $sanPhams[] = $row;
    }

    echo json_encode([
        'status' => 'success',
        'data' => $sanPhams
    ]);
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Lỗi truy vấn: ' . $conn->error
    ]);
}
?>
