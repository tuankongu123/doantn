<?php
include("../config/db.php");
header('Content-Type: application/json');

$nguoiDungId = $_GET["nguoiDungId"];

$sql = "SELECT g.id, g.soLuong, s.ten, s.gia, s.hinhAnh 
        FROM GioHang g
        JOIN SanPham s ON g.sanPhamId = s.id
        WHERE g.nguoiDungId = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $nguoiDungId);
$stmt->execute();
$result = $stmt->get_result();

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode(["status" => "success", "data" => $data]);
$conn->close();
