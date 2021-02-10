import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseblog/authpage.dart';
import 'package:firebaseblog/mainpage.dart';
import 'package:firebaseblog/profileview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanici Profili"),
        backgroundColor: Colors.blueGrey[600],
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((deger) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => AuthPage()),
                      (Route<dynamic> route) => false);
                });
              }),
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((deger) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => MainPage()),
                      (Route<dynamic> route) => true);
                });
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey[600],
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => ProfileView()),
              (Route<dynamic> route) => true);
        },
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                //Expanded(
                //child:
                ProfileDesign(),
                // ),
              ],
            ),
            Expanded(
              child: SizedBox(
                child: UniqueUserInformation(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UniqueUserInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth kullanici = FirebaseAuth.instance;
    Query users = FirebaseFirestore.instance
        .collection('Yazilar')
        .where('kullaniciID', isEqualTo: kullanici.currentUser.uid);
    if (users == null) {
      return ProfilePage();
    } else {
      return StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return new ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return new ListTile(
                title: new Text(document.data()['baslik']),
                subtitle: new Text(document.data()['icerik']),
              );
            }).toList(),
          );
        },
      );
    }
  }
}

class ProfileDesign extends StatefulWidget {
  @override
  _ProfileDesignState createState() => _ProfileDesignState();
}

class _ProfileDesignState extends State<ProfileDesign> {
  File yuklenecekDosya;
  FirebaseAuth auth = FirebaseAuth.instance;
  var indirmeBaglantisi;
  final picker = ImagePicker();

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => baglantiAl());
  }

  baglantiAl() async {
    final String baglanti = await FirebaseStorage.instance
        .ref()
        .child("profilresimleri")
        .child(auth.currentUser.uid)
        .child("profilresmi.jpg")
        .getDownloadURL();

    setState(() {
      indirmeBaglantisi = baglanti;
    });
  }

  kameradanYukle() async {
    var alinanDosya = await picker.getImage(source: ImageSource.camera);
    setState(() {
      yuklenecekDosya = File(alinanDosya.path);
    });

    final Reference referansYol = FirebaseStorage.instance
        .ref()
        .child("profilresimleri")
        .child(auth.currentUser.uid);

    UploadTask yuklemeGorevi =
        referansYol.child("profilresmi.jpg").putFile(yuklenecekDosya);
    var url = await (await yuklemeGorevi).ref.getDownloadURL();

    setState(() {
      indirmeBaglantisi = url.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          ClipOval(
            child: indirmeBaglantisi == null
                ? Text('Resim yok')
                : Image.network(
                    indirmeBaglantisi,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
          ),
          SizedBox(width: 20.0),
          RaisedButton(
              onPressed: kameradanYukle,
              child: Text('Resim Yukle'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.black)),
              color: Colors.blueGrey[200])
        ],
      ),
    );
  }
}
