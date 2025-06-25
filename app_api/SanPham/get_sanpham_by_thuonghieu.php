<?php
header("Content-Type: application/json");
include("../config/db.php");

if (!isset($_GET['thuongHieuId'])) {
    echo json_encode(["status" => "error", "message" => "Thiếu tham số thuongHieuId"]);
    exit;
}

$danhMucId = intval($_GET['thuongHieuId']);

$sql = "SELECT s.id, s.ten, s.gia, s.hinhAnh, s.moTa, 
               d.ten AS danhMuc, l.ten AS loai, t.ten AS thuongHieu
        FROM SanPham s
        LEFT JOIN DanhMucSanPham d ON s.danhMucId = d.id
        LEFT JOIN LoaiSanPham l ON s.loaiId = l.id
        LEFT JOIN ThuongHieu t ON s.thuongHieuId = t.id
        WHERE s.danhMucId = ? AND s.trangThai = 'active'
        ORDER BY s.ngayTao DESC";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $thuongHieuId);
$stmt->execute();
$result = $stmt->get_result();

$sanPham = [];

while ($row = $result->fetch_assoc()) {
    $sanPham[] = $row;
}

echo json_encode(["status" => "success", "data" => $sanPham]);
$conn->close();
