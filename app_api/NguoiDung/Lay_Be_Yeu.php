<?php
ob_clean();
header("Content-Type: application/json; charset=UTF-8");
include_once(__DIR__ . '/../config/db.php');

$nguoiDungId = $_GET['id'] ?? null;
if (!$nguoiDungId) {
  echo json_encode(['success' => false, 'error' => 'Thiếu ID']);
  exit;
}

$sql = "SELECT * FROM BeYeu WHERE nguoiDungId = ?";
$stmt = $conn->prepare($sql);
$stmt->execute([$nguoiDungId]);
$data = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode(['success' => true, 'data' => $data]);
