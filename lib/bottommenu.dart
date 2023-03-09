

import 'package:flutter/material.dart';


class firstPage extends StatefulWidget {
  const firstPage({ Key? key }) : super(key: key);

  @override
  _firstPageState createState() => _firstPageState();
}


class _firstPageState extends State<firstPage> {

  @override
  Widget build(BuildContext context) {
    Widget bottomMenu(){
      return bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
      icon: Icon(Icons.call),
      label: 'Calls',
      ),
      BottomNavigationBarItem(
      icon: Icon(Icons.camera),
      label: 'Camera',
      ),
      BottomNavigationBarItem(
      icon: Icon(Icons.chat),
      label: 'Chats',
      ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.red,
      onTap: _onItemTapped,
      ),
    }

    return Scaffold(
      //backgroundColor: Colors.transparent,
      body:
      Stack(
        children: [

          Container(

              decoration:  BoxDecoration(
                /* image:  DecorationImage(image: AssetImage("assets/waves3.png"),
                    fit: BoxFit.fitHeight,
                    colorFilter:  ColorFilter.mode(appBgColor.withOpacity(1), BlendMode.dstATop),
                  ),*/
                  color: Colors.red,//Color(0xffeeeee4),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0))),
              child:  CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.green,//appBarColor,
                    pinned: true,
                    snap: true,
                    floating: true,
                    title: Text("First Page"),
                  ),

                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                          Container(

                              child: Text("azampage") /* buildBody(),*/
                          ),

                      childCount: 1,
                    ),
                  )
                ],
              )
          ),


        ],
      ),
    );
  }



}