import 'package:fitnessappadmin/screens/challenges_page.dart';
import 'package:fitnessappadmin/screens/diet_page.dart';
import 'package:flutter/material.dart';

class NavigationHandlerPage extends StatefulWidget {
  const NavigationHandlerPage({Key? key}) : super(key: key);

  @override
  _NavigationHandlerPageState createState() => _NavigationHandlerPageState();
}

class _NavigationHandlerPageState extends State<NavigationHandlerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentTab = 0;
  final List<Widget> screens = [
    // const DashBoardPage(),
    const ChallengesPage(),
    const DietPage(),
    // const NewsPage(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const ChallengesPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      bottomNavigationBar: BottomAppBar(
        //bottom navigation bar on scaffold
        color: Colors.white,

        child: Row(
          //children inside bottom appbar
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              tooltip: 'Challenges',
              icon: Icon(Icons.list,
                  color:
                      currentTab == 1 ? Colors.green.shade900 : Colors.black54),
              onPressed: () {
                setState(() {
                  currentScreen = const ChallengesPage();
                  currentTab = 1;
                });
              },
            ),
            IconButton(
              tooltip: 'Diets',
              icon: Icon(Icons.dining,
                  color:
                      currentTab == 2 ? Colors.green.shade900 : Colors.black54),
              onPressed: () {
                setState(() {
                  currentScreen = const DietPage();
                  currentTab = 2;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
