<?php
include("../config/db.php");
header('Content-Type: application/json');

$data = json_decode(file_get_contents("php://input"), true);
$firebaseUid = $data["firebaseUid"];
$soDienThoai = $data["soDienThoai"] ?? null;

// Tìm người dùng
$sql = "SELECT id FROM NguoiDung WHERE firebaseUid = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $firebaseUid);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    echo json_encode(["status" => "success", "id" => $row["id"]]);
} else {
    // Tạo mới người dùng nếu chưa có
    $insert = "INSERT INTO NguoiDung (firebaseUid, soDienThoai, vaiTro, xacThuc) VALUES (?, ?, 'user', 1)";
    $stmt = $conn->prepare($insert);
    $stmt->bind_param("ss", $firebaseUid, $soDienThoai);
    if ($stmt->execute()) {
        echo json_encode(["status" => "created", "id" => $stmt->insert_id]);
    } else {
        echo json_encode(["status" => "error", "message" => "Không thể tạo người dùng"]);
    }
}

$conn->close();
