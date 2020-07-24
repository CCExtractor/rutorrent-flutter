class HistoryItem{

  static const Map<int,String> historyStatus = {
    1 : 'Added',
    2 : 'Finished',
    3 : 'Deleted',
  };

  String name;
  int action;
  int actionTime;

  HistoryItem(this.name,this.action,this.actionTime);
}