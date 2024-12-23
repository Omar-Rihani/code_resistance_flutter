import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

// Datasheet Scraper Class
class DatasheetScraper {
  final String baseUrl = 'https://www.alldatasheet.com';
  String keyword;
  List<String> datasheetLinks = [];

  DatasheetScraper(this.keyword);

  Future<http.Response?> sendRequest(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response;
      } else {
        print('Failed to load page, status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }

  List<String> parseHtml(String responseBody) {
    var document = html.parse(responseBody);
    var links = document.querySelectorAll('a[href]');
    var datasheetLinks = <String>[];
    for (var link in links) {
      var href = link.attributes['href'];
      if (href != null && href.contains('pdf') && href.contains('/datasheet-pdf/')) {
        var fullLink = href.startsWith('/')
            ? 'https:$href'
            : href;
        var modifiedLink = fullLink.replaceAll('/pdf/', '/view/');
        datasheetLinks.add(modifiedLink);
      }
    }

    return datasheetLinks;
  }

  Future<void> searchDatasheets() async {
    var searchUrl = '$baseUrl/view.jsp?Searchword=$keyword';
    var response = await sendRequest(searchUrl);

    if (response != null) {
      datasheetLinks = parseHtml(response.body);
    } else {
      print('Failed to retrieve datasheet links.');
    }
  }

  Future<List<String>> convertLink(String link) async {
    var pdfLinks = <String>[];
    var response = await sendRequest(link);

    if (response != null) {
      var document = html.parse(response.body);
      var divs = document.querySelectorAll('div.overflowyo');

      for (var div in divs) {
        var iframes = div.querySelectorAll('iframe');
        for (var iframe in iframes) {
          var src = iframe.attributes['src'];
          if (src != null && src.contains('file=') && src.endsWith('.pdf')) {
            var pdfLinkStart = src.indexOf('file=') + 'file='.length;
            var pdfLink = 'https://www.alldatasheet.com/pdfjsview/web/viewer.html?file=//${src.substring(pdfLinkStart)}';
            pdfLinks.add(pdfLink);
          }
        }
      }
    } else {
      print('Failed to convert link: $link');
    }

    return pdfLinks;
  }

  Future<List<String>> run() async {
    await searchDatasheets();

    var allPdfLinks = <String>{};

    var linkFutures = datasheetLinks.map((link) async {
      var pdfLinks = await convertLink(link);
      allPdfLinks.addAll(pdfLinks);
    });

    await Future.wait(linkFutures);

    return allPdfLinks.toList();
  }
}

// Datasheet Viewer Widget
class DatasheetViewer extends StatefulWidget {
  @override
  _DatasheetViewerState createState() => _DatasheetViewerState();
}

class _DatasheetViewerState extends State<DatasheetViewer> {
  final TextEditingController _controller = TextEditingController();
  List<String> _pdfLinks = [];

  void _searchDatasheets() async {
    var scraper = DatasheetScraper(_controller.text);
    var links = await scraper.run();
    setState(() {
      _pdfLinks = links;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Datasheet Viewer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter Component Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchDatasheets,
              child: Text('Search'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _pdfLinks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('PDF Link ${index + 1}'),
                    subtitle: Text(_pdfLinks[index]),
                    onTap: () {
                      _launchUrl(_pdfLinks[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to launch URLs using the simplified _launchUrl function
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }
}

// Main Function to run the app
void main() => runApp(MaterialApp(
  home: DatasheetViewer(),
));
