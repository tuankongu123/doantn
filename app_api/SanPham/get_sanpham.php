<?php
header("Content-Type: application/json");
include("../config/db.php");

$sql = "SELECT s.id, s.ten, s.gia, s.hinhAnh, d.ten AS danhMuc, l.ten AS loai
        FROM SanPham s
        LEFT JOIN DanhMucSanPham d ON s.danhMucId = d.id
        LEFT JOIN LoaiSanPham l ON s.loaiId = l.id
        ORDER BY s.ngayTao DESC";

$result = $conn->query($sql);

$sanpham = [];

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $sanpham[] = $row;
    }
}

echo json_encode(["status" => "success", "data" => $sanpham]);
$conn->close();
?>
