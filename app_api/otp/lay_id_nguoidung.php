<?php
include("../config/db.php");
header('Content-Type: application/json');

$data = json_decode(file_get_contents("php://input"), true);
$firebaseUid = $data["firebaseUid"];

$sql = "SELECT id FROM NguoiDung WHERE firebaseUid = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $firebaseUid);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    echo json_encode(["status" => "success", "id" => $row["id"]]);
} else {
    echo json_encode(["status" => "error", "message" => "Không tìm thấy người dùng"]);
}

$conn->close();
