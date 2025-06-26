<?php
include("../config/db.php");

$data = json_decode(file_get_contents("php://input"));
$sanPhamId = $data->sanPhamId;
$soLuongNhap = $data->soLuong;

$conn->begin_transaction();

try {
    // Cập nhật số lượng sản phẩm
    $sql1 = "UPDATE SanPham SET soLuong = soLuong + ? WHERE id = ?";
    $stmt1 = $conn->prepare($sql1);
    $stmt1->bind_param("ii", $soLuongNhap, $sanPhamId);
    $stmt1->execute();

    // Ghi nhận nhập kho
    $sql2 = "INSERT INTO KhoHang (sanPhamId, soLuong, capNhatLanCuoi)
             VALUES (?, ?, NOW())
             ON DUPLICATE KEY UPDATE soLuong = soLuong + VALUES(soLuong), capNhatLanCuoi = NOW()";
    $stmt2 = $conn->prepare($sql2);
    $stmt2->bind_param("ii", $sanPhamId, $soLuongNhap);
    $stmt2->execute();

    $conn->commit();
    echo json_encode(["success" => true]);
} catch (Exception $e) {
    $conn->rollback();
    echo json_encode(["success" => false, "error" => $e->getMessage()]);
}

$conn->close();
?>