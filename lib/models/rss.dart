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
}
