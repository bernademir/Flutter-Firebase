import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tum Yazilar"),
        backgroundColor: Colors.blueGrey[600],
      ),
      body: AllUserInformation(),
    );
  }
}

class AllUserInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Yazilar');
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

// class VeriTablosu extends StatefulWidget {
//   @override
//   VeriTablosuState createState() => VeriTablosuState();
// }

// @override
// class VeriTablosuState extends State<VeriTablosu> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance.collection('Yazilar').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return new Text('Loading...');
//         return new DataTable(
//           columns: <DataColumn>[
//             new DataColumn(label: Text('Başlık')),
//             new DataColumn(label: Text('İçerik')),
//           ],
//           rows: _createRows(snapshot.data),
//         );
//       },
//     );
//   }

//   List<DataRow> _createRows(QuerySnapshot snapshot) {
//     List<DataRow> newList =
//         snapshot.docs.map((DocumentSnapshot documentSnapshot) {
//       return new DataRow(cells: [
//         DataCell(Text(documentSnapshot.data()['baslik'].toString())),
//         DataCell(Text(documentSnapshot.data()['icerik'].toString())),
//       ]);
//     }).toList();

//     return newList;
//   }
// }
