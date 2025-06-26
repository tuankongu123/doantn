<?php
include("../config/db.php");

$data = json_decode(file_get_contents("php://input"));

$sql = "INSERT INTO SanPham (loaiId, danhMucId, thuongHieuId, ten, moTa, gia, hinhAnh, soLuong)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param(
    "iiisssdi",
    $data->loaiId,
    $data->danhMucId,
    $data->thuongHieuId,
    $data->ten,
    $data->moTa,
    $data->gia,
    $data->hinhAnh,
    $data->soLuong
);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "id" => $stmt->insert_id]);
} else {
    echo json_encode(["success" => false, "error" => $stmt->error]);
}

$conn->close();
?>