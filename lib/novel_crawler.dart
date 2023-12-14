import 'dart:convert';

import 'package:novel_crawler/config/config.dart';
import 'package:novel_crawler/models/content_section.dart';
import 'package:novel_crawler/models/expression.dart';
import 'package:novel_crawler/models/idiom.dart';
import 'package:novel_crawler/models/phrasal_verb.dart';
import 'package:novel_crawler/scraper/scraper.dart';

import 'package:novel_crawler/models/audio_section.dart';
import 'package:novel_crawler/models/conversation.dart';
import 'package:novel_crawler/models/link.dart';
import 'package:novel_crawler/models/phrase_and_sentence.dart';

Future<List<Link>> getListExpressions() async {
  final url = '$mainUrl/common-expressions-english/';
  final page = await scrapePage(url);

  final links = page.querySelectorAll('.tcb-flex-row a').map((element) {
    return Link(
      url: element.attributes['href']!,
      name: element.text!.trim(),
    );
  }).toList();
  return links;
}

Future<Expression> getExpression(String url) async {
  final page = await scrapePage(url);
  final title = page.querySelector('h1')!.text!.trim();
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
          if (text == "General greetings (Formal)") {
            print("General greetings (Formal)");
            // check the nextNode when to have the content
          }
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

  print(texts);

  return Expression(
    title: title,
    audioUrl: audioUrl,
    audioSections: [],
  );
}

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
  print(url);
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

  int newIndex = 0;
  final audioSections = List.generate(
    audioUrls.length,
    (index) {
      if (texts[index].contains("->")) {
        newIndex = index + 2;
        return AudioSection(
          content: texts[newIndex],
          url: audioUrls[index],
        );
      }
      if (texts[index].toLowerCase().contains("examples")) {
        newIndex++;
        return AudioSection(
          content: texts[newIndex],
          url: audioUrls[index],
        );
      }
      newIndex++;
      return AudioSection(
        content: texts[newIndex],
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

Future<List<Link>> getListPhrasalVerbs() async {
  final url = '$mainUrl/phrasal-verbs/';
  final page = await scrapePage(url);

  final links = page.querySelectorAll('h3 a').map((element) {
    return Link(
      url: element.attributes['href']!,
      name: element.text!.trim(),
    );
  }).toList();
  return links;
}

Future<PhrasalVerb> getPhrasalVerbs(String url) async {
  final page = await scrapePage(url);

  final title = page.querySelector('.entry-title')!.text!.trim();

  final contentContainer = page.querySelectorAll('.wp-block-group');

  // contentSection
  List<ContentSection> contentSections = [];

  contentContainer.map((element) {
    final title = element.querySelector('h4')!.text!.trim();
    final desc = element.querySelector('p')!.text!.trim();
    final audioContainer = element.querySelectorAll('.sc_player_container1');
    final audioUrls = [];
    audioContainer.map((element) {
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

    // get list texts
    var text = element.text!.trim();
    // Thay thế các dấu xuống dòng liên tiếp bằng một dấu xuống dòng duy nhất
    String cleanedText = text.replaceAll(RegExp(r'\n+'), '\n');
    // Tách văn bản thành danh sách các dòng
    List<String> lines = cleanedText.split('\n');
    // Loại bỏ các dòng trống
    List<String> texts = lines.where((line) => line.trim().isNotEmpty).toList();
    // Xoá 2 item 0, 1 trong list texts
    texts.removeAt(0);
    texts.removeAt(0);
    // Tạo list content
    List<AudioSection> audioSections = List.generate(audioUrls.length, (index) {
      return AudioSection(
        content: texts[index].trim(),
        url: audioUrls[index],
      );
    });

    contentSections.add(ContentSection(
      title: title,
      desc: desc,
      audioSections: audioSections,
    ));
  }).toList();

  return PhrasalVerb(title: title, contents: contentSections);
}

Future<List<Link>> getListCommonIdioms() async {
  final url = '$mainUrl/102-common-english-idioms/';
  final page = await scrapePage(url);

  final links =
      page.querySelectorAll('.thrv_contentbox_shortcode').map((element) {
    final name = element.querySelector("h3");
    final url = element.querySelector("a");
    return Link(
      url: url!.attributes['href']!,
      name: name != null ? name.text!.trim() : "",
    );
  }).toList();
  return links;
}

Future getCommonIdiom(String url) async {
  final page = await scrapePage(url);

  final title = page.querySelector('h1')!.text!.trim();
  final audioUrl =
      page.querySelector('.wp-audio-shortcode a')!.attributes['href']!;

  final contentElements = page.querySelectorAll(".thrv_text_element");

  var list = [];

  final texts = contentElements
      .map((element) {
        String? audioUrl = "";
        var audio = element.querySelector('.sc_player_container1');
        if (audio != null) {
          final button = audio.querySelector('.myButton_play');
          if (button != null) {
            final onclickValue = button.attributes['onclick'];
            final urlMatch =
                RegExp(r"'(http://[^']*)'").firstMatch(onclickValue ?? '');

            if (urlMatch != null) {
              final mp3Url = urlMatch.group(1);
              audioUrl = mp3Url;
            }
          }
        }
        return {'text': element.text!.trim(), 'audioUrl': audioUrl};
      })
      .where((element) => element.isNotEmpty)
      .toList();

  // remove two firsts item in the texts variable
  texts.removeAt(0);
  texts.removeAt(0);

  List<Idiom> idioms = [];

  Idiom currentParent =
      Idiom(sectionName: "", sectionSubtitle: "", children: []);

  for (var item in texts) {
    Idiom idiom =
        Idiom(sectionName: item['text']!, sectionSubtitle: "", children: []);

    if (item['audioUrl']!.isEmpty) {
      // Nếu item có url rỗng, nó là cha của danh sách bên dưới nó
      currentParent = idiom;
      idioms.add(currentParent);
    } else {
      // Ngược lại, nó là con của cha hiện tại
      currentParent.children.add(AudioSection(
        // Thay thế 'AudioSection' bằng model thực tế của bạn nếu cần
        // Giả sử bạn có một trường 'subtitle' trong 'AudioSection'
        content: item['text']!,
        url: item['audioUrl']!,
      ));
    }
  }

  final List<String> subtitles = page
      .querySelectorAll('.thrv-styled-list-item')
      .map((element) => element.text!.trim())
      .toList();

  idioms = idioms.map((e) {
    return Idiom(
      sectionName: e.sectionName,
      sectionSubtitle: subtitles[idioms.indexOf(e)],
      children: e.children,
    );
  }).toList();

  return {
    'title': title,
    'audioUrl': audioUrl,
    'idioms': idioms,
  };
}
