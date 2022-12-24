import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ProfileScreen/UsersProfile.dart';

class SearchBar extends StatefulWidget {
  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController search = TextEditingController();
  List<Users> _listUsers = [];
  List<Users> _searchSearch = [];
  List<TextSnap> _listText = [];

  @override
  initState() {
    _searchSearch = _listUsers;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUsersList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(5),
                prefixIcon: Icon(Icons.search),
                suffix: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: null,
                ),
                hintText: 'Searching...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
          child: ListView.builder(
        itemCount: _searchSearch.length,
        itemBuilder: (context, index) {
          return Container(
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UsersProfile(
                  name: _searchSearch[index].title.toString(),
                ),
              )),
              child: Card(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(_searchSearch[index].title.toString()),
                  )),
            ),
          );
        },
      )),
    );
  }

  void _runFilter(String enteredKeyword) {
    List<Users> results = [];

    List<TextSnap> alltext = [];
    print(enteredKeyword);
    if (enteredKeyword.isEmpty) {
      results = _listUsers;
      alltext = _listText;
    } else {
      results = _listUsers
          .where((users) =>
              users.title != null &&
              users.title!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      alltext = _listText
          .where((text) =>
              text.title != null &&
              text.title!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();

      setState(() {
        _searchSearch = results;
      });
    }
  }

  Future getUsersList() async {
    var data = await FirebaseFirestore.instance
        .collection('Users')
        .where('Username')
        .get();
    var text = await FirebaseFirestore.instance
        .collection('Texts')
        .where('Title')
        .get();

    setState(() {
      _listUsers = List.from(
        data.docs.map(
          ((doc) => Users.fromSnapshot(doc)),
        ),
      );
    });
  }
}

class Users {
  String? title;
  String? id;

  Users();

  Map<String, dynamic> toJson() => {
        'Username': title,
        'id': id,
      };

  Users.fromSnapshot(snapshot)
      : title = snapshot.data()['Username'],
        id = snapshot.id;
}

class TextSnap {
  String? title;
  String? id;

  TextSnap();

  Map<String, dynamic> toJson() => {
        'Title': title,
        'id': id,
      };

  TextSnap.fromSnapshot(snapshot)
      : title = snapshot.data()['Title'],
        id = snapshot.id;
}

class AllData {
  Users? id;
  TextSnap? tid;
  AllData();

  Map<String, dynamic> toJson() => {
        'id': id,
        'tid': tid,
      };

  AllData.fromSnapshot(snapshot)
      : id = snapshot.id,
        tid = snapshot.id;
}
