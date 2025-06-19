<?php
header("Content-Type: application/json");
include("../config/db.php");

$sql = "SELECT id, ten, moTa FROM DanhMucSanPham ORDER BY ten ASC";
$result = $conn->query($sql);

$danhMuc = [];

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $danhMuc[] = $row;
    }
    echo json_encode([
        "status" => "success",
        "data" => $danhMuc
    ]);
} else {
    echo json_encode([
        "status" => "empty",
        "message" => "Không tìm thấy danh mục nào."
    ]);
}

$conn->close();
?>