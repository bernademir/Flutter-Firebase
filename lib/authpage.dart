import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseblog/profilepage.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  Future<void> kaydol() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: t1.text, password: t2.text)
        .then((kullanici) {
      FirebaseFirestore.instance
          .collection("Kullanicilar")
          .doc(t1.text)
          .set({"KullaniciEposta": t1.text, "KullaniciSifre": t2.text});
    });
  }

  Future<void> giris() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: t1.text, password: t2.text)
        .then((kullanici) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => ProfilePage()),
          (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanici Giris Simulasyonu"),
        backgroundColor: Colors.blueGrey[600],
      ),
      body: myBody(),
    );
  }

  Widget myBody() {
    return Container(
      margin: EdgeInsets.all(30),
      child: Center(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  fillColor: Colors.white54,
                  filled: true,
                  hintText: "Kullanici Adi",
                  border: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(10.0)))),
              controller: t1,
            ),
            SizedBox(
              height: 5.0,
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                  fillColor: Colors.white54,
                  filled: true,
                  hintText: "Sifre",
                  border: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(10.0)))),
              controller: t2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.black)),
                    child: Text("Giris Yap"),
                    onPressed: giris,
                    color: Colors.blueGrey[200]),
                SizedBox(
                  width: 15.0,
                ),
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.black)),
                    child: Text("Kaydol"),
                    onPressed: kaydol,
                    color: Colors.blueGrey[200]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
