// In the name of Allah

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';

class Profile extends StatefulWidget {
  final id;

  Profile({Key? key, @required this.id}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    void getData() async {
      Response response = await get(
          Uri.parse('https://en.gravatar.com/' + widget.id + '.json'));
      this.data = json.decode(utf8.decode(response.bodyBytes));
    }

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile | MWX Gravatar Viewer',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile | MGV'),
        ),
        body: Center(
          child: Column(
            children: [
              Text(data['entry'][0]['name']['familyName']),
            ],
          ),
        ),
      ),
    );
  }
}
