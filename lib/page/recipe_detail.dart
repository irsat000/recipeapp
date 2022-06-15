import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipeapp222003545/models/tarif_listitem.dart';
import 'package:recipeapp222003545/models/tarif.dart';
import 'package:recipeapp222003545/code_templates.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RecipeDetail extends StatefulWidget {
  final TarifListItem tarifitem;

  const RecipeDetail({Key? key, required this.tarifitem}) : super(key: key);
  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> with MyCodeTemplates {
  TarifDetay tarifdetail = TarifDetay(0, ["0"], "0", ["0"], "dQw4w9WgXcQ");
  YoutubePlayerController? youtubeController;
  late bool internetVarmi = false;
  late bool tarifVarmi = false;
  late bool videoVarmi = false;
  List<String> _favRecipeIds = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkInternet().then((bool check) {
        if (check == true) {
          _getVideo();
          internetVarmi = true;
        } else {
          internetVarmi = false;
        }
        setState(() {});
        //print("Internet: $internetVarmi");
      });
      _favFetch().then((_) {
        _jsonTarifDetails();
      });
    });
  }

  Future<bool> checkInternet() async {
    var result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      return true;
    } else {
      return false;
    }
  }

  void _getVideo() {
    try {
      String link = "dQw4w9WgXcQ";
      if (widget.tarifitem.youtubeLink == "") {
        videoVarmi = false;
      } else {
        videoVarmi = true;
        link = widget.tarifitem.youtubeLink;
      }
      youtubeController = YoutubePlayerController(
        initialVideoId: link,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    } catch (e) {
      print("ERROR: ${e.toString()}");
    }
  }

  void _jsonTarifDetails() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/json/tarifdetay.json');

      Map<String, dynamic> tarifDetailMap = json.decode(jsonString);
      Map<String, dynamic> item;
      if (tarifDetailMap[(widget.tarifitem.tarifid).toString()]?.isEmpty ??
          true) {
        tarifVarmi = false;
      } else {
        tarifVarmi = true;
        item = tarifDetailMap[(widget.tarifitem.tarifid).toString()];
        List<dynamic> malzemelerD = item["malzemeler"];
        List<dynamic> pufNoktalarD = item["puf_noktalar"];
        List<String> malzemeler = malzemelerD.map((e) => e.toString()).toList();
        List<String> pufNoktalar =
            pufNoktalarD.map((e) => e.toString()).toList();

        String nasilyapilir = item["nasil_yapilir"];
        String youtubelink = item["youtube_link"];

        tarifdetail = TarifDetay(
          widget.tarifitem.tarifid,
          malzemeler,
          nasilyapilir,
          pufNoktalar,
          youtubelink,
        );
      }

      setState(() {});
    } catch (e) {
      print("Bir hata oluştu: ${e.toString()}");
    }
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

  void _favClick(TarifListItem tarifListItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_favRecipeIds.contains(tarifListItem.id.toString())) {
      _favRecipeIds.remove(tarifListItem.id.toString());
    } else {
      _favRecipeIds.add(tarifListItem.id.toString());
    }
    await prefs.setStringList("favoriler", _favRecipeIds);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text(
          "${widget.tarifitem.yemekadi} tarifi",
          style: GoogleFonts.oswald(
            fontSize: 22,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                _favClick(widget.tarifitem);
              },
              child: _favRecipeIds.contains(widget.tarifitem.id.toString())
                  ? Icon(
                      Icons.favorite,
                      size: 34.0,
                      color: Colors.red[600],
                    )
                  : const Icon(
                      Icons.favorite_border,
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
      body: ListView(
        children: [
          Container(
            //margin: const EdgeInsets.only(bottom: 6.0),
            decoration: const BoxDecoration(
              color: Colors.red,
              //borderRadius: BorderRadius.circular(2),
              /*boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],*/
            ),
            child: Image(
                image: AssetImage(widget.tarifitem.image == ""
                    ? "assets/appimages/noimage.jpg"
                    : widget.tarifitem.image)),
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 16, top: 8, bottom: 12, right: 4),
            color: Colors.grey[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.tarifitem.yemekadi,
                  style: GoogleFonts.lobster(
                    fontSize: 28,
                    //fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Hazırlama süresi: ${widget.tarifitem.hazirlamasuresimin} - ${widget.tarifitem.hazirlamasuresimax} dk",
                  style: GoogleFonts.courgette(
                    fontSize: 20,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Pişirme süresi: ${widget.tarifitem.pisirmesuresimin} - ${widget.tarifitem.pisirmesuresimax} dk",
                  style: GoogleFonts.courgette(
                    fontSize: 20,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          (() {
            if (tarifVarmi == true) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.only(
                        left: 16, top: 8, bottom: 12, right: 4),
                    color: Colors.grey[50],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Malzemeler",
                          style: GoogleFonts.courgette(
                            fontSize: 26,
                            //fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: tarifdetail.malzemeler.length,
                            itemBuilder: (ctxt, index) =>
                                buildListRecipeDetails_1(ctxt, index,
                                    list: tarifdetail.malzemeler),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.only(
                        left: 16, top: 8, bottom: 12, right: 4),
                    color: Colors.grey[50],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Püf Noktalar",
                          style: GoogleFonts.courgette(
                            fontSize: 26,
                            //fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        (() {
                          if (tarifdetail.pufNoktalar.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: tarifdetail.pufNoktalar.length,
                                itemBuilder: (ctxt, index) =>
                                    buildListRecipeDetails_1(ctxt, index,
                                        list: tarifdetail.pufNoktalar),
                              ),
                            );
                          } else {
                            return Container(
                              padding: const EdgeInsets.all(20),
                              child: Center(
                                child: Text(
                                  "Püf nokta yok",
                                  style: GoogleFonts.courgette(
                                    fontSize: 30,
                                    color: Colors.red[800],
                                  ),
                                ),
                              ),
                            );
                          }
                        }())
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 6, bottom: 6),
                    padding: const EdgeInsets.only(
                        left: 16, top: 8, bottom: 12, right: 4),
                    color: Colors.grey[50],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hazırlanışı",
                          style: GoogleFonts.courgette(
                            fontSize: 26,
                            //fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tarifdetail.nasilYapilir,
                                style: GoogleFonts.courgette(
                                  fontSize: 20,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Container(
                margin: const EdgeInsets.only(bottom: 6, top: 6),
                padding: const EdgeInsets.all(10),
                color: Colors.grey[50],
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      "Tarif Yok",
                      style: GoogleFonts.courgette(
                        fontSize: 30,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                ),
              );
            }
          }()),
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.all(10),
            color: Colors.grey[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Videolu anlatım",
                  style: GoogleFonts.courgette(
                    fontSize: 26,
                    //fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                (() {
                  if (internetVarmi == true && videoVarmi == true) {
                    return YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller: youtubeController!,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.blueAccent,
                      ),
                      builder: (context, player) {
                        return Column(
                          children: [
                            player,
                          ],
                        );
                      },
                    );
                  } else if (internetVarmi == true && videoVarmi == false) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          "Video Yok",
                          style: GoogleFonts.courgette(
                            fontSize: 30,
                            color: Colors.red[800],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          "İnternet Yok",
                          style: GoogleFonts.courgette(
                            fontSize: 30,
                            color: Colors.red[800],
                          ),
                        ),
                      ),
                    );
                  }
                }())
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildListRecipeDetails_1(BuildContext context, int index,
      {required List<String> list}) {
    String x = list[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Text(
        "\u2726 $x",
        style: GoogleFonts.courgette(
          fontSize: 20,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}
