<?php
header('Content-Type: application/json');
include("../config/db.php"); // Kết nối CSDL

// Kiểm tra tham số
if (!isset($_GET['danhMucId']) || !isset($_GET['thuongHieuId'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Thiếu tham số']);
    exit;
}

$danhMucId = intval($_GET['danhMucId']);
$thuongHieuId = intval($_GET['thuongHieuId']);

try {
    $stmt = $conn->prepare("
        SELECT * FROM SanPham 
        WHERE danhMucId = ? AND thuongHieuId = ? AND trangThai = 'active'
        ORDER BY ngayTao DESC
    ");
    $stmt->bind_param("ii", $danhMucId, $thuongHieuId);
    $stmt->execute();
    $result = $stmt->get_result();

    $sanPhams = [];
    while ($row = $result->fetch_assoc()) {
        $sanPhams[] = $row;
    }

    echo json_encode($sanPhams);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Lỗi server: ' . $e->getMessage()]);
}
?>
