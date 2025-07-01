<?php
require_once '../../config/db.php';
header('Content-Type: application/json');

$sql = "SELECT id, hoTen, soDienThoai, email, vaiTro, xacThuc, ngayTao FROM NguoiDung ORDER BY ngayTao DESC";
$result = $conn->query($sql);

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode([
    "status" => "success",
    "data" => $data
]);
?>