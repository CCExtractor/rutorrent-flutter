enum Status {
  downloading,
  pausing,
  stopped,
}

class Task{

  Task(this.hash);

  String hash; // hash value is a unique value for a torrent task
  String name;
  Status status;
  String size; // size in appropriate unit
  String savePath; // directory where task is saved
}