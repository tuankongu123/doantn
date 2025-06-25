<?php
include("../config/db.php");
header('Content-Type: application/json');

$data = json_decode(file_get_contents("php://input"), true);
$gioHangId = $data["gioHangId"];

$stmt = $conn->prepare("DELETE FROM GioHang WHERE id = ?");
$stmt->bind_param("i", $gioHangId);
$stmt->execute();

echo json_encode(["status" => "success"]);
$conn->close();
