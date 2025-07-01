<?php
require_once '../../config/db.php';
header('Content-Type: application/json');

$id = $_GET['id'] ?? 0;
$stmt = $conn->prepare("SELECT * FROM NguoiDung WHERE id = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    echo json_encode(["status" => "success", "data" => $row]);
} else {
    echo json_encode(["status" => "error", "message" => "Không tìm thấy người dùng"]);
}
?>