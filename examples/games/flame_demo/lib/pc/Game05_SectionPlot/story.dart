class Story {
  String title;
  String section;
  Iterable<StoryItem> items;
  Story(this.title, this.section, this.items);
}

class StoryItem {
  String? id;
  String name;
  String? head;
  String? position = 'left';
  String content;
  String? highlight;

  StoryItem(this.name, this.content, {this.id, this.position, this.highlight, this.head});
}
