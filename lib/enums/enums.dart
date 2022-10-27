enum Sort {
  name_ascending,
  name_descending,
  dateAdded,
  ratio,
  size_ascending,
  size_descending,
  none,
}

enum Filter {
  All,
  Downloading,
  Completed,
  Active,
  Inactive,
  Error,
}

enum NotificationChannelID {
  NewTorrentAdded,
  DownloadCompleted,
  LowDiskSpace,
}

enum HomeViewBottomSheetMode {
  Torrent,
  RSS,
}

enum Screens {
  TorrentListViewScreen,
  DiskExplorerViewScreen,
  TorrentHistoryViewScreen,
}

enum IrssiButtons {
  update,
  whatsnew,
  clear,
  backup,
  restore,
  reloadtrackers,
  version,
  none,
}

/// Default Labels for Torrents
enum DefaultLabelsEnum {
  videos,
  games,
  music,
  software,
  movies,
  documents,
  pictures,
  movies3d,
  nolabel
}
