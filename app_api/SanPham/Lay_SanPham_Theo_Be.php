<?php
header('Content-Type: application/json');
require_once '../config/db.php';

$nguoiDungId = $_GET['nguoiDungId'] ?? null;
$beId = $_GET['beId'] ?? null;

if (!$nguoiDungId || !$beId) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Thiếu tham số']);
    exit;
}

// Lấy thông tin bé từ bảng HoSoBe
$stmtBe = $conn->prepare("SELECT ngaySinh, canNang FROM HoSoBe WHERE id = ? AND nguoiDungId = ?");
$stmtBe->bind_param("ii", $beId, $nguoiDungId);
$stmtBe->execute();
$resultBe = $stmtBe->get_result();

if ($resultBe->num_rows === 0) {
    http_response_code(404);
    echo json_encode(['success' => false, 'message' => 'Không tìm thấy bé']);
    exit;
}

$row = $resultBe->fetch_assoc();
$ngaySinh = $row['ngaySinh'];
$canNang = $row['canNang'];

// Tính số tháng tuổi
$ngaySinhDate = new DateTime($ngaySinh);
$now = new DateTime();
$interval = $ngaySinhDate->diff($now);
$thangTuoi = $interval->y * 12 + $interval->m;

// Truy vấn sản phẩm phù hợp với bé dựa trên độ tuổi và cân nặng
$sql = "
    SELECT sp.*
    FROM SanPham sp
    JOIN GiaTriThuocTinh gt1 ON gt1.sanPhamId = sp.id AND gt1.thuocTinhId = (
        SELECT id FROM ThuocTinh WHERE ten = 'Độ tuổi sử dụng' LIMIT 1
    )
    JOIN GiaTriThuocTinh gt2 ON gt2.sanPhamId = sp.id AND gt2.thuocTinhId = (
        SELECT id FROM ThuocTinh WHERE ten = 'Cân nặng phù hợp' LIMIT 1
    )
    WHERE
        (
            gt1.giaTri LIKE '%tháng%' AND (
                (gt1.giaTri LIKE '%+%' AND CAST(SUBSTRING_INDEX(gt1.giaTri, '+', 1) AS UNSIGNED) <= ?)
                OR
                (gt1.giaTri LIKE '%-%' AND ? BETWEEN 
                    CAST(SUBSTRING_INDEX(gt1.giaTri, '-', 1) AS UNSIGNED)
                    AND CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(gt1.giaTri, ' tháng', 1), '-', -1) AS UNSIGNED)
                )
            )
        )
        AND
        (
            gt2.giaTri LIKE '%kg%' AND (
                (gt2.giaTri LIKE '%+%' AND CAST(SUBSTRING_INDEX(gt2.giaTri, '+', 1) AS UNSIGNED) <= ?)
                OR
                (gt2.giaTri LIKE '%-%' AND ? BETWEEN 
                    CAST(SUBSTRING_INDEX(gt2.giaTri, '-', 1) AS UNSIGNED)
                    AND CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(gt2.giaTri, 'kg', 1), '-', -1) AS UNSIGNED)
                )
            )
        )
    GROUP BY sp.id
";

$stmt = $conn->prepare($sql);
$stmt->bind_param("iiii", $thangTuoi, $thangTuoi, $canNang, $canNang);
$stmt->execute();
$result = $stmt->get_result();

$sanPham = [];
while ($row = $result->fetch_assoc()) {
    $sanPham[] = $row;
}

echo json_encode(['success' => true, 'data' => $sanPham]);
