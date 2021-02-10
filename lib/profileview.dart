import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  var gelenYaziBasligi = "";
  var gelenYaziIcerigi = "";

  FirebaseAuth auth = FirebaseAuth.instance;

  yaziEkle() {
    FirebaseFirestore.instance.collection("Yazilar").doc(t1.text).set({
      'kullaniciID': auth.currentUser.uid,
      'baslik': t1.text,
      'icerik': t2.text
    }).whenComplete(() => print("Yazı eklendi"));
  }

  yaziGuncelle() {
    FirebaseFirestore.instance.collection("Yazilar").doc(t1.text).update({
      'kullaniciID': auth.currentUser.uid,
      'baslik': t1.text,
      'icerik': t2.text
    }).whenComplete(() => print("Yazı güncellendi"));
  }

  yaziSil() {
    FirebaseFirestore.instance.collection("Yazilar").doc(t1.text).delete();
  }

  yaziGetir() {
    FirebaseFirestore.instance
        .collection("Yazilar")
        .doc(t1.text)
        .get()
        .then((gelenVeri) {
      setState(() {
        gelenYaziBasligi = gelenVeri.data()['baslik'];
        gelenYaziIcerigi = gelenVeri.data()['icerik'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Kullanici Yazi Islemleri"),
          backgroundColor: Colors.blueGrey[600],
        ),
        body: myBody());
  }

  Widget myBody() {
    return Container(
      margin: EdgeInsets.all(28),
      child: Center(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  fillColor: Colors.white54,
                  filled: true,
                  hintText: "Baslik",
                  border: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(10.0)))),
              controller: t1,
            ),
            TextFormField(
              decoration: InputDecoration(
                  fillColor: Colors.white54,
                  filled: true,
                  hintText: "Icerik",
                  border: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(10.0)))),
              controller: t2,
            ),
            Row(
              children: [
                RaisedButton(
                    child: Text("Ekle"),
                    onPressed: yaziEkle,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.black)),
                    color: Colors.blueGrey[200]),
                RaisedButton(
                    child: Text("Güncelle"),
                    onPressed: yaziGuncelle,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.black)),
                    color: Colors.blueGrey[200]),
                RaisedButton(
                    child: Text("Sil"),
                    onPressed: yaziSil,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.black)),
                    color: Colors.blueGrey[200]),
                RaisedButton(
                    child: Text("Getir"),
                    onPressed: yaziGetir,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.black)),
                    color: Colors.blueGrey[200]),
              ],
            ),
            ListTile(
              title: Text(gelenYaziBasligi),
              subtitle: Text(gelenYaziIcerigi),
            ),
          ],
        ),
      ),
    );
  }
}
