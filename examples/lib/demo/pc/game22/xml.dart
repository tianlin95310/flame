import 'dart:convert';
import 'dart:typed_data';

import 'package:examples/demo/utils/string.dart';
import 'package:xml/xml.dart';

import 'story.dart';

class XmlReader {
  static Story? readXmlByString(String xmlString) {
    Story? story;
    try {
      XmlDocument document = XmlDocument.parse(xmlString);
      XmlElement root = document.rootElement;
      String title = root.getAttribute('title') ?? '';
      String section = root.getAttribute('section') ?? '';
      int index = 0;
      Iterable<StoryItem> items = root.childElements.where((element) => element.name.local == 'story').map((e) {
        String inner = e.innerText.trim();
        String name = e.getAttribute('name') ?? '';
        return StoryItem(
            name.padLeft(4),
          bool.tryParse(e.getAttribute('spaceWrap') ?? 'false') ?? false ? inner: dividerByLength(inner, 20),
          id: e.getAttribute('id') ?? '',
          head: 'icons/head_${index++ % 2}.png',
            type: e.getAttribute('type') ?? 'story'
        );
      });
      story = Story(title, section, items);
    } on Exception catch (e) {
      print('readXmlByString, e = $e');
    } finally {}
    return story;
  }

  static Story readXmlByUint8(Uint8List bytes) {
    final empty = Story('','',  []);
    Story story = empty;
    try {
      String xmlString = utf8.decode(bytes);
      story = readXmlByString(xmlString) ?? empty;
    } on Exception catch (e) {
      print('readXmlByUint8, e = $e');
    } finally {
    }
    return story;
  }

}
