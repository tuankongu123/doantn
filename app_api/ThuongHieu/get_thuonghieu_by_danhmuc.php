<?php
header('Content-Type: application/json');
include("../config/db.php");

try {
    $conn->set_charset("utf8mb4");

    if (!isset($_GET['id_danhmuc'])) {
        echo json_encode([]);
        exit;
    }

    $idDanhMuc = intval($_GET['id_danhmuc']);

    // Truy vấn lấy thương hiệu theo danh mục
    $sql = "
        SELECT DISTINCT th.id, th.ten
        FROM SanPham sp
        JOIN ThuongHieu th ON sp.thuongHieuId = th.id
        WHERE sp.danhMucId = ?
        ORDER BY th.ten
    ";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $idDanhMuc);
    $stmt->execute();
    $result = $stmt->get_result();

    $thuongHieus = [];

    while ($row = $result->fetch_assoc()) {
        $thuongHieus[] = [
            'id' => $row['id'],
            'ten' => $row['ten']
        ];
    }

    echo json_encode($thuongHieus);

} catch (Exception $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
?>
