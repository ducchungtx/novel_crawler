import 'dart:convert';

import 'package:novel_crawler/novel_crawler.dart' as novel_crawler;
import 'package:novel_crawler/scraper/scraper_audio.dart' as scraper_audio;
import 'package:novel_crawler/utils/utils.dart';

void main(List<String> arguments) {
  getData();
}

void getData() async {
  // getConversation();
  // getPhraseAndSentence();
  // getPhraseAndSentenceTest();
  // getExpressions();
  // getPhrasalVerbs();

  // download audio
  // scraper_audio.downloadConversationList();
  // scraper_audio.downloadPhraseList();
  scraper_audio.downloadPhrasalVerbList();

}

void getExpressions() async {
  final linkExpressions = await novel_crawler.getListExpressions();

  final List<Map<String, dynamic>> contentConversations = [];

  for (var e in linkExpressions) {
    final contentConversation = await novel_crawler.getExpression(e.url);
    final contentMap = contentConversation.toJson();

    // Thêm đánh số vào danh sách
    contentMap['index'] = contentConversations.length + 1;
    contentConversations.add(contentMap);
  }

  createJsonFile(jsonEncode(contentConversations), "linkExpressions.json");
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
    print(e.url);
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

void getPhrasalVerbs() async {
  final linkPhrasalVerbs = await novel_crawler.getListPhrasalVerbs();
  print(linkPhrasalVerbs);

  final List<Map<String, dynamic>> contentPhrasalVerbs = [];
  for (var e in linkPhrasalVerbs) {
    print(e.url);
    final contentPhrasalVerb = await novel_crawler.getPhrasalVerbs(e.url);
    final contentMap = contentPhrasalVerb.toJson();

    contentMap['index'] = contentPhrasalVerbs.length + 1;
    contentPhrasalVerbs.add(contentMap);
  }
  createJsonFile(
      jsonEncode(contentPhrasalVerbs), "linkPhrasalVerbs.json");
}