import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipeapp222003545/main.dart';
import 'package:recipeapp222003545/models/tarif_listitem.dart';
import 'package:recipeapp222003545/page/recipe_detail.dart';

class MyCodeTemplates {
  void recipeDetailLink(BuildContext context, TarifListItem tarif) {
    MaterialPageRoute pageRoute =
        MaterialPageRoute(builder: (BuildContext context) {
      return RecipeDetail(tarifitem: tarif);
    });

    Navigator.push(context, pageRoute);
  }

  /* Example
    buildKategoriList("assets/appimages/fastfood.png"),
  */
  Widget buildKategoriList(BuildContext context, String imglink,
      {required String kate}) {
    return InkWell(
      onTap: () {
        MaterialPageRoute pageRoute =
            MaterialPageRoute(builder: (BuildContext context) {
          return MainApp(
              title: 'Yemek tarifi uygulaması', pageIndex: 2, kate: kate);
        });

        Navigator.push(context, pageRoute);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 14.0, top: 14.0, bottom: 14.0),
        width: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(imglink),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTarifList(BuildContext context, int index,
      {required List<TarifListItem> ptariflist}) {
    TarifListItem tarifitem = ptariflist[index];

    return Card(
      child: ExpansionTile(
        title: Text(
          tarifitem.yemekadi,
          style: GoogleFonts.courgette(
            color: Colors.grey[800],
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 6.0, bottom: 14.0),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Hazırlama: ${tarifitem.hazirlamasuresimin} - ${tarifitem.hazirlamasuresimax} dakika",
                            style: GoogleFonts.vollkorn(
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Pişirme: ${tarifitem.pisirmesuresimin} - ${tarifitem.pisirmesuresimax} dakika",
                            style: GoogleFonts.vollkorn(
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${tarifitem.begenisayisi} beğeni",
                            style: GoogleFonts.vollkorn(
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            child: Text(
                              "Tarife Git",
                              style: GoogleFonts.fredokaOne(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              recipeDetailLink(context, tarifitem);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 127, 148, 199)),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.only(left: 30, right: 30)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 120,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(tarifitem.image == ""
                            ? "assets/appimages/noimage.jpg"
                            : tarifitem.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      color: Colors.transparent,
      elevation: 0,
      shape: const Border(
        bottom: BorderSide(width: 1, color: Color.fromARGB(255, 207, 214, 219)),
      ),
    );
  }
}
