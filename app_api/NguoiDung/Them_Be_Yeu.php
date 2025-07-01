<?php
header('Content-Type: application/json');
include_once(__DIR__ . '/../config/db.php');

// Đọc JSON đầu vào và log lại
$raw = file_get_contents("php://input");
file_put_contents("log.txt", $raw);

$data = json_decode($raw, true);

// Kiểm tra dữ liệu JSON
if (!$data || !is_array($data)) {
    echo json_encode([
        'success' => false,
        'error' => 'Dữ liệu JSON không hợp lệ',
        'raw' => $raw
    ]);
    exit;
}

// Lấy action
$action = $data['action'] ?? null;
if (!$action) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Thiếu tham số action']);
    exit;
}

// XỬ LÝ: THÊM BÉ YÊU
if ($action === 'them') {
    // Cho phép mặc định test với nguoiDungId = 1
    $nguoiDungId = $data['nguoiDungId'] ?? 1;
    $tenBe = $data['tenBe'] ?? '';
    $ngaySinh = $data['ngaySinh'] ?? '';
    $gioiTinh = $data['gioiTinh'] ?? '';
    $canNang = $data['canNang'] ?? null;

    if (!$tenBe || !$ngaySinh || !$gioiTinh || !$canNang) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'Dữ liệu không hợp lệ']);
        exit;
    }

    $sql = "INSERT INTO HoSoBe (nguoiDungId, tenBe, ngaySinh, gioiTinh, canNang) VALUES (?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    if (!$stmt) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'Lỗi prepare: ' . $conn->error]);
        exit;
    }

    $stmt->bind_param("isssi", $nguoiDungId, $tenBe, $ngaySinh, $gioiTinh, $canNang);
    if ($stmt->execute()) {
        echo json_encode(['success' => true]);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'Lỗi thêm bé: ' . $stmt->error]);
    }

}

// XỬ LÝ: CẬP NHẬT BÉ YÊU
elseif ($action === 'sua') {
    $id = $data['id'] ?? null;
    $tenBe = $data['tenBe'] ?? '';
    $ngaySinh = $data['ngaySinh'] ?? '';
    $gioiTinh = $data['gioiTinh'] ?? '';
    $canNang = $data['canNang'] ?? null;

    if (!$id || !$tenBe || !$ngaySinh || !$gioiTinh || !$canNang) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'Dữ liệu không hợp lệ']);
        exit;
    }

    $sql = "UPDATE HoSoBe SET tenBe = ?, ngaySinh = ?, gioiTinh = ?, canNang = ? WHERE id = ?";
    $stmt = $conn->prepare($sql);
    if (!$stmt) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'Lỗi prepare: ' . $conn->error]);
        exit;
    }

    $stmt->bind_param("sssii", $tenBe, $ngaySinh, $gioiTinh, $canNang, $id);
    if ($stmt->execute()) {
        echo json_encode(['success' => true]);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'Lỗi cập nhật: ' . $stmt->error]);
    }
}

// XỬ LÝ: XÓA BÉ YÊU
elseif ($action === 'xoa') {
    $id = $data['id'] ?? null;
    if (!$id) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'Thiếu ID bé yêu']);
        exit;
    }

    $sql = "DELETE FROM HoSoBe WHERE id = ?";
    $stmt = $conn->prepare($sql);
    if (!$stmt) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'Lỗi prepare: ' . $conn->error]);
        exit;
    }

    $stmt->bind_param("i", $id);
    if ($stmt->execute()) {
        echo json_encode(['success' => true]);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'Lỗi xóa: ' . $stmt->error]);
    }

} else {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Action không hợp lệ']);
}
?>
