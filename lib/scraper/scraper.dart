import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart';
import 'package:universal_html/parsing.dart';

var userAgent = 'BoxNovel/0.1';

Future<HtmlDocument> scrapePage(String url) async {
  var uri = Uri.parse(url);
  var response = await http.get(uri, headers: {'User-Agent': userAgent});

  return parseHtmlDocument(response.body);
}
