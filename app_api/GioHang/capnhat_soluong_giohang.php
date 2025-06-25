<?php
include("../config/db.php");
header('Content-Type: application/json');

$data = json_decode(file_get_contents("php://input"), true);
$gioHangId = $data["gioHangId"];
$soLuong = $data["soLuong"];

$stmt = $conn->prepare("UPDATE GioHang SET soLuong = ? WHERE id = ?");
$stmt->bind_param("ii", $soLuong, $gioHangId);
$stmt->execute();

echo json_encode(["status" => "success"]);
$conn->close();
