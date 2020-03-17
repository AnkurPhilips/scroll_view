import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class IndexedContainer extends StatelessWidget
{
  final Color color;
  final double height;
  final double width;
  final GlobalKey key ;
  final int index;

  IndexedContainer({this.color,this.height,this.width,this.index,this.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Text('$index',),
      decoration: BoxDecoration(
          color: color
      ),
    );
  }
}
class MyApp extends StatefulWidget
{
  @override
  _MyApp createState()=> _MyApp();
}
class _MyApp extends State<MyApp>
{
  ScrollController _controller=new ScrollController();
  static Map<int,GlobalKey> keys;
  static Map<GlobalKey,double> height;
  static double minScroll=24;
  static bool custom = false;

  Widget getWidget(Color color, double h, double w, Map<int,GlobalKey> keys,int index)
  {
    GlobalKey key =GlobalKey();
    keys[index]=key;
    //print(key);
    return IndexedContainer(
      color: color,
      height: h,
      width: w,
      index: index,
      key: key,
    );
  }

  void pD(var message){print("Drag");}
  void pT(){print("Tap");}

  void scroll(var abc)
  {
    //print("Start");
    for(var i in keys.values)
    {
      if(i.currentContext==null)
        continue;

      print('3');
      RenderBox renderBox = i.currentContext.findRenderObject();
      //print(renderBox.localToGlobal(Offset.zero).dy);
      //print(minScroll);
      print(renderBox.localToGlobal(Offset.zero).dy>minScroll);
      if(renderBox.localToGlobal(Offset.zero).dy>=minScroll) {
        setState(() {
//          _controller.animateTo(_controller.offset + renderBox
//              .localToGlobal(Offset.zero).dy - minScroll,duration: Duration(milliseconds: 200),curve: Curves.linear);
            _controller.jumpTo(_controller.offset + renderBox.localToGlobal(Offset.zero).dy - minScroll);
        });

        break;
      }
    }
    //print('stop');
  }

  @override
  void initState()
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    keys = Map<int,GlobalKey>();
    List<Widget> widgetList = new List<Widget>();
    int index=0;

    for(var i=0;i<4;i++){
      widgetList.add(getWidget(Colors.red,100,200,keys,index++));
      widgetList.add(getWidget(Colors.blue,150,80,keys,index++));
      widgetList.add(getWidget(Colors.green,210,150,keys,index++));
    }

    ListView listView = new ListView(
      controller: _controller,
      children: widgetList,
    );
//    return Scaffold(
//      body: GestureDetector(
//        onVerticalDragDown: pD,
//        onTap: null,
//        child: Container(
//          child: listView,
//        )
//
//      )
//    );
      return Scaffold(
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification){
            if(custom==true) {
              print(2);
              return;
            }
            if(scrollNotification is ScrollEndNotification){
              if(custom==false)
              setState(() {
                custom = true;
              });
              print('1');
              scroll('');
              if(custom==true)
              setState(() {
                custom = false;
              });
            }
            return;
          },
          child: listView,
        ),
      );
  }
}
void main()
{
  runApp(MaterialApp(
    title: 'Yolo',
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}