<?php
include("../config/dp.php");
header('Content-Type: application/json');
ob_clean(); // xóa buffer đầu nếu có

try {
    // 1. Số đơn hôm nay
    $sql1 = "SELECT COUNT(*) AS don_hom_nay FROM DonHang WHERE DATE(ngayTao) = CURDATE()";
    $result1 = $conn->query($sql1);
    $donHomNay = (int)($result1->fetch_assoc()['don_hom_nay'] ?? 0);

    // 2. Doanh thu hôm nay
    $sql2 = "SELECT SUM(tongTien) AS doanh_thu FROM DonHang WHERE DATE(ngayTao) = CURDATE()";
    $result2 = $conn->query($sql2);
    $doanhThu = (float)($result2->fetch_assoc()['doanh_thu'] ?? 0);

    // 3. Sản phẩm bán chạy nhất
    $sql3 = "
        SELECT sp.ten, SUM(ct.soLuong) AS da_ban
        FROM ChiTietDonHang ct
        JOIN DonHang dh ON dh.id = ct.donHangId
        JOIN SanPham sp ON sp.id = ct.sanPhamId
        GROUP BY sp.id
        ORDER BY da_ban DESC
        LIMIT 1
    ";
    $result3 = $conn->query($sql3);
    $row3 = $result3->fetch_assoc();
    $sanPhamBanChay = $row3 ? $row3['ten'] : 'Chưa có';

    // 4. Đơn chờ duyệt
    $sql4 = "SELECT COUNT(*) AS don_cho_duyet FROM DonHang WHERE trangThai = 'cho_duyet'";
    $result4 = $conn->query($sql4);
    $donChoDuyet = (int)($result4->fetch_assoc()['don_cho_duyet'] ?? 0);

    echo json_encode([
        'status' => 'success',
        'data' => [
            'don_hom_nay' => $donHomNay,
            'doanh_thu' => $doanhThu,
            'san_pham_ban_chay' => $sanPhamBanChay,
            'don_cho_duyet' => $donChoDuyet
        ]
    ]);
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}
?>