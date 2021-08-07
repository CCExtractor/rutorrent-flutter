class DevDiskSpace {
  int total;
  int free;
  DevDiskSpace(this.total, this.free);
}

DevDiskSpace _devDiskSpace = DevDiskSpace(512, 386);

DevDiskSpace get devDiskSpace => _devDiskSpace;
