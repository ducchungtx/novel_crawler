import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:novel_crawler/models/audio_section.dart';
import 'package:novel_crawler/models/conversation.dart';
import 'package:novel_crawler/utils/utils.dart';

void downloadConversationList() async {
  // Gọi file json
  final jsonFile = File('./output/linkConversation.json');
  final jsonString = await jsonFile.readAsString();

  // Giải mã json
  final jsonMap = jsonDecode(jsonString);
  // Chuyển đổi json thành danh sách
  List<Conversation> listConversations =
      jsonMap.map<Conversation>((e) => Conversation.fromJson(e)).toList();

  // Tạo thư mục conversation nếu nó không tồn tại
  Directory('conversation').createSync();

  // Danh sách các Future để sử dụng với Future.wait
  List<Future<void>> downloadFutures = [];

  // Loop qua danh sách conversation và bắt đầu quá trình tải về
  for (var e in listConversations) {
    // Tải về e.audioUrl
    var audioPath =
        await downloadAndSaveMP3(e.title, e.audioUrl, 'conversation');
    print(audioPath);

    // Update đường dẫn trong file JSON cho e.audioUrl
    var updatedAudioUrl =
              e.copyWith(newAudioUrl: audioPath);
    // Replace the old instance with the updated one
    var index = listConversations.indexOf(e);
    listConversations[index] = updatedAudioUrl;

    // Loop through e.audioSections and add to the Future list
    downloadFutures.addAll(e.audioSections.map((audioSection) =>
        downloadAndSaveMP3(e.title, audioSection.url, 'conversation')
            .then((audioSectionPath) {
          // Create a new instance with the updated URL
          var updatedAudioSection =
              audioSection.copyWith(newUrl: audioSectionPath);

          // Replace the old instance with the updated one
          var index = e.audioSections.indexOf(audioSection);
          e.audioSections[index] = updatedAudioSection;
        })));

    // Đợi tất cả các Future hoàn thành trước khi chuyển sang conversation tiếp theo
    await Future.wait<void>(downloadFutures);
  }

  // Cập nhật file JSON sau khi đã tải về và cập nhật đường dẫn
  jsonFile.writeAsStringSync(
      jsonEncode(listConversations.map((e) => e.toJson()).toList()));
}
