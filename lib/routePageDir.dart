import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'routePage.dart';


class DirPage extends StatefulWidget {
  DirPage({ Key? key, required this.uri, required this.title }) : super(key: key);
  final Uri uri;
  final String title;
  @override
  _DirPageState createState() => _DirPageState();
}

class _DirPageState extends State<DirPage> {
  List<FileSystemEntity>? _currentDir;
  @override
  void initState() {
    super.initState();
    _currentDir = Directory.fromUri(widget.uri).listSync();
  }
  @override
  Widget build(BuildContext context) {
    List<ListTile> _listOfItem = [];
    for (var value in _currentDir!) {
            _listOfItem.add(ListTile(
              title: Text(basename(value.path)),
              subtitle: Text(value.path),
              onTap: (){
                if (FileSystemEntity.isDirectorySync(value.path)){
                //去往文件夹
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return DirPage(uri: value.uri, title: basename(value.path));
                    }));
                  } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return PlayPage(url: value.uri.toString(), title: basename(value.path));
                  }));
                }
              },
            ));
    }
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body : ListView(
          children: _listOfItem,
        )
    );
  }
}
