import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart';
import 'package:universal_html/parsing.dart';

var userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36';

Future<HtmlDocument> scrapePage(String url) async {
  var uri = Uri.parse(url);
  var response = await http.get(uri, headers: {'User-Agent': userAgent});

  return parseHtmlDocument(response.body);
}
