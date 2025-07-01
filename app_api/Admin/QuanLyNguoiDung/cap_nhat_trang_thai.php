<?php
require_once '../../config/db.php';
header('Content-Type: application/json');

$id = $_POST['id'] ?? 0;
$trangThai = $_POST['xacThuc'] ?? 0;

$stmt = $conn->prepare("UPDATE NguoiDung SET xacThuc = ? WHERE id = ?");
$stmt->bind_param("ii", $trangThai, $id);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Cập nhật trạng thái thành công"]);
} else {
    echo json_encode(["status" => "error", "message" => "Thất bại"]);
}
?>