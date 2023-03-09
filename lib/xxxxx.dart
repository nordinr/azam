import 'package:flutter/material.dart';

class dashboadrState extends StatefulWidget {
  const dashboadrState({Key? key}) : super(key: key);

  @override
  State<dashboadrState> createState() => _dashboadrStateState();
}

class _dashboadrStateState extends State<dashboadrState> {
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 80.0, right: 250),
              child: Center(
                child: Container(
                  width: 200.0,
                  height: 20.0,
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                  child: (const Text(
                    'Hello',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 300.0, top: 1.0),
              child: IconButton(
                icon: const Icon(Icons.account_circle, size: 30.0),
                onPressed: () {
                  print("hit");
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => Notifications(),
                  //   ),
                  // );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 300.0, top: 5.0),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications,
                  size: 25.0,
                ),
                onPressed: () {
                  print("hit ");
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => Notifications(),
                  //   ),
                  // );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Center(
                child: Container(
                  width: 390,
                  height: 450,
                  decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => updatefaqScreen(fqID:listfq[index]["fqID"],fqQuestion:listfq[index]["fqQuestion"],fqAnswer:listfq[index]["fqAnswer"]),
          ),
        );
        // await authService.signOut();
      }),
    ),
    const Text(
      'Index 1: Business',
    ),
    const Text(
      'Index 2: School',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      //  : _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.green[100],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Page 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.read_more),
            label: 'Page 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}