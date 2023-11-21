import 'package:novel_crawler/config/config.dart';
import 'package:novel_crawler/novel_crawler.dart' as novel_crawler;

void main(List<String> arguments) {
  print("hello world");

  getData();
}

void getData() async {
  // final links = await novel_crawler.getListConversation();
  // final links = await novel_crawler.getListPhrasesAndSentences();
  // final content = await novel_crawler.getConversation('$mainUrl/family/');
  final content =
      await novel_crawler.getPhraseAndSentence('$mainUrl/096-why-not/');

  // print(links);
  print(content);
}
