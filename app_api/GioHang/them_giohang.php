<?php
include("../config/db.php");
header('Content-Type: application/json');

$data = json_decode(file_get_contents("php://input"), true);
$nguoiDungId = $data["nguoiDungId"];
$sanPhamId = $data["sanPhamId"];
$soLuong = $data["soLuong"];

$sqlCheck = "SELECT id, soLuong FROM GioHang WHERE nguoiDungId = ? AND sanPhamId = ?";
$stmt = $conn->prepare($sqlCheck);
$stmt->bind_param("ii", $nguoiDungId, $sanPhamId);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    $newQuantity = $row["soLuong"] + $soLuong;
    $update = $conn->prepare("UPDATE GioHang SET soLuong = ? WHERE id = ?");
    $update->bind_param("ii", $newQuantity, $row["id"]);
    $update->execute();
} else {
    $insert = $conn->prepare("INSERT INTO GioHang (nguoiDungId, sanPhamId, soLuong) VALUES (?, ?, ?)");
    $insert->bind_param("iii", $nguoiDungId, $sanPhamId, $soLuong);
    $insert->execute();
}

echo json_encode(["status" => "success"]);
$conn->close();
