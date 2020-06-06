import 'package:flutter/material.dart';

import 'models/task.dart';

/// This file contains constants which can be used in any part of the project
class  Constants{

}

Map<Status,String> statusMap = {
  Status.downloading : 'start',
  Status.pausing : 'pause',
  Status.stopped: 'stop',
};