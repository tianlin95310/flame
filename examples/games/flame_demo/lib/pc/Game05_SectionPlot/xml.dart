import 'dart:convert';
import 'dart:typed_data';

import 'package:flame_demo/utils/string.dart';
import 'package:xml/xml.dart';

import 'story.dart';

class XmlReader {
  static Story? readXmlByString(String xmlString) {
    Story? story;
    try {
      XmlDocument document = XmlDocument.parse(xmlString);
      XmlElement root = document.rootElement;
      String title = root.getElement('title')?.innerText ?? '';
      Iterable<StoryItem> items = root.childElements.where((element) => element.name.local == 'story').map((e) {
        String inner = e.innerText.trim();
        return StoryItem(
          e.getAttribute('name') ?? '',
          bool.tryParse(e.getAttribute('spaceWrap') ?? 'false') ?? false ? inner: dividerByLength(inner, 22),
          id: e.getAttribute('id') ?? '',
        );
      });
      story = Story(title, items);
    } on Exception catch (e) {
      print('xml file read failed, e = $e');
    } finally {}
    return story;
  }

  static Story readXmlByUint8(Uint8List bytes) {
    Story story = Story('name', []);
    try {
      String xmlString = utf8.decode(bytes);
      story = readXmlByString(xmlString) ?? Story('', []);
    } on Exception catch (e) {
      // todo
    } finally {
      print('readXmlByUint8');
    }
    return story;
  }
}
