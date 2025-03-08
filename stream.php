<?php
$db = new SQLite3('/var/www/html/urls.db');

$url = $_GET['url'] ?? null;
if (!$url) {
    echo "Error: No URL provided";
    exit;
}

// ตรวจสอบว่ามีลิงก์นี้ในฐานข้อมูลแล้วหรือไม่
$stmt = $db->prepare("SELECT converted FROM urls WHERE original = :url");
$stmt->bindValue(':url', $url, SQLITE3_TEXT);
$result = $stmt->execute()->fetchArray(SQLITE3_ASSOC);

if ($result) {
    echo $result['converted']; // ส่งลิงก์ที่เคยแปลงกลับไป
} else {
    // สร้างลิงก์ใหม่
    $filename = time() . rand(1000, 9999) . ".m3u8";
    $hls_path = "/var/www/html/hls/" . $filename;

    shell_exec("wget -q -O $hls_path $url");

    $converted_url = "https://docker-ryg4.onrender.com/hls/" . $filename;

    // บันทึกลงฐานข้อมูล
    $stmt = $db->prepare("INSERT INTO urls (original, converted) VALUES (:original, :converted)");
    $stmt->bindValue(':original', $url, SQLITE3_TEXT);
    $stmt->bindValue(':converted', $converted_url, SQLITE3_TEXT);
    $stmt->execute();

    echo $converted_url;
}
?>
