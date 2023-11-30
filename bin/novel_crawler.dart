import 'dart:convert';

import 'package:novel_crawler/novel_crawler.dart' as novel_crawler;
import 'package:novel_crawler/utils/utils.dart';

void main(List<String> arguments) {
  getData();
}

void getData() async {
  // getConversation();
  // getPhraseAndSentence();
  // novel_crawler.getListTest();
}

void getConversation() async {
  final linkConversation = await novel_crawler.getListConversation();

  final List<Map<String, dynamic>> contentConversations = [];

  for (var e in linkConversation) {
    final contentConversation = await novel_crawler.getConversation(e.url);
    final contentMap = contentConversation.toJson();

    // Thêm đánh số vào danh sách
    contentMap['index'] = contentConversations.length + 1;
    contentConversations.add(contentMap);
  }

  createJsonFile(jsonEncode(contentConversations), "linkConversation.json");
}

void getPhraseAndSentence() async {
  final linkPhrasesAndSentences =
      await novel_crawler.getListPhrasesAndSentences();

  final List<Map<String, dynamic>> contentPhrasesAndSentences = [];

  for (var e in linkPhrasesAndSentences) {
    final contentPhraseAndSentence =
        await novel_crawler.getPhraseAndSentence(e.url);
    final contentMap = contentPhraseAndSentence.toJson();

    // Thêm đánh số vào danh sách
    contentMap['index'] = contentPhrasesAndSentences.length + 1;
    contentPhrasesAndSentences.add(contentMap);
  }
  createJsonFile(
      jsonEncode(contentPhrasesAndSentences), "linkPhrasesAndSentences.json");
}
