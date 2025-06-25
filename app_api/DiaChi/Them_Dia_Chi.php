<?php
ob_clean();
header('Content-Type: application/json; charset=utf-8');

include_once(__DIR__ . '/../config/db.php');

$data = json_decode(file_get_contents("php://input"), true);

$action = $data['action'] ?? null;

if (!$action) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Thiếu tham số action']);
    exit;
}

if ($action === 'them') {
    $nguoiDungId = $data['nguoiDungId'] ?? null;
    $ten = $data['tenNguoiNhan'] ?? '';
    $sdt = $data['soDienThoai'] ?? '';
    $diaChi = $data['diaChi'] ?? '';

    if (!$nguoiDungId || !$ten || !$sdt || !$diaChi) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'Dữ liệu không hợp lệ']);
        exit;
    }

    $sql = "INSERT INTO SoDiaChi (nguoiDungId, tenNguoiNhan, soDienThoai, diaChi) VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);

    if (!$stmt) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'Lỗi prepare: ' . $conn->error]);
        exit;
    }

    $stmt->bind_param("isss", $nguoiDungId, $ten, $sdt, $diaChi);

    if ($stmt->execute()) {
        echo json_encode(['success' => true]);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'Lỗi thêm địa chỉ: ' . $stmt->error]);
    }

} elseif ($action === 'sua') {
    $id = $data['id'] ?? null;
    $ten = $data['tenNguoiNhan'] ?? '';
    $sdt = $data['soDienThoai'] ?? '';
    $diaChi = $data['diaChi'] ?? '';

    if (!$id || !$ten || !$sdt || !$diaChi) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'Dữ liệu không hợp lệ']);
        exit;
    }

    $sql = "UPDATE SoDiaChi SET tenNguoiNhan = ?, soDienThoai = ?, diaChi = ? WHERE id = ?";
    $stmt = $conn->prepare($sql);

    if (!$stmt) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'Lỗi prepare: ' . $conn->error]);
        exit;
    }

    $stmt->bind_param("sssi", $ten, $sdt, $diaChi, $id);

    if ($stmt->execute()) {
        echo json_encode(['success' => true]);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'Lỗi cập nhật: ' . $stmt->error]);
    }

} elseif ($action === 'xoa') {
    $id = $data['id'] ?? null;

    if (!$id) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'Thiếu ID địa chỉ']);
        exit;
    }

    $sql = "DELETE FROM SoDiaChi WHERE id = ?";
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
