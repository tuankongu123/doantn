<?php
header('Content-Type: application/json');
include("../config/db.php"); // Đường dẫn tới file cấu hình CSDL

// Hiển thị lỗi trong môi trường dev
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Nhận dữ liệu JSON từ client
$raw = file_get_contents("php://input");
$data = json_decode($raw, true);

// Ghi log để kiểm tra dữ liệu gửi từ client
file_put_contents("debug.log", date("c") . "\n" . $raw . "\n\n", FILE_APPEND);

// Kiểm tra kết nối DB
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["error" => "Lỗi kết nối CSDL"]);
    exit();
}

// Kiểm tra dữ liệu đầu vào
if (
    !$data ||
    !isset($data['danhSachSanPham']) ||
    !isset($data['tongTien']) ||
    !isset($data['phuongThucTt']) ||
    !isset($data['diaChiId'])
) {
    http_response_code(400);
    echo json_encode(["error" => "Thiếu dữ liệu đầu vào"]);
    exit();
}

// Gán biến
$nguoiDungId = 1; // Mặc định để test
$danhSachSanPham = $data['danhSachSanPham'];
$tongTien = $data['tongTien'];
$phuongThucTt = $data['phuongThucTt'];
$diaChiId = $data['diaChiId'];
$diaChiChiTiet = $data['diaChiChiTiet'] ?? [];
$diaChiText = $diaChiChiTiet['diaChi'] ?? ''; // <-- LẤY DỮ LIỆU ĐỊA CHỈ

$conn->begin_transaction();

try {
    // CHUẨN BỊ BIẾN RIÊNG để tránh lỗi bind_param
    $tien = floatval($tongTien);
    $pttt = strval($phuongThucTt);

    // Tạo đơn hàng
    $stmt = $conn->prepare("INSERT INTO donhang (nguoiDungId, tongTien, phuongThucTt) VALUES (?, ?, ?)");
    if (!$stmt) throw new Exception("Lỗi prepare đơn hàng: " . $conn->error);
    $stmt->bind_param("ids", $nguoiDungId, $tien, $pttt);
    if (!$stmt->execute()) throw new Exception("Không thể tạo đơn hàng: " . $stmt->error);
    $donHangId = $stmt->insert_id;
    $stmt->close();

    // Thêm từng chi tiết đơn hàng
    foreach ($danhSachSanPham as $sp) {
        $sanPhamId = $sp['sanPhamId'];
        $soLuongMua = $sp['soLuong'];

        // Khóa hàng tồn
        $stmt = $conn->prepare("SELECT soLuong, gia FROM sanpham WHERE id = ? FOR UPDATE");
        if (!$stmt) throw new Exception("Lỗi prepare SELECT: " . $conn->error);
        $stmt->bind_param("i", $sanPhamId);
        $stmt->execute();
        $stmt->bind_result($soLuongTon, $giaSanPham);
        if (!$stmt->fetch()) throw new Exception("Sản phẩm ID $sanPhamId không tồn tại");
        $stmt->close();

        if ($soLuongTon < $soLuongMua) {
            throw new Exception("Không đủ hàng tồn kho cho sản phẩm ID $sanPhamId");
        }

        // Thêm chi tiết đơn hàng (THÊM DIA CHI)
        $stmt = $conn->prepare("INSERT INTO chitietdonhang (donHangId, sanPhamId, soLuong, gia, diaChi) VALUES (?, ?, ?, ?, ?)");
        if (!$stmt) throw new Exception("Lỗi prepare chi tiết đơn hàng: " . $conn->error);
        $stmt->bind_param("iiids", $donHangId, $sanPhamId, $soLuongMua, $giaSanPham, $diaChiText);
        if (!$stmt->execute()) throw new Exception("Lỗi khi thêm chi tiết đơn hàng: " . $stmt->error);
        $stmt->close();

        // // Trừ tồn kho
        // $stmt = $conn->prepare("UPDATE sanpham SET soLuong = soLuong - ? WHERE id = ?");
        // if (!$stmt) throw new Exception("Lỗi prepare UPDATE tồn kho: " . $conn->error);
        // $stmt->bind_param("ii", $soLuongMua, $sanPhamId);
        // if (!$stmt->execute()) throw new Exception("Lỗi cập nhật tồn kho: " . $stmt->error);
        // $stmt->close();
    }

    // Hoàn tất giao dịch
    $conn->commit();

    echo json_encode([
        "success" => true,
        "donHangId" => $donHangId
    ]);
} catch (Exception $e) {
    $conn->rollback();
    http_response_code(500);
    echo json_encode([
        "error" => $e->getMessage()
    ]);
}

$conn->close();
