<?php
require_once '../../config/db.php';
header('Content-Type: application/json');

$id = $_POST['id'] ?? 0;
$vaiTro = $_POST['vaiTro'] ?? 'user'; // 'admin' hoặc 'user'

$stmt = $conn->prepare("UPDATE NguoiDung SET vaiTro = ? WHERE id = ?");
$stmt->bind_param("si", $vaiTro, $id);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Cập nhật vai trò thành công"]);
} else {
    echo json_encode(["status" => "error", "message" => "Thất bại"]);
}
?>