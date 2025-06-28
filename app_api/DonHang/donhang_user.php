<?php
include("../config/db.php");
header('Content-Type: application/json');

$nguoiDungId = isset($_GET["nguoiDungId"]) ? intval($_GET["nguoiDungId"]) : 0;

if ($nguoiDungId <= 0) {
    echo json_encode(["status" => "error", "message" => "Thiếu hoặc sai nguoiDungId"]);
    exit;
}

$sql = "SELECT 
            dh.id AS id,
            nd.hoTen AS tenNguoiDung,
            dh.ngayTao AS ngayTao,
            dh.trangThai AS trangThai,
            dh.tongTien AS tongTien
        FROM donhang dh
        JOIN nguoidung nd ON dh.nguoiDungId = nd.id
        WHERE dh.nguoiDungId = ?
        ORDER BY dh.ngayTao DESC";

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
?>
