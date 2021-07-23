import 'package:flutter/material.dart';
import 'package:kigger/routePageDir.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'routePage.dart';
import 'package:path/path.dart';
void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kigger',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: '个人自用锻炼'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Directory?>? _externalStorageDirectory;
  @override
  void initState() {
    super.initState();
    _setDir();
  }
  void _setDir() {
    setState(() {
      _externalStorageDirectory = getExternalStorageDirectory();
    });
  }
  Widget _buildDirectory(BuildContext context, AsyncSnapshot<Directory?> snapshot){
    Text text = const Text('');
    if (snapshot.connectionState == ConnectionState.done){
      if (snapshot.hasError){
        text = Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData){
        List<Widget> listOfFile = [Text('父目录${snapshot.data!.path}')];//此处设置跳转路由
        for (var value in snapshot.data!.listSync()){ 
          listOfFile.add(ListTile(
            title: Text('${FileSystemEntity.isDirectorySync(value.path)? "【文件夹】" + basename(value.path) : basename(value.path)}'),
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
        return ListView(
          children: listOfFile,
        );
      } else {
        text = const Text('路径不可见');
      }
    }
    return Padding(padding: const EdgeInsets.all(16.0), child: text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<Directory?>(
              future: _externalStorageDirectory,
              builder: _buildDirectory,
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
