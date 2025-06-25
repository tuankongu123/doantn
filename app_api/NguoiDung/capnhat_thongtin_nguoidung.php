<?php
include("../config/db.php");
header('Content-Type: application/json');

$data = json_decode(file_get_contents("php://input"), true);

$id = $data["id"];
$hoTen = $data["hoTen"];
$soDienThoai = $data["soDienThoai"];
$email = $data["email"];
$gioiTinh = $data["gioiTinh"];
$ngaySinh = $data["ngaySinh"]; // định dạng yyyy-mm-dd

$sql = "UPDATE NguoiDung 
        SET hoTen = ?, soDienThoai = ?, email = ?, gioiTinh = ?, ngaySinh = ?
        WHERE id = ?";

$stmt = $conn->prepare($sql);
$stmt->bind_param("sssssi", $hoTen, $soDienThoai, $email, $gioiTinh, $ngaySinh, $id);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Cập nhật thành công"]);
} else {
    echo json_encode(["status" => "error", "message" => "Cập nhật thất bại"]);
}

$conn->close();
