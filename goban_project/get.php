<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST, GET, PUT, DELETE, OPTIONS");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
include 'koneksi.php';


// Menangani GET untuk Read Pesanan
if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $sql = "SELECT * FROM orders";
    if (isset($_GET['status'])) {
        $status = $_GET['status'];
        $sql .= " WHERE status='$status'";
    }
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $orders = [];
        while($row = $result->fetch_assoc()) {
            $orders[] = $row;
        }
        echo json_encode($orders);
    } else {
        echo json_encode([]);
    }
}

$conn->close();
?>
