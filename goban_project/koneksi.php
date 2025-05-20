<?php
$host = "localhost:3307";
$user = "root";
$password = "";
$db = "goban";
$conn = new mysqli($host, $user, $password, $db);

if ($conn->connect_error) {
    die(json_encode([
        "success" => false,
        "message" => "Koneksi gagal: " . $conn->connect_error
    ]));
}
?>