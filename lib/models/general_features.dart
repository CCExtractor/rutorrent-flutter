import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rutorrentflutter/components/filter_tile.dart';
import 'package:rutorrentflutter/models/torrent.dart';

import 'disk_space.dart';

enum Sort{
  name,
  dateAdded,
  percentDownloaded,
  downloadSpeed,
  uploadSpeed,
  ratio,
  size,
}

enum Filter{
  All,
  Downloading,
  Completed,
  Active,
  Inactive,
  Error,
}

class GeneralFeatures extends ChangeNotifier{

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  DiskSpace _diskSpace = DiskSpace();
  get diskSpace => _diskSpace;

  updateDiskSpace(int total,int free){
    //check if there is any change in freeSpace of disk
    if(free==_diskSpace.free)
      return;// returning since there is no change and UI does not need to update

    _diskSpace.update(total,free);
    notifyListeners();

    if(_diskSpace.isLow() && _diskSpace.alertUser)
      _diskSpace.generateLowDiskSpaceAlert();
  }

  Filter _selectedFilter = Filter.All;
  List<FilterTile> _filterTileList=[
    FilterTile(
      icon: Icons.select_all,
      filter: Filter.All,
    ),
    FilterTile(
      icon: FontAwesomeIcons.arrowAltCircleDown,
      filter: Filter.Downloading,
    ),
    FilterTile(
      icon: Icons.done_outline,
      filter: Filter.Completed,
    ),
    FilterTile(
      icon: Icons.open_with,
      filter: Filter.Active,
    ),
    FilterTile(
      icon: Icons.not_interested,
      filter: Filter.Inactive,
    ),
    FilterTile(
      icon: Icons.error,
      filter: Filter.Error,
    ),
  ];

  get selectedFilter => _selectedFilter;
  get filterTileList => _filterTileList;

  changeFilter(Filter newFilter){
    _selectedFilter = newFilter;
    notifyListeners();
  }

  List<Torrent> filterList(List<Torrent> torrentsList, Filter filter){
    switch(filter){
      case Filter.All:
        return torrentsList;
      case Filter.Downloading:
        return torrentsList.where((torrent) => torrent.status==Status.downloading).toList();
      case Filter.Completed:
        return torrentsList.where((torrent) => torrent.status==Status.completed).toList();
      case Filter.Active:
        return torrentsList.where((torrent) => torrent.ulSpeed>0 || torrent.dlSpeed>0).toList();
      case Filter.Inactive:
        return torrentsList.where((torrent) => torrent.ulSpeed==0 && torrent.dlSpeed==0).toList();
      case Filter.Error:
        return torrentsList.where((torrent) => torrent.msg.length>0 && torrent.msg!='Tracker: [Tried all trackers.]').toList();
      default:
        return torrentsList;
    }
  }

  List<Torrent> sortList(List<Torrent> torrentsList, Sort sort,){
    switch(sort){
      case Sort.name:
        torrentsList.sort((a,b)=>a.name.compareTo(b.name));
        return torrentsList;
      case Sort.dateAdded:
        torrentsList.sort((a,b)=>a.torrentAdded.compareTo(b.torrentAdded));
        return torrentsList;
      case Sort.percentDownloaded:
        torrentsList.sort((a,b)=>a.percentageDownload.compareTo(b.percentageDownload));
        return torrentsList;
      case Sort.downloadSpeed:
        torrentsList.sort((a,b)=>a.dlSpeed.compareTo(b.dlSpeed));
        return torrentsList;
      case Sort.uploadSpeed:
        torrentsList.sort((a,b)=>a.ulSpeed.compareTo(b.ulSpeed));
        return torrentsList;
      case Sort.ratio:
        torrentsList.sort((a,b)=>a.ratio.compareTo(b.ratio));
        return torrentsList;
      case Sort.size:
        torrentsList.sort((a,b)=>a.size.compareTo(b.size));
        return torrentsList;
      default:
        return torrentsList;
    }
  }

}