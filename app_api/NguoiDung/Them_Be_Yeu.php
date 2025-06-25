<?php
ob_clean();
header('Content-Type: application/json');

include_once(__DIR__ . '/../config/db.php');

$data = json_decode(file_get_contents("php://input"), true);
$tenBe = $data['tenBe'];
$ngaySinh = $data['ngaySinh'];
$gioiTinh = $data['gioiTinh'];
$nguoiDungId = $data['nguoiDungId'];

$sql = "INSERT INTO BeYeu (nguoiDungId, tenBe, ngaySinh, gioiTinh) VALUES (?, ?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("isss", $nguoiDungId, $tenBe, $ngaySinh, $gioiTinh);

if ($stmt->execute()) {
    echo json_encode(["success" => true]);
} else {
    echo json_encode(["success" => false, "error" => $stmt->error]);
}
