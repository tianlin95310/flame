String dividerByLength(String inner, int length) {
  inner = inner.replaceAll(' ', '');
  int intLength = inner.length ~/ length;
  bool isInt = (inner.length / length == inner.length ~/ length);

  List<String> dividers = [];
  for (int i = 0; i < intLength; i++) {
    dividers.add(inner.substring(length * i, length * (i + 1)));
  }
  if (!isInt) {
    dividers.add(inner.substring(intLength * length, inner.length));
  }
  String content = dividers.join('\n');
  return content;
}

List<String> stringToList(String raw) {
  // return raw.split(RegExp('\\S'));
  List<String> list = [];
  for (int i = 0; i < raw.length; i++) {
    list.add(raw[i]);
  }
  return list;
}

// void main() {
//   print(stringToList('哈哈'));
// }