import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/components/data_input.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/models/rss_filter.dart';
import 'package:rutorrentflutter/models/settings.dart';
import 'package:rutorrentflutter/utilities/constants.dart';

class RSSFilterEditScreen extends StatefulWidget {
  final List<RSSFilter> rssFilters;
  final int index;
  final Function func;
  RSSFilterEditScreen({this.rssFilters, this.index, this.func});
  @override
  _RSSFilterEditScreenState createState() => _RSSFilterEditScreenState();
}

class _RSSFilterEditScreenState extends State<RSSFilterEditScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController patternController = TextEditingController();
  final TextEditingController excludeController = TextEditingController();
  final TextEditingController directoryController = TextEditingController();
  final TextEditingController labelController = TextEditingController();
  final FocusNode nameFocus = FocusNode();
  final FocusNode patternFocus = FocusNode();
  final FocusNode excludeFocus = FocusNode();
  final FocusNode directoryFocus = FocusNode();
  final FocusNode labelFocus = FocusNode();
  bool checkTitle = true;
  bool checkDescription = false;
  bool checkLink = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    nameController.text =
        widget.rssFilters[widget.index]?.name?.replaceAll("+", " ") ?? "";
    patternController.text = widget.rssFilters[widget.index]?.pattern ?? "";
    excludeController.text = widget.rssFilters[widget.index]?.exclude ?? "";
    directoryController.text = widget.rssFilters[widget.index]?.dir ?? "";
    labelController.text = widget.rssFilters[widget.index]?.label ?? "";
    checkTitle =
        (widget.rssFilters[widget.index]?.checkTitle ?? 1) == 1 ? true : false;
    checkDescription =
        (widget.rssFilters[widget.index]?.checkDescription ?? 0) == 1
            ? true
            : false;
    checkLink =
        (widget.rssFilters[widget.index]?.checkLink ?? 0) == 1 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<Settings, GeneralFeatures>(
        builder: (context, settings, general, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit RSS Filter',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Text("Name",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17))
                    ],
                  ),
                ),
                Container(
                  child: DataInput(
                    onFieldSubmittedCallback: (v) {
                      FocusScope.of(context).requestFocus(nameFocus);
                    },
                    onChangedCallback: (v) {
                      widget.rssFilters[widget.index].name =
                          nameController.text;
                      widget.func(widget.rssFilters);
                    },
                    focus: nameFocus,
                    textEditingController: nameController,
                    hintText: 'Torrent Name',
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Text("Pattern",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17))
                    ],
                  ),
                ),
                Container(
                  child: DataInput(
                    onFieldSubmittedCallback: (v) {
                      FocusScope.of(context).requestFocus(patternFocus);
                    },
                    onChangedCallback: (v) {
                      widget.rssFilters[widget.index].pattern =
                          patternController.text;
                      widget.func(widget.rssFilters);
                    },
                    focus: patternFocus,
                    textEditingController: patternController,
                    hintText: 'Torrent Pattern',
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Text("Exclude",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17))
                    ],
                  ),
                ),
                Container(
                  child: DataInput(
                    onFieldSubmittedCallback: (v) {
                      FocusScope.of(context).requestFocus(excludeFocus);
                    },
                    onChangedCallback: (v) {
                      widget.rssFilters[widget.index].label =
                          labelController.text;
                      widget.func(widget.rssFilters);
                    },
                    focus: excludeFocus,
                    textEditingController: excludeController,
                    hintText: 'Exclude',
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Text("Directory",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17))
                    ],
                  ),
                ),
                Container(
                  child: DataInput(
                    onFieldSubmittedCallback: (v) {
                      FocusScope.of(context).requestFocus(directoryFocus);
                    },
                    onChangedCallback: (v) {
                      widget.rssFilters[widget.index].dir =
                          directoryController.text;
                      widget.func(widget.rssFilters);
                    },
                    focus: directoryFocus,
                    textEditingController: directoryController,
                    hintText: 'Torrent Directory',
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Text("Label",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17))
                    ],
                  ),
                ),
                Container(
                  child: DataInput(
                    onFieldSubmittedCallback: (v) {
                      FocusScope.of(context).requestFocus(labelFocus);
                    },
                    onChangedCallback: (v) {
                      widget.rssFilters[widget.index].label =
                          labelController.text;
                      widget.func(widget.rssFilters);
                    },
                    focus: labelFocus,
                    textEditingController: labelController,
                    hintText: 'Torrent Label',
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  dense: true,
                  leading: Icon(
                    Icons.description,
                    color: Provider.of<Mode>(context).isLightMode
                        ? Colors.black
                        : Colors.white,
                  ),
                  title: Text('Check Title',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    'Check for pattern in Torrent title',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: Checkbox(
                    activeColor: Theme.of(context).primaryColor,
                    value: checkTitle,
                    onChanged: (val) {
                      setState(() {
                        checkTitle = val;
                      });
                      widget.rssFilters[widget.index].checkTitle = val ? 1 : 0;
                      widget.func(widget.rssFilters);
                    },
                  ),
                ),
                ListTile(
                  // enabled: checkDescription,
                  dense: true,
                  leading: Icon(
                    Icons.description_rounded,
                    color: Provider.of<Mode>(context).isLightMode
                        ? Colors.black
                        : Colors.white,
                  ),
                  title: Text('Check Description',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    'Check for pattern in Torrent description',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: Checkbox(
                    activeColor: Theme.of(context).primaryColor,
                    value: checkDescription,
                    onChanged: (val) {
                      setState(() {
                        checkDescription = val;
                      });
                      widget.rssFilters[widget.index].checkDescription =
                          val ? 1 : 0;
                      widget.func(widget.rssFilters);
                    },
                  ),
                ),
                ListTile(
                  // enabled: checkLink,
                  dense: true,
                  leading: Icon(
                    Icons.link,
                    color: Provider.of<Mode>(context).isLightMode
                        ? Colors.black
                        : Colors.white,
                  ),
                  title: Text('Check Link',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    'Check for pattern in Torrent link',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: Checkbox(
                    activeColor: Theme.of(context).primaryColor,
                    value: checkLink,
                    onChanged: (val) {
                      setState(() {
                        checkLink = val;
                      });
                      widget.rssFilters[widget.index].checkLink = val ? 1 : 0;
                      widget.func(widget.rssFilters);
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "SAVE",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor),
                            ),
                            side: BorderSide(
                                color: Theme.of(context).primaryColor),
                            primary: kGreenActiveLT),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.rssFilters
                              .remove(widget.rssFilters[widget.index]);
                          widget.func(widget.rssFilters);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "DELETE",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor),
                            ),
                            side: BorderSide(
                                color: Theme.of(context).primaryColor),
                            primary: kRedErrorDT),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
