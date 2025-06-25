<?php
ob_clean();
header('Content-Type: application/json; charset=utf-8');
include_once(__DIR__ . '/../config/db.php');

// Lấy ID người dùng từ query string
$nguoiDungId = $_GET['id'] ?? null;

if (!$nguoiDungId) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Thiếu ID người dùng']);
    exit;
}

$sql = "SELECT * FROM SoDiaChi WHERE nguoiDungId = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $nguoiDungId);
$stmt->execute();
$result = $stmt->get_result();

$dsDiaChi = [];
while ($row = $result->fetch_assoc()) {
    $dsDiaChi[] = $row;
}

echo json_encode(['success' => true, 'data' => $dsDiaChi]);
