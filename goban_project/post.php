<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST, GET, PUT, DELETE, OPTIONS");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
include 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_id = $_POST['user_id'];
    $service_type = $_POST['service_type'];
    $vehicle_type = $_POST['vehicle_type'];
    $location = $_POST['location'];

    $sql = "INSERT INTO orders (user_id, service_type, vehicle_type, location) 
            VALUES ('$user_id', '$service_type', '$vehicle_type', '$location')";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["message" => "Pesanan berhasil dibuat"]);
    } else {
        echo json_encode(["error" => "Error: " . $conn->error]);
    }
}

$conn->close();
?>
