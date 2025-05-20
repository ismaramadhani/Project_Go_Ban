<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST, GET, PUT, DELETE, OPTIONS");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
include 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'DELETE') {
    parse_str(file_get_contents("php://input"), $data);
    $id = $data['id'];

    $sql = "DELETE FROM orders WHERE id=$id";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["message" => "Pesanan berhasil dihapus"]);
    } else {
        echo json_encode(["error" => "Error: " . $conn->error]);
    }
}
console.log($_COOKIE);
$conn->close();
?>
