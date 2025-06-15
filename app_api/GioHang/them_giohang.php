<?php
include("../config/db.php");
header('Content-Type: application/json');

$data = json_decode(file_get_contents("php://input"), true);

$nguoiDungId = $data["nguoiDungId"];
$sanPhamId = $data["sanPhamId"];
$soLuong = $data["soLuong"];

$sql = "SELECT * FROM GioHang WHERE nguoiDungId = ? AND sanPhamId = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ii", $nguoiDungId, $sanPhamId);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $update = "UPDATE GioHang SET soLuong = soLuong + ? WHERE nguoiDungId = ? AND sanPhamId = ?";
    $stmt = $conn->prepare($update);
    $stmt->bind_param("iii", $soLuong, $nguoiDungId, $sanPhamId);
    $stmt->execute();
} else {
    $insert = "INSERT INTO GioHang (nguoiDungId, sanPhamId, soLuong) VALUES (?, ?, ?)";
    $stmt = $conn->prepare($insert);
    $stmt->bind_param("iii", $nguoiDungId, $sanPhamId, $soLuong);
    $stmt->execute();
}

echo json_encode(["status" => "success", "message" => "Đã thêm vào giỏ hàng"]);
$conn->close();
