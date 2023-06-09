class Story {
  String title;
  Iterable<StoryItem> items;
  Story(this.title, this.items);
}

class StoryItem {
  String? id;
  String name;
  String? position = 'left';
  String content;
  String? highlight;

  StoryItem(this.name, this.content, {this.id, this.position, this.highlight});
}
