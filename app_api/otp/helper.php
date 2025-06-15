<?php
function generateOtp($length = 6) {
    return str_pad(rand(0, 999999), $length, '0', STR_PAD_LEFT);
}

// Gửi OTP (mô phỏng - in ra màn hình hoặc gọi API thật)
function sendSmsOtp($soDienThoai, $maOtp) {
    // TODO: Thay bằng API thật (Twilio, Viettel SMS...)
    // Ví dụ giả lập:
    echo "Gửi OTP $maOtp tới số: $soDienThoai\n";
    return true;
}
?>
