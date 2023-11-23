import 'dart:convert';
import 'dart:io';

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
