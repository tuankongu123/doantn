<?php
require 'db.php';

$data = json_decode(file_get_contents("php://input"), true);
$soDienThoai = $data['soDienThoai'];
$maOtp = $data['otp'];

if (!$soDienThoai || !$maOtp) {
    http_response_code(400);
    echo json_encode(["error" => "Thiếu số điện thoại hoặc mã OTP"]);
    exit;
}

// Kiểm tra OTP trong 5 phút gần nhất
$stmt = $pdo->prepare("SELECT * FROM OTP WHERE soDienThoai = ? AND maOtp = ? AND daDung = 0 AND thoiGianGui >= (NOW() - INTERVAL 5 MINUTE) ORDER BY thoiGianGui DESC LIMIT 1");
$stmt->execute([$soDienThoai, $maOtp]);
$otp = $stmt->fetch();

if (!$otp) {
    http_response_code(401);
    echo json_encode(["error" => "Mã OTP không hợp lệ hoặc đã hết hạn"]);
    exit;
}

// Cập nhật OTP là đã dùng
$stmt = $pdo->prepare("UPDATE OTP SET daDung = 1 WHERE id = ?");
$stmt->execute([$otp['id']]);

// Cập nhật trạng thái xác thực người dùng
$stmt = $pdo->prepare("UPDATE NguoiDung SET xacThuc = 1 WHERE soDienThoai = ?");
$stmt->execute([$soDienThoai]);

echo json_encode(["message" => "Xác thực thành công"]);
?>
