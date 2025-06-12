<?php
header("Access-Control-Allow-Origin: *"); // Cho phép truy cập từ mọi nơi
header("Content-Type: application/json; charset=UTF-8");

// Kết nối MySQL
$conn = new mysqli("localhost", "root", "", "app_do_tre_em");

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Kết nối CSDL thất bại"]));
}

// Nhận dữ liệu từ Flutter
$phone = $_POST['phone'] ?? '';
$password = $_POST['password'] ?? '';

if ($phone == '' || $password == '') {
    echo json_encode(["success" => false, "message" => "Thiếu dữ liệu"]);
    exit;
}

// Truy vấn người dùng
$stmt = $conn->prepare("SELECT * FROM nguoi_dung WHERE so_dien_thoai = ?");
$stmt->bind_param("s", $phone);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();

    // So sánh mật khẩu (không mã hóa – nên dùng hash trong thực tế)
    if ($user['mat_khau'] == $password) {
        echo json_encode([
            "success" => true,
            "message" => "Đăng nhập thành công",
            "user" => [
                "id" => $user['id'],
                "so_dien_thoai" => $user['so_dien_thoai'],
                "ten" => $user['ten']
            ]
        ]);
    } else {
        echo json_encode(["success" => false, "message" => "Sai mật khẩu"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Số điện thoại chưa đăng ký"]);
}

$conn->close();
?>
