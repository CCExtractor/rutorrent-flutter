class RSSFilter {
  RSSFilter(this.name, this.enabled, this.pattern, this.label, this.exclude,
      this.dir);

  String name;
  int enabled;
  String pattern;
  String label;
  String exclude;
  String dir;
}
