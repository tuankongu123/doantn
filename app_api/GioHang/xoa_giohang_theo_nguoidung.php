<?php
include("../config/db.php");
header('Content-Type: application/json');

$data = json_decode(file_get_contents("php://input"), true);
$nguoiDungId = $data["nguoiDungId"];

$stmt = $conn->prepare("DELETE FROM GioHang WHERE nguoiDungId = ?");
$stmt->bind_param("i", $nguoiDungId);
$stmt->execute();

echo json_encode(["status" => "success"]);
$conn->close();
