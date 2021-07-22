// In the name of Allah

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mgv/main.dart';
import 'package:url_launcher/url_launcher.dart';

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class Data {
  final Map<String, dynamic> information;

  Data({required this.information});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(information: json['entry'][0]);
  }
}

Future<Data> fetchData({required String userID}) async {
  final response =
      await http.get(Uri.parse('http://gravatar.com/' + userID + '.json'));
  if (response.statusCode == 200) {
    return Data.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Failed to load information');
  }
}

class Profile extends StatefulWidget {
  final id;

  Profile({Key? key, @required this.id}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<Data> dataFuture;
  String profileURL = 'http://gravatar.com/mwxgaf';
  @override
  void initState() {
    super.initState();
    dataFuture = fetchData(userID: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile | MWX Gravatar Viewer',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gravatar profile'),
        ),
        body: Center(
          child: FutureBuilder<Data>(
            future: dataFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!.information;
                profileURL = data['profileUrl'];
                print(data);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['displayName'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                              Text(
                                '@' + data['requestHash'],
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 15,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  data['aboutMe'],
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Image.network(
                            data['thumbnailUrl'],
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.black54,
                        height: 20,
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: EdgeInsets.all(50),
                  child: Text(
                    "${snapshot.error}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => launchURL(this.profileURL),
          child: Icon(Icons.open_in_browser),
        ),
      ),
    );
  }
}
