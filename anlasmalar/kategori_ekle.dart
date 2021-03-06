import 'dart:io';

import 'package:anlasmalar/servisler/fire_store_servisi.dart';
import 'package:anlasmalar/servisler/yetki_sayfasi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../main_inherited.dart';

class KategoriEkle extends StatefulWidget {
  final String kategoriAl;
  final String appBarAl;

  KategoriEkle({this.kategoriAl, this.appBarAl});
  @override
  _KategoriEkleState createState() => _KategoriEkleState();
}

class _KategoriEkleState extends State<KategoriEkle> {
  final db = FirebaseFirestore.instance;
  TextEditingController _indirimOrani = TextEditingController();
  TextEditingController _adres = TextEditingController();
  TextEditingController _telefon = TextEditingController();
  TextEditingController _aciklama = TextEditingController();
  //TextEditingController _enlem = TextEditingController();
  //TextEditingController _boylam = TextEditingController();
  TextEditingController _webAdresi = TextEditingController();
  TextEditingController _googleAdresi = TextEditingController();
  TextEditingController _firmaAdi = TextEditingController();
  //final String kategori="alisveris";
  final _formaAnahtari = GlobalKey<FormState>();
  //String numara = "";
  File dosya;
  String dosyaYolu;
  bool yukleniyor = false;

