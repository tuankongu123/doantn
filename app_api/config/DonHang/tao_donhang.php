<?php
include("../config/db.php");
header('Content-Type: application/json');

// Lấy dữ liệu từ request
$data = json_decode(file_get_contents("php://input"), true);
$nguoiDungId = $data["nguoiDungId"];
$tongTien = $data["tongTien"];
$phuongThucTt = $data["phuongThucTt"];
$sanPhamList = $data["sanPhamList"]; // Mảng các sản phẩm gồm sanPhamId, soLuong, gia

// Kiểm tra dữ liệu
if (!$nguoiDungId || !$tongTien || !$phuongThucTt || !is_array($sanPhamList) || count($sanPhamList) === 0) {
    echo json_encode(["status" => "error", "message" => "Thiếu thông tin đơn hàng"]);
    exit;
}

// Tạo đơn hàng
$stmt = $conn->prepare("INSERT INTO DonHang (nguoiDungId, tongTien, phuongThucTt) VALUES (?, ?, ?)");
$stmt->bind_param("ids", $nguoiDungId, $tongTien, $phuongThucTt);
$stmt->execute();

if ($stmt->affected_rows <= 0) {
    echo json_encode(["status" => "error", "message" => "Tạo đơn hàng thất bại"]);
    exit;
}

$donHangId = $conn->insert_id;

// Thêm chi tiết đơn hàng
$insertCt = $conn->prepare("INSERT INTO ChiTietDonHang (donHangId, sanPhamId, soLuong, gia) VALUES (?, ?, ?, ?)");

foreach ($sanPhamList as $item) {
    $sanPhamId = $item["sanPhamId"];
    $soLuong = $item["soLuong"];
    $gia = $item["gia"];

    $insertCt->bind_param("iiid", $donHangId, $sanPhamId, $soLuong, $gia);
    $insertCt->execute();
}

// Xóa giỏ hàng của người dùng
$deleteCart = $conn->prepare("DELETE FROM GioHang WHERE nguoiDungId = ?");
$deleteCart->bind_param("i", $nguoiDungId);
$deleteCart->execute();

// Trả kết quả về client
echo json_encode(["status" => "success", "donHangId" => $donHangId]);

$conn->close();
?>
