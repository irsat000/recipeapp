import 'package:recipeapp222003545/page/home.dart';
import 'package:recipeapp222003545/page/favorites.dart';
import 'package:recipeapp222003545/page/advanced.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yemek Tarifleri',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainApp(title: 'Yemek tarifi uygulaması', pageIndex: 0),
    );
  }
}

class MainApp extends StatefulWidget {
  final int pageIndex;
  final String title;
  String? kategori;

  MainApp(
      {Key? key, required this.title, required this.pageIndex, String? kate})
      : super(key: key) {
    if (kate != null) {
      kategori = kate;
    }
  }

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // ignore: non_constant_identifier_names
  int _CurrentPageIndex = 0;
  var pages = [
    const HomePage(),
    const FavoritesPage(),
    AdvancedPage(),
  ];
  @override
  void initState() {
    _CurrentPageIndex = widget.pageIndex;
    if (widget.kategori != null) {
      pages = [
        const HomePage(),
        const FavoritesPage(),
        AdvancedPage(kate: widget.kategori),
      ];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 227, 237),
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/appimages/appicon.png'),
          ),
        ),
        title: Text(
          "Yemek tarifleri",
          style: GoogleFonts.carterOne(
            fontSize: 24,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.search,
                size: 34.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.account_circle,
                size: 34.0,
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _CurrentPageIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        currentIndex: _CurrentPageIndex,
        unselectedItemColor: Colors.grey[50],
        selectedItemColor: Colors.cyan,
        unselectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        onTap: (index) {
          setState(() {
            _CurrentPageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
              size: 24,
            ),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star_rounded,
              size: 24,
            ),
            label: 'Kaydedilenler',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.filter_alt_rounded,
              size: 24,
            ),
            label: 'Gelişmiş',
          ),
        ],
      ),
    );
  }
}
