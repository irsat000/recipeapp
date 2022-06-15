import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipeapp222003545/models/tarif_listitem.dart';
import 'package:recipeapp222003545/code_templates.dart';

class AdvancedPage extends StatefulWidget {
  String? kategori;
  AdvancedPage({Key? key, String? kate}) : super(key: key) {
    if (kate != null) {
      kategori = kate;
    }
  }

  @override
  State<AdvancedPage> createState() => _AdvancedPageState();
}

class _AdvancedPageState extends State<AdvancedPage> with MyCodeTemplates {
  List<TarifListItem> _tariflist = [];
  bool filtered = false;
  List<TarifListItem> _filteredTarifList = [];

  Map<String, dynamic> filterItemValueList = {
    "fSure": 'Seçiniz',
    "fSirala": 'Seçiniz',
    "fVejetaryen": false,
    "fVegan": false,
    "fEvyemek": false,
    "fTatli": false,
    "fCorba": false,
    "fPide": false,
    "fDeniz": false,
    "fFirin": false,
    "fFastfood": false
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _jsonTarifList();
    });
  }

  void _jsonTarifList() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/json/tariflistesi.json');
      Map<String, dynamic> tariflistMap = json.decode(jsonString);
      for (String tId in tariflistMap.keys) {
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
        _tariflist.add(tItem);
      }
      setState(() {});
    } catch (e) {
      print("Bir hata oluştu: ${e.toString()}");
    }
  }

  void fetchWithFilter() {
    bool kateSecilmis = false;
    bool VVSecilmis = false;
    bool sureSecilmis = false;
    if (filterItemValueList["fEvyemek"] == true ||
        filterItemValueList["evyemekleri"] == true ||
        filterItemValueList["fPide"] == true ||
        filterItemValueList["fCorba"] == true ||
        filterItemValueList["fTatli"] == true ||
        filterItemValueList["fFirin"] == true ||
        filterItemValueList["fFastfood"] == true ||
        filterItemValueList["fDeniz"] == true) {
      kateSecilmis = true;
    }
    if (filterItemValueList["fVejetaryen"] == true ||
        filterItemValueList["fVegan"] == true) {
      VVSecilmis = true;
    }
    if (filterItemValueList["fSure"] != "Seçiniz") {
      sureSecilmis = true;
    }

    setState(() {
      _filteredTarifList = _tariflist.where((i) {
        if (((filterItemValueList["fEvyemek"] == true &&
                    i.kategori == "evyemekleri") ||
                (filterItemValueList["fPide"] == true &&
                    i.kategori == "pideler") ||
                (filterItemValueList["fCorba"] == true &&
                    i.kategori == "corbalar") ||
                (filterItemValueList["fTatli"] == true &&
                    i.kategori == "tatlilar") ||
                (filterItemValueList["fFirin"] == true &&
                    i.kategori == "firin") ||
                (filterItemValueList["fFastfood"] == true &&
                    i.kategori == "fastfood") ||
                (filterItemValueList["fDeniz"] == true &&
                    i.kategori == "deniz")) ||
            kateSecilmis == false) {
          return true;
        } else {
          return false;
        }
      }).where((i) {
        if (((filterItemValueList["fVejetaryen"] == true &&
                    i.vejetaryen == 2) ||
                (filterItemValueList["fVegan"] == true && i.vejetaryen == 3)) ||
            VVSecilmis == false) {
          return true;
        } else {
          return false;
        }
      }).where((i) {
        if ((sureSecilmis == true &&
                ((int.parse(i.hazirlamasuresimin.toString()) +
                        int.parse(i.pisirmesuresimin.toString())) <=
                    int.parse(filterItemValueList["fSure"]))) ||
            sureSecilmis == false) {
          return true;
        } else {
          return false;
        }
      }).toList();

      if (filterItemValueList["fSirala"] != "Seçiniz") {
        if (filterItemValueList["fSirala"] == "Yapılış süresi (Az)") {
          _filteredTarifList.sort((a, b) =>
              (int.parse(a.hazirlamasuresimin.toString()) +
                      int.parse(a.hazirlamasuresimax.toString()))
                  .compareTo(int.parse(b.hazirlamasuresimin.toString()) +
                      int.parse(b.hazirlamasuresimax.toString())));
        } else if (filterItemValueList["fSirala"] == "Yapılış süresi (Çok)") {
          _filteredTarifList.sort((a, b) =>
              (int.parse(b.hazirlamasuresimin.toString()) +
                      int.parse(b.hazirlamasuresimax.toString()))
                  .compareTo(int.parse(a.hazirlamasuresimin.toString()) +
                      int.parse(a.hazirlamasuresimax.toString())));
        } else if (filterItemValueList["fSirala"] == "Beğeni sayısı (Çok)") {
          _filteredTarifList.sort((a, b) => int.parse(b.begenisayisi.toString())
              .compareTo(int.parse(a.begenisayisi.toString())));
        } else if (filterItemValueList["fSirala"] == "Beğeni sayısı (Az)") {
          _filteredTarifList.sort((a, b) => int.parse(a.begenisayisi.toString())
              .compareTo(int.parse(b.begenisayisi.toString())));
        }
      }
      filtered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.kategori != null) {
      String k = widget.kategori!;
      if (k == "evyemekleri") {
        filterItemValueList["fEvyemek"] = true;
      } else if (k == "tatlilar") {
        filterItemValueList["fTatli"] = true;
      } else if (k == "corbalar") {
        filterItemValueList["fCorba"] = true;
      } else if (k == "pideler") {
        filterItemValueList["fPide"] = true;
      } else if (k == "deniz") {
        filterItemValueList["fDeniz"] = true;
      } else if (k == "firin") {
        filterItemValueList["fFirin"] = true;
      } else if (k == "fastfood") {
        filterItemValueList["fFastfood"] = true;
      }
      fetchWithFilter();
    }
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 14, top: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tarifler',
                    style: GoogleFonts.lobster(
                      color: Colors.indigo[800],
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _openFilters,
                  child: Text(
                    'Filtrele',
                    style: GoogleFonts.kalam(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.redAccent),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.only(left: 30, right: 30)),
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: filtered ? _filteredTarifList.length : _tariflist.length,
            itemBuilder: (ctxt, index) => filtered
                ? buildTarifList(ctxt, index, ptariflist: _filteredTarifList)
                : buildTarifList(ctxt, index, ptariflist: _tariflist),
          ),
        ],
      ),
    );
  }

  void _openFilters() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (context) {
          void kateSelected({required String katename}) {
            filterItemValueList[katename] == false
                ? filterItemValueList[katename] = true
                : filterItemValueList[katename] = false;
          }

          void vejetaryenSelected(bool newVal, StateSetter setFilterState) {
            setFilterState(() {
              filterItemValueList["fVegan"] = false;
              filterItemValueList["fVejetaryen"] = newVal;
            });
          }

          void veganSelected(bool newVal, StateSetter setFilterState) {
            setFilterState(() {
              filterItemValueList["fVejetaryen"] = false;
              filterItemValueList["fVegan"] = newVal;
            });
          }

          void clearFilter() {
            setState(() {
              filtered = false;
              _filteredTarifList.clear();
              filterItemValueList = {
                "fSure": 'Seçiniz',
                "fSirala": 'Seçiniz',
                "fVejetaryen": false,
                "fVegan": false,
                "fEvyemek": false,
                "fPide": false,
                "fCorba": false,
                "fTatli": false,
                "fFirin": false,
                "fFastfood": false,
                "fDeniz": false
              };
            });
          }

          /*
          'Yapılış süresi (Az)',
          'Yapılış süresi (Çok)',
          'Beğeni sayısı (Çok)',
          'Beğeni sayısı (Az)',
          */

          /*
          Map<String, int> _filterSurelerList = {
            '30 dakika': 1,
            '45 dakika': 2,
            '60 dakika': 3,
            '1.5 saat': 4,
            '2 saat': 5,
            '3 saat': 6,
            '4 saat': 7
          };
          */
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setFilterState) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.grey[200],
              ),
              child: ListView(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 12, left: 12, bottom: 6),
                    child: Text(
                      "Kategoriler",
                      style: GoogleFonts.courgette(
                        fontSize: 26,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12.0, top: 4, bottom: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: -2,
                          blurRadius: 3,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Wrap(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setFilterState(() {
                              kateSelected(katename: 'fEvyemek');
                            });
                          },
                          label: Text('Ev yemekleri',
                              style: GoogleFonts.kalam(
                                color: Colors.white,
                              )),
                          style: ButtonStyle(
                            backgroundColor: filterItemValueList["fEvyemek"] ==
                                    false
                                ? MaterialStateProperty.all(
                                    const Color.fromARGB(255, 121, 165, 204))
                                : MaterialStateProperty.all(Colors.green),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.only(left: 12, right: 12)),
                          ),
                          icon: filterItemValueList["fEvyemek"] == false
                              ? const Icon(Icons.add, color: Colors.white)
                              : const Icon(Icons.remove, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            setFilterState(() {
                              kateSelected(katename: 'fPide');
                            });
                          },
                          label: Text('Pideler',
                              style: GoogleFonts.kalam(
                                color: Colors.white,
                              )),
                          style: ButtonStyle(
                            backgroundColor: filterItemValueList["fPide"] ==
                                    false
                                ? MaterialStateProperty.all(
                                    const Color.fromARGB(255, 121, 165, 204))
                                : MaterialStateProperty.all(Colors.green),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.only(left: 12, right: 12)),
                          ),
                          icon: filterItemValueList["fPide"] == false
                              ? const Icon(Icons.add, color: Colors.white)
                              : const Icon(Icons.remove, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            setFilterState(() {
                              kateSelected(katename: 'fCorba');
                            });
                          },
                          label: Text('Çorbalar',
                              style: GoogleFonts.kalam(
                                color: Colors.white,
                              )),
                          style: ButtonStyle(
                            backgroundColor: filterItemValueList["fCorba"] ==
                                    false
                                ? MaterialStateProperty.all(
                                    const Color.fromARGB(255, 121, 165, 204))
                                : MaterialStateProperty.all(Colors.green),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.only(left: 12, right: 12)),
                          ),
                          icon: filterItemValueList["fCorba"] == false
                              ? const Icon(Icons.add, color: Colors.white)
                              : const Icon(Icons.remove, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            setFilterState(() {
                              kateSelected(katename: 'fTatli');
                            });
                          },
                          label: Text('Tatlılar',
                              style: GoogleFonts.kalam(
                                color: Colors.white,
                              )),
                          style: ButtonStyle(
                            backgroundColor: filterItemValueList["fTatli"] ==
                                    false
                                ? MaterialStateProperty.all(
                                    const Color.fromARGB(255, 121, 165, 204))
                                : MaterialStateProperty.all(Colors.green),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.only(left: 12, right: 12)),
                          ),
                          icon: filterItemValueList["fTatli"] == false
                              ? const Icon(Icons.add, color: Colors.white)
                              : const Icon(Icons.remove, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            setFilterState(() {
                              kateSelected(katename: 'fFirin');
                            });
                          },
                          label: Text('Fırın ürünleri',
                              style: GoogleFonts.kalam(
                                color: Colors.white,
                              )),
                          style: ButtonStyle(
                            backgroundColor: filterItemValueList["fFirin"] ==
                                    false
                                ? MaterialStateProperty.all(
                                    const Color.fromARGB(255, 121, 165, 204))
                                : MaterialStateProperty.all(Colors.green),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.only(left: 12, right: 12)),
                          ),
                          icon: filterItemValueList["fFirin"] == false
                              ? const Icon(Icons.add, color: Colors.white)
                              : const Icon(Icons.remove, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            setFilterState(() {
                              kateSelected(katename: 'fFastfood');
                            });
                          },
                          label: Text('Fast-Food',
                              style: GoogleFonts.kalam(
                                color: Colors.white,
                              )),
                          style: ButtonStyle(
                            backgroundColor: filterItemValueList["fFastfood"] ==
                                    false
                                ? MaterialStateProperty.all(
                                    const Color.fromARGB(255, 121, 165, 204))
                                : MaterialStateProperty.all(Colors.green),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.only(left: 12, right: 12)),
                          ),
                          icon: filterItemValueList["fFastfood"] == false
                              ? const Icon(Icons.add, color: Colors.white)
                              : const Icon(Icons.remove, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            setFilterState(() {
                              kateSelected(katename: 'fDeniz');
                            });
                          },
                          label: Text('Deniz ürünleri',
                              style: GoogleFonts.kalam(
                                color: Colors.white,
                              )),
                          style: ButtonStyle(
                            backgroundColor: filterItemValueList["fDeniz"] ==
                                    false
                                ? MaterialStateProperty.all(
                                    const Color.fromARGB(255, 121, 165, 204))
                                : MaterialStateProperty.all(Colors.green),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.only(left: 12, right: 12)),
                          ),
                          icon: filterItemValueList["fDeniz"] == false
                              ? const Icon(Icons.add, color: Colors.white)
                              : const Icon(Icons.remove, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  //---------------------------
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 12, left: 12, bottom: 6),
                    child: Text(
                      "Maximum süre",
                      style: GoogleFonts.courgette(
                        fontSize: 26,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: -2,
                          blurRadius: 3,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1,
                            color: Colors.grey[400]!,
                            style: BorderStyle.solid),
                      ),
                      child: DropdownButton<String>(
                        items: <String>[
                          'Seçiniz',
                          '30',
                          '45',
                          '60',
                          '90',
                          '120',
                          '180',
                          '240'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            //child: Text(value),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(value),
                            ),
                          );
                        }).toList(),
                        value: filterItemValueList["fSure"],
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onChanged: (String? secilenSure) {
                          setFilterState(() {
                            filterItemValueList["fSure"] = secilenSure!;
                          });
                        },
                      ),
                    ),
                  ),
                  //---------------------------
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 12, left: 12, bottom: 6),
                    child: Text(
                      "Sıralama",
                      style: GoogleFonts.courgette(
                        fontSize: 26,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: -2,
                          blurRadius: 3,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 1,
                              color: Colors.grey[400]!,
                              style: BorderStyle.solid)),
                      child: DropdownButton<String>(
                        items: <String>[
                          'Seçiniz',
                          'Yapılış süresi (Az)',
                          'Yapılış süresi (Çok)',
                          'Beğeni sayısı (Çok)',
                          'Beğeni sayısı (Az)',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            //child: Text(value),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(value),
                            ),
                          );
                        }).toList(),
                        value: filterItemValueList["fSirala"],
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onChanged: (String? secilenSirala) {
                          setFilterState(() {
                            filterItemValueList["fSirala"] = secilenSirala!;
                          });
                        },
                      ),
                    ),
                  ),
                  //--------------------------
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 12, left: 12, bottom: 6),
                    child: Text(
                      "Özel seçimler",
                      style: GoogleFonts.courgette(
                        fontSize: 26,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: -2,
                          blurRadius: 3,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Sadece Vejetaryen:',
                              style: GoogleFonts.kalam(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Transform.scale(
                              scale: 1.3,
                              child: Switch(
                                value: filterItemValueList["fVejetaryen"]!,
                                onChanged: (newVal) {
                                  vejetaryenSelected(newVal, setFilterState);
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Sadece Vegan:',
                              style: GoogleFonts.kalam(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Transform.scale(
                              scale: 1.3,
                              child: Switch(
                                value: filterItemValueList["fVegan"]!,
                                onChanged: (newVal) {
                                  veganSelected(newVal, setFilterState);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //---------------------------
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setFilterState(() {
                              widget.kategori = null;
                              clearFilter();
                            });
                          },
                          child: Text(
                            "Sıfırla",
                            style: GoogleFonts.courgette(
                              fontSize: 26,
                              color: Colors.white,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 196, 50, 40)),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.only(
                                    left: 50, right: 50, top: 6, bottom: 6)),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            fetchWithFilter();
                          },
                          child: Text(
                            "Ara",
                            style: GoogleFonts.courgette(
                              fontSize: 26,
                              color: Colors.white,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 60, 72, 178)),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.only(
                                    left: 50, right: 50, top: 6, bottom: 6)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //------------------------------
                ],
              ),
            );
            //-----------
          });

          //--------------------------------
        });
  }
}
