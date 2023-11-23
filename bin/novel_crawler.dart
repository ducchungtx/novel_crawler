import 'dart:convert';

import 'package:novel_crawler/config/config.dart';
import 'package:novel_crawler/novel_crawler.dart' as novel_crawler;
import 'package:novel_crawler/utils/utils.dart';

void main(List<String> arguments) {
  getData();
}

void getData() async {
  final linkConversation = await novel_crawler.getListConversation();
  final linkPhrasesAndSentences =
      await novel_crawler.getListPhrasesAndSentences();
  // final content = await novel_crawler.getConversation('$mainUrl/family/');
  // final content =
  //     await novel_crawler.getPhraseAndSentence('$mainUrl/096-why-not/');

  final contentConversation = linkConversation.map((e) => e.toJson()).toList();
  createJsonFile(jsonEncode(contentConversation), "linkConversation.json");

  final contentPhrasesAndSentences =
      linkPhrasesAndSentences.map((e) => e.toJson()).toList();
  createJsonFile(
      jsonEncode(contentPhrasesAndSentences), "linkPhrasesAndSentences.json");
}
