<?php
include("../config/db.php");
header('Content-Type: application/json');

$nguoiDungId = $_GET["id"];

$sql = "SELECT id, firebaseUid, hoTen, soDienThoai, email, gioiTinh, ngaySinh, vaiTro, xacThuc, ngayTao 
        FROM NguoiDung 
        WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $nguoiDungId);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    echo json_encode(["status" => "success", "data" => $row]);
} else {
    echo json_encode(["status" => "error", "message" => "Không tìm thấy người dùng"]);
}

$conn->close();
