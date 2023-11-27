import 'dart:convert';

import 'package:novel_crawler/novel_crawler.dart' as novel_crawler;
import 'package:novel_crawler/utils/utils.dart';

void main(List<String> arguments) {
  getData();
}

void getData() async {
  // getConversation();
  // getPhraseAndSentence();
  // testDownloadMp3();
  // getExpressions();
  testGetExpression();
}

void getExpressions() async {
  final linkExpressions = await novel_crawler.getListExpressions();
  print(linkExpressions);
}

void testGetExpression() async {
  final expression = await novel_crawler.getExpression(
      'https://basicenglishspeaking.com/greeting-english-different-ways-say-hello/');

  print(expression);
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

void testDownloadMp3() {
  downloadAndSaveMP3("001. Are you sure…?",
      "https://basicenglishspeaking.com/wp-content/uploads/audio/001.mp3");
}
