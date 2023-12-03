import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';

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

Future<String?> downloadAndSaveMP3(
    String title, String audioUrl, String mainFolder) async {
  // Chuyển đổi title thành tên thư mục
  String folderName = convertTitle(title);

  // Tạo thư mục nếu nó không tồn tại
  Directory folder = Directory(join(mainFolder, folderName));
  if (!folder.existsSync()) {
    folder.createSync();
  }

  // Tạo tên file từ URL
  String fileName = audioUrl.split('/').last;

  // Tạo đường dẫn đầy đủ đến file mp3
  String filePath = join(folder.path, fileName);

  // Tải xuống file mp3 từ URL
  var response = await http.get(Uri.parse(audioUrl));
  if (response.statusCode == 200) {
    // Kiểm tra xem response body có dữ liệu không
    if (response.body.isNotEmpty) {
      // Lưu trữ file mp3 vào thư mục tương ứng
      File file = File(filePath);
      file.writeAsBytesSync(response.bodyBytes);
      print('Downloaded and saved: $filePath');
      return filePath;
    } else {
      print('Empty response body for: $audioUrl');
    }
  } else {
    print('Failed to download: $audioUrl');
  }
  return null; // Trả về null khi tải về thất bại
}

String convertTitle(String originalTitle) {
  // Loại bỏ các ký tự không mong muốn
  String cleanedTitle = originalTitle.replaceAll(RegExp(r'[^\w\s]'), '');

  // Thay thế khoảng trắng bằng dấu gạch dưới
  String underscoredTitle = cleanedTitle.replaceAll(' ', '_');

  return underscoredTitle.toLowerCase();
}