  @override
  Widget build(BuildContext context) {
    final _yetkiServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appBarAl + " Kategorisinde Ekleme",
        ),
        backgroundColor: Colors.indigo.shade900,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          sayfaElemanlari(),
          yuklemeAnimasyonu(),
        ],
      ),
    );
  }

  //*** SAYFA ELEMANLARI ***

  Widget sayfaElemanlari() {
    final bildirimServisi = MainInherited.of(context).bildirimServisi;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Form(
        key: _formaAnahtari,
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: ListView(
            children: [
              //*****************************************************************
              //***F??RMA ADI G??R??????
              TextFormField(
                controller: _firmaAdi,
                decoration: InputDecoration(
                  hintText: "Firma Ad?? Girin",
                  labelText: "Firma Ad??",
                  border: OutlineInputBorder(),
                ),
                validator: (girilenDeger) {
                  if (girilenDeger.isEmpty) {
                    return "Firma Ad?? Giriniz";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),

              //*****************************************************************
              // ??ND??R??M ORANI G??R??????
              TextFormField(
                controller: _indirimOrani,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "??ndirim Oran?? Girin",
                  labelText: "??ndirim Oran??",
                  border: OutlineInputBorder(),
                ),
                validator: (girilenDeger) {
                  if (girilenDeger.isEmpty) {
                    return "Oran Giriniz";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),

              //*****************************************************************
              // ADRES G??R??????
              TextFormField(
                controller: _adres,
                decoration: InputDecoration(
                  hintText: "Adres Bilgisini Girin",
                  labelText: "Adres Bilgisi",
                  border: OutlineInputBorder(),
                ),
                validator: (girilenDeger) {
                  if (girilenDeger.isEmpty) {
                    return "Adres Bilgisi Giriniz";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              //*****************************************************************
              // GOOGLE MAPS ADRES??
              TextFormField(
                controller: _googleAdresi,
                decoration: InputDecoration(
                  hintText: "Google Maps Adresini Girin",
                  labelText: "Google Maps Adresi",
                  border: OutlineInputBorder(),
                ),
                validator: (girilenDeger) {
                  if (girilenDeger.isEmpty) {
                    return "Google Maps Adresini Giriniz";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              //*****************************************************************
              //WEB S??TES??
              TextFormField(
                controller: _webAdresi,
                decoration: InputDecoration(
                  hintText: "Web Sitesini Girin",
                  labelText: "Web Sitesi",
                  border: OutlineInputBorder(),
                ),
                validator: (girilenDeger) {
                  if (girilenDeger.isEmpty) {
                    return null;
                  }
                  return null;
                },
              ),

              SizedBox(
                height: 15,
              ),

              //*****************************************************************
              // TELEFON G??R??????
              TextFormField(
                controller: _telefon,
                decoration: InputDecoration(
                  hintText: "Telefon Giriniz",
                  labelText: "Telefon Bilgisi",
                  border: OutlineInputBorder(),
                ),
                validator: (girilenDeger) {
                  if (girilenDeger.isEmpty) {
                    return "Telefon Giriniz";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 15,
              ),

              //*****************************************************************
              // A??IKLAMA G??R??????
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                controller: _aciklama,
                decoration: InputDecoration(
                  hintText: "A????klama Giriniz",
                  labelText: "A????klama",
                  border: OutlineInputBorder(),
                ),
                validator: (girilenDeger) {
                  if (girilenDeger.isEmpty) {
                    return "A????klama Giriniz";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),

              // FOTO??RAF SE????M ALANI
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: GestureDetector(
                        onTap: () {
                          fotografSec();
                        },
                        /*Foto??raf se??imi yap??ld??ysa g??r??necek k??s??m*/
                        child: dosya != null
                            ? Container(
                                height: MediaQuery.of(context).size.width / 3,
                                width: MediaQuery.of(context).size.width / 3,
                                child: Image.file(
                                  dosya,
                                  fit: BoxFit.cover,
                                ),
                              )
                            /*Foto??raf se??imi yap??lmadan ??nce g??r??necek k??s??m*/
                            : Container(
                                height: 200,
                                width: double.infinity,
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.black,
                                  size: 50,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),

              //*****************************************************************
              // KAYDET BUTONU
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(primary: Colors.indigo.shade900),
                  child: Text(
                    "Kaydet",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    final data = {
                      'title': "Yeni Anla??ma Eklendi",
                      'body':
                          "${widget.appBarAl} alan??nda ${_firmaAdi.text} firmas??yla yeni bir anla??ma yap??ld??",
                      'bildirim-tipi': "anlasma",
                      'kategori': widget.appBarAl,
                      'firmaAdi': _firmaAdi.text,
                      'coll-id': widget.kategoriAl,
                      'detay-id': _firmaAdi.text,
                    };

                    bildirimServisi.bildirimGonderEski(data);

                    if (_formaAnahtari.currentState.validate()) {
                      setState(() {
                        yukleniyor = true;
                        kayit();
                      });
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  //**************************************************************************
  //SNACKBAR ??LE KAYIT ????LEM??N?? TAMAMLAMA
  kayit() async {
    var sayi = await FireStoreSevisi().kategoriKayit(
        _firmaAdi,
        _indirimOrani,
        _adres,
        _webAdresi,
        _googleAdresi,
        _telefon,
        _aciklama,
        dosya,
        widget.kategoriAl,
        widget.appBarAl);
    setState(() {
      yukleniyor = false;
    });
    if (sayi != 0) {
      final snackBar = SnackBar(
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
        content: Text(
          "Kay??t ????lemi Tamamland??",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (sayi == 0) {
      final snackBar = SnackBar(
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
        content: Text(
          "Bu isimde ??irket mevcut ",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
        content: Text(
          "Hata Olu??tu ",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  //**************************************************************************
  //*** FOTO??RAF SE????M?? ??????N D??ALOG PENCERES??N??N A??ILMASI ***
  fotografSec() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("G??nderi Olu??tur"),
          children: [
            SimpleDialogOption(
              child: Text("Foto??raf ??ek"),
              onPressed: () {
                fotoCek();
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Text("Galeriden Y??kle"),
              onPressed: () {
                galeridenSec();
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Text("??ptal"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  //**************************************************************************
  //*** KAMERA KULLANARAK FOTO??RAF ??EKME ***
  fotoCek() async {
    //Foto??raf ??ek se??ene??ine t??kland??????nda dialog penceresinin kapanmas??n?? sa??lar

    /* ImageSource.camera: Foto??raf??n kamera ??ekimiyle gelece??ini belirtir.
    maxWidth: Foto??raf??n maksimum geni??li??i
    maxHeight: Foto??raf??n maksimum boyu
    imageQualityFoto??raf??n kalitesi(0-100 aras?? de??er al??r.
    de??er y??kseldik??e foto??raf kalitesi artar)
    */
    var image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 80);

    setState(() {
      dosya = File(image.path);
    });
  }

  //**************************************************************************
  //*** GALER??DEN FOTO??RAF SE??ME ***
  galeridenSec() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);

    setState(() {
      dosya = File(image.path);
    });
  }

  //**************************************************************************
  // *** Y??KLEME AN??MASYONU ***
  Widget yuklemeAnimasyonu() {
    if (yukleniyor) {
      return Center(
          child: CircularProgressIndicator(
        backgroundColor: Colors.blue,
      ));
    } else {
      return SizedBox(
        height: 0,
      );
    }
  }
}
