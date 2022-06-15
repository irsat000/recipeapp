import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipeapp222003545/models/tarif_listitem.dart';
import 'package:recipeapp222003545/code_templates.dart';
//import 'package:recipeapp222003545/page/recipe_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with MyCodeTemplates {
  List<TarifListItem> _pTarifList = [];
  List<TarifListItem> _pVejetaryenList = [];
  List<TarifListItem> _pVeganList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _jsonPTarifList();
    });
  }

  //P = popüler
  void _jsonPTarifList() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/json/tariflistesi.json');
      Map<String, dynamic> tariflistMap = json.decode(jsonString);
      for (String tId in tariflistMap.keys) {
        Map<String, dynamic> item = tariflistMap[tId];
        if (item["popular"] == true) {
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
          if (item["vejetaryen"] == 1) {
            _pTarifList.add(tItem);
          } else if (item["vejetaryen"] == 2) {
            _pVejetaryenList.add(tItem);
          } else if (item["vejetaryen"] == 3) {
            _pVeganList.add(tItem);
          }
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
      backgroundColor: const Color.fromARGB(255, 235, 235, 239),
      body: ListView(
        children: [
          SizedBox(
            height: 178,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const SizedBox(
                  width: 6,
                ),
                buildKategoriList(context, "assets/appimages/evyemekleri.png",
                    kate: "evyemekleri"),
                buildKategoriList(context, "assets/appimages/tatlilar.png",
                    kate: "tatlilar"),
                buildKategoriList(context, "assets/appimages/corbalar.png",
                    kate: "corbalar"),
                buildKategoriList(context, "assets/appimages/pideler.png",
                    kate: "pideler"),
                buildKategoriList(context, "assets/appimages/deniz.png",
                    kate: "deniz"),
                buildKategoriList(context, "assets/appimages/firinurunleri.png",
                    kate: "firin"),
                buildKategoriList(context, "assets/appimages/fastfood.png",
                    kate: "fastfood"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 12),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Popüler tarifler',
                style: GoogleFonts.lobster(
                  color: Colors.indigo[400],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 170,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: _pTarifList.length,
              itemBuilder: (ctxt, index) =>
                  _buildHorizontalList(ctxt, index, ptariflist: _pTarifList),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 12),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Popüler (Vegan)',
                style: GoogleFonts.lobster(
                  color: Colors.indigo[400],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 170,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: _pVeganList.length,
              itemBuilder: (ctxt, index) =>
                  _buildHorizontalList(ctxt, index, ptariflist: _pVeganList),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 12),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Popüler (Vejetaryen)',
                style: GoogleFonts.lobster(
                  color: Colors.indigo[400],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 170,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: _pVejetaryenList.length,
              itemBuilder: (ctxt, index) => _buildHorizontalList(ctxt, index,
                  ptariflist: _pVejetaryenList),
            ),
          ),
          /*
          ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: _pTarifList.length,
            itemBuilder: (ctxt, index) =>
                buildTarifList(ctxt, index, ptariflist: _pTarifList),
          ),*/
        ],
      ),
    );
  }

  Widget _buildHorizontalList(BuildContext context, int index,
      {required List<TarifListItem> ptariflist}) {
    TarifListItem tarifitem = ptariflist[index];
    return Container(
      margin:
          const EdgeInsets.only(left: 6.0, right: 6.0, top: 0, bottom: 14.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: -6,
            blurRadius: 4,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: InkWell(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: 190,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  image: DecorationImage(
                    image: AssetImage(tarifitem.image == ""
                        ? "assets/appimages/noimage.jpg"
                        : tarifitem.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              height: 60,
              width: 190,
              padding:
                  const EdgeInsets.only(top: 4, bottom: 4, right: 6, left: 6),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 246, 243, 243),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tarifitem.yemekadi,
                    style: GoogleFonts.kalam(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "${tarifitem.begenisayisi} beğeni - ${tarifitem.hazirlamasuresimin + tarifitem.pisirmesuresimin} dk.",
                    style: GoogleFonts.kalam(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          recipeDetailLink(context, tarifitem);
        },
      ),
    );
  }
}
