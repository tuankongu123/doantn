<?php
require 'db.php';
require 'helper.php';

$data = json_decode(file_get_contents("php://input"), true);
$soDienThoai = $data['soDienThoai'];

if (!$soDienThoai) {
    http_response_code(400);
    echo json_encode(["error" => "Thiếu số điện thoại"]);
    exit;
}

$maOtp = generateOtp();
$now = date('Y-m-d H:i:s');

// Ghi OTP vào DB
$stmt = $pdo->prepare("INSERT INTO OTP (soDienThoai, maOtp, thoiGianGui) VALUES (?, ?, ?)");
$stmt->execute([$soDienThoai, $maOtp, $now]);

// Gửi SMS
sendSmsOtp($soDienThoai, $maOtp);

// Đảm bảo người dùng tồn tại
$stmt = $pdo->prepare("SELECT id FROM NguoiDung WHERE soDienThoai = ?");
$stmt->execute([$soDienThoai]);
$user = $stmt->fetch();

if (!$user) {
    $stmt = $pdo->prepare("INSERT INTO NguoiDung (soDienThoai, vaiTro, ngayTao) VALUES (?, 'user', ?)");
    $stmt->execute([$soDienThoai, $now]);
}

echo json_encode(["message" => "Đã gửi mã OTP"]);
?>
