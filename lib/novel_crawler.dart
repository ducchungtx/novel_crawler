import 'package:novel_crawler/config/config.dart';
import 'package:novel_crawler/scraper/scraper.dart';

import 'package:novel_crawler/models/audio_section.dart';
import 'package:novel_crawler/models/conversation.dart';
import 'package:novel_crawler/models/link.dart';
import 'package:novel_crawler/models/phrase_and_sentence.dart';

Future<List<Link>> getListConversation() async {
  final url = '$mainUrl/daily-english-conversation-topics/';
  final page = await scrapePage(url);

  final links = page.querySelectorAll('.tcb-flex-row a').map((element) {
    return Link(
      url: element.attributes['href']!,
      name: element.text!.trim(),
    );
  }).toList();
  return links;
}

Future<Conversation> getConversation(String url) async {
// Future getConversation(String url) async {
  final page = await scrapePage(url);

  final title = page.querySelector('.entry-title')!.text!.trim();
  final videoUrl = page.querySelector('.rve iframe')!.attributes['src']!;
  final audioUrl =
      page.querySelector('.wp-audio-shortcode a')!.attributes['href']!;

  var divs = page.querySelector('div.tve_shortcode_rendered');
  final List<String> texts = [];
  divs ??= page.querySelector('.awr');

  divs?.children.map((e) {
    if (e.previousNode != null) {
      final text = e.previousNode!.text!.trim();
      if (text.isNotEmpty &&
          !text.contains("ezoic_video_") &&
          !text.contains("http://")) {
        texts.add(text);
      }
    }
  }).toList();

  final audioUrls = [];
  final audioTmps = page.querySelectorAll('.sc_player_container1');
  audioTmps.map((element) {
    final button = element.querySelector('.myButton_play');
    if (button != null) {
      final onclickValue = button.attributes['onclick'];
      final urlMatch =
          RegExp(r"'(http://[^']*)'").firstMatch(onclickValue ?? '');

      if (urlMatch != null) {
        final mp3Url = urlMatch.group(1);
        audioUrls.add(mp3Url);
      }
    }
  }).toList();
  List<AudioSection> audioSections = [];
  if (texts.isNotEmpty) {
    audioSections = List.generate(
      audioUrls.length,
      (index) => AudioSection(
        content: texts[index],
        url: audioUrls[index],
      ),
    );
  }

  return Conversation(
    audioSections: audioSections,
    title: title,
    videoUrl: videoUrl,
    audioUrl: audioUrl,
  );
}

Future<List<Link>> getListPhrasesAndSentences() async {
  final url = '$mainUrl/100-common-phrases-and-sentence-patterns/';
  final page = await scrapePage(url);

  final links = page.querySelectorAll('.tcb-flex-row a').map((element) {
    return Link(
      url: element.attributes['href']!,
      name: element.text!.trim(),
    );
  }).toList();

  return links;
}

Future<Phrase> getPhraseAndSentence(String url) async {
  final page = await scrapePage(url);

  final title = page.querySelector('.entry-title')!.text!.trim();
  final audioUrl =
      page.querySelector('.wp-audio-shortcode a')!.attributes['href']!;

  final divs = page.querySelector('div.awr');
  final List<String> texts = [];
  divs!.children.map((e) {
    final text = e.text!.trim();
    if (e.className != "cmt acm" && text != title) {
      if (text.isNotEmpty) {
        if (!text.contains("http://") &&
            !text.contains("Download Full Lessons") &&
            !text.contains(" Shares")) {
          texts.add(e.text!.trim());
        }
      } else {
        if (e.previousNode != null) {
          final text = e.previousNode!.text!.trim();
          if (text.isNotEmpty) {
            if (!text.contains(" Shares")) {
              texts.add(text);
            }
          }
        }
      }
    }
  }).toList();

  final audioUrls = [];
  final audioTmps = page.querySelectorAll('.sc_player_container1');
  audioTmps.map((element) {
    final button = element.querySelector('.myButton_play');
    if (button != null) {
      final onclickValue = button.attributes['onclick'];
      final urlMatch =
          RegExp(r"'(http://[^']*)'").firstMatch(onclickValue ?? '');

      if (urlMatch != null) {
        final mp3Url = urlMatch.group(1);
        audioUrls.add(mp3Url);
      }
    }
  }).toList();

  final audioSections = List.generate(
    audioUrls.length,
    (index) {
      print(texts[index]);
      if (texts[index].toLowerCase().contains("examples")) {
        return AudioSection(
          content: texts[index + 1],
          url: audioUrls[index],
        );
      }
      return AudioSection(
        content: texts[index + 2],
        url: audioUrls[index],
      );
    },
  );

  return Phrase(
    title: title.trim(),
    audioUrl: audioUrl,
    audioSections: audioSections,
    textSections: texts,
  );
}
