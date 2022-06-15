import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipeapp222003545/models/tarif_listitem.dart';
import 'package:recipeapp222003545/code_templates.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with MyCodeTemplates {
  List<String> _favRecipeIds = [];
  List<TarifListItem> _favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _favFetch().then((_) {
        _jsonTarifList();
      });
    });
  }

  Future<void> _favFetch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favs = prefs.getStringList("favoriler");
    if (favs != null) {
      for (String tId in favs) {
        _favRecipeIds.add(tId);
      }
    }
  }

  void _jsonTarifList() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/json/tariflistesi.json');
      Map<String, dynamic> tariflistMap = json.decode(jsonString);
      for (String tId in tariflistMap.keys) {
        if (_favRecipeIds.contains(tId)) {
          Map<String, dynamic> item = tariflistMap[tId];
          TarifListItem tItem = TarifListItem(
            int.parse(tId),
            item["yemekadi"],
            item["kategori"],
            item["begenisayisi"],
            item["image"],
            item["popular"],
            item["vejetaryen"],
            item["hazirlamasuresimin"],
            item["hazirlamasuresimax"],
            item["pisirmesuresimin"],
            item["pisirmesuresimax"],
            item["tarifid"],
            item["youtube_link"],
          );
          _favoriteRecipes.add(tItem);
        } else {
          continue;
        }
      }
      setState(() {});
    } catch (e) {
      print("Bir hata oluştu: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(
            const Duration(seconds: 1),
            () {
              setState(() {
                _favRecipeIds.clear();
                _favoriteRecipes.clear();
                _favFetch().then((_) {
                  _jsonTarifList();
                });
              });
            },
          );
        },
        child: _favoriteRecipes.isEmpty
            ? ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        top: 20, bottom: 20, left: 8, right: 8),
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        "Favoriler Boş",
                        style: GoogleFonts.courgette(
                          fontSize: 30,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 14, bottom: 4, top: 12, right: 4),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Favoriler',
                        style: GoogleFonts.lobster(
                          color: Colors.indigo[400],
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: _favoriteRecipes.length,
                    itemBuilder: (ctxt, index) => buildTarifList(ctxt, index,
                        ptariflist: _favoriteRecipes),
                  ),
                ],
              ),
      ),
    );
  }
}
