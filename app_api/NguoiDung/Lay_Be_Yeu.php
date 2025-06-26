<?php
ob_clean();
header('Content-Type: application/json; charset=utf-8');
include_once(__DIR__ . '/../config/db.php');



$nguoiDungId = $_GET['nguoiDungId'];

$query = "SELECT * FROM hosobe WHERE nguoiDungId = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("i", $nguoiDungId);
$stmt->execute();

$result = $stmt->get_result();
$data = [];

while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
?>
