<?php
include("../config/db.php");

$data = json_decode(file_get_contents("php://input"));

$sql = "UPDATE SanPham
        SET loaiId = ?, danhMucId = ?, thuongHieuId = ?, ten = ?, moTa = ?, gia = ?, hinhAnh = ?, soLuong = ?, trangThai = ?
        WHERE id = ?";

$stmt = $conn->prepare($sql);
$stmt->bind_param(
    "iiissdsisi",
    $data->loaiId,
    $data->danhMucId,
    $data->thuongHieuId,
    $data->ten,
    $data->moTa,
    $data->gia,
    $data->hinhAnh,
    $data->soLuong,
    $data->trangThai,
    $data->id
);

if ($stmt->execute()) {
    echo json_encode(["success" => true]);
} else {
    echo json_encode(["success" => false, "error" => $stmt->error]);
}

$conn->close();
?>