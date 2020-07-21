class RSSLabel {
  RSSLabel(this.hash, this.label);

  String hash;
  String label;
  List<RSSItem> items = [];
}

class RSSItem {
  RSSItem(this.title, this.time, this.url);

  String title;
  int time;
  String url;

  // These fields will be fetched via getRSSDetails request
  String imageUrl;
  String name;
  String rating;
  String genre;
  String size;
  String runtime;
  String description;
}
