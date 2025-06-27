<?php
ob_clean();
header('Content-Type: application/json');

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
    $tenBe = $data['tenBe'] ?? '';
    $ngaySinh = $data['ngaySinh'] ?? '';
    $gioiTinh = $data['gioiTinh'] ?? '';
    $canNang = $data['canNang'] ?? null;

    if (!$nguoiDungId || !$tenBe || !$ngaySinh || !$gioiTinh || !$canNang) {
        http_response_code(400);
        echo json_encode(['success' => false, 'error' => 'Dữ liệu không hợp lệ']);
        exit;
    }

    $sql = "INSERT INTO HoSoBe (nguoiDungId, tenBe, ngaySinh, gioiTinh, canNang ) VALUES (?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    if (!$stmt) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'Lỗi prepare: ' . $conn->error]);
        exit;
    }

    $stmt->bind_param("isssis", $nguoiDungId, $tenBe, $ngaySinh, $gioiTinh, $canNang);
    if ($stmt->execute()) {
        echo json_encode(['success' => true]);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'Lỗi thêm bé: ' . $stmt->error]);
    }

} elseif ($action === 'sua') {
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

    $stmt->bind_param("sssisi", $tenBe, $ngaySinh, $gioiTinh, $canNang, $id);
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
