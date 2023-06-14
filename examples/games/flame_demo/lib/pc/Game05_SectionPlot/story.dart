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

  String? type = 'story';

  StoryItem(
    this.name,
    this.content, {
    this.id,
    this.position,
    this.highlight,
    this.head,
    this.type,
  });

  @override
  String toString() {
    return 'StoryItem{id: $id, name: $name, type: $type}\n';
  }
}
