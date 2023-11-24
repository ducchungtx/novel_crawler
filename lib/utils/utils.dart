import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<void> createJsonFile(String content, String filename) async {
  // Tạo thư mục nếu nó chưa tồn tại
  await Directory('output').create(recursive: true);

  // Tạo đường dẫn đầy đủ đến tệp trong thư mục "output"
  String filePath = 'output/$filename';

  // Mở tệp để ghi nội dung vào đó
  File file = File(filePath);
  await file.writeAsString('');
  await file.writeAsString(content, encoding: utf8);

  print('File created: $filename');
}

void downloadAndSaveMP3(String title, String audioUrl) async {
  // Chuyển đổi title thành tên thư mục
  String folderName = title.toLowerCase().replaceAll(' ', '_');

  // Tạo thư mục nếu nó không tồn tại
  Directory folder = Directory(folderName);
  if (!folder.existsSync()) {
    folder.createSync();
  }

  // Tạo tên file từ URL
  String fileName = audioUrl.split('/').last;

  // Tạo đường dẫn đầy đủ đến file mp3
  String filePath = '$folderName/$fileName';

  // Tải xuống file mp3 từ URL
  var response = await http.get(Uri.parse(audioUrl));
  if (response.statusCode == 200) {
    // Lưu trữ file mp3 vào thư mục tương ứng
    File file = File(filePath);
    file.writeAsBytesSync(response.bodyBytes);
    print('Downloaded and saved: $filePath');
  } else {
    print('Failed to download: $audioUrl');
  }
}
