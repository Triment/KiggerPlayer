import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
class PlayPage extends StatefulWidget {
  final String url;
  final String title;
  PlayPage({ Key? key, required this.url, required this.title });

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  final FijkPlayer player = FijkPlayer();
  _PlayPageState();

  @override
  void initState(){
    super.initState();
    player.setDataSource(widget.url, autoPlay: true);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Container(
          alignment: Alignment.center,
          child: FijkView(
            player: player,
          ),
        )
    );
  }

  @override
  void dispose(){
    super.dispose();
    player.release();
  }
}