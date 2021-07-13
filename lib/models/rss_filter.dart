class RSSFilter {
  RSSFilter(this.name, this.enabled, this.pattern, this.label, this.exclude,
      this.dir);

  String name;
  int enabled;
  String pattern;
  String label;
  String exclude;
  String dir;

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "enabled": this.enabled,
      "pattern": this.pattern,
      "label": this.label,
      "exclude": this.exclude,
      "dir": this.dir,
    };
  }
}
