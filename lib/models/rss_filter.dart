class RSSFilter {
  String name;
  String pattern;
  String exclude;
  int enabled;
  int no;
  int interval;
  String throttle;
  int ratio;
  int start;
  String addPath;
  String dir;
  String label;
  int checkTitle;
  int checkDescription;
  int checkLink;

  RSSFilter(
      {this.name,
      this.pattern,
      this.exclude,
      this.enabled,
      this.no,
      this.interval,
      this.throttle,
      this.ratio,
      this.start,
      this.addPath,
      this.dir,
      this.label,
      this.checkTitle,
      this.checkDescription,
      this.checkLink});

  RSSFilter.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    pattern = json['pattern'];
    exclude = json['exclude'];
    enabled = json['enabled'];
    throttle = json['throttle'] == "null" ? null : json['throttle'];
    ratio = json['ratio'] == "null" ? null : json['ratio'];
    start = json['start'] == "null" ? null : json['start'];
    addPath = json['addPath'];
    dir = json['dir'];
    label = json['label'];
    checkTitle = json['chktitle'];
    checkDescription = json['chkdesc'];
    checkLink = json['chklink'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['name'] = this.name;
    if (this.pattern != null) data['pattern'] = this.pattern;
    if (this.exclude != null) data['exclude'] = this.exclude;
    if (this.enabled != null) data['enabled'] = this.enabled.toString();
    if (this.throttle != null) data['throttle'] = this.throttle;
    if (this.ratio != null) data['ratio'] = this.ratio.toString();
    if (this.start != null) data['start'] = this.start.toString();
    if (this.addPath != null) data['addPath'] = this.addPath;
    if (this.dir != null) data['dir'] = this.dir;
    if (this.label != null) data['label'] = this.label;
    if (this.checkTitle != null) data['chktitle'] = this.checkTitle.toString();
    if (this.checkDescription != null)
      data['chkdesc'] = this.checkDescription.toString();
    if (this.checkLink != null) data['chklink'] = this.checkLink.toString();
    return data;
  }
}
