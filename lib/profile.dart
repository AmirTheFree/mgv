// In the name of Allah

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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

  final infoStyle = TextStyle(
    fontSize: 15,
  );
  final linkStyle = TextStyle(
    fontSize: 15,
    color: Colors.blue,
  );
  final titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );

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
                String email = '❌';
                try {
                  email = data['emails'][0]['value'];
                } catch (e) {}
                String website = '❌';
                try {
                  website = data['urls'][0]['value'];
                } catch (e) {}
                String phone = '❌';
                try {
                  phone = data['phoneNumbers'][0]['value'];
                } catch (e) {}
                var twitter;
                try {
                  for (var account in data['accounts']) {
                    if (account['shortname'] == 'twitter') {
                      twitter = account;
                    }
                  }
                } catch (e) {
                  twitter = {'display': null, 'url': ''};
                }
                var currency = {'type': '', 'value': '❌'};
                try {
                  currency = data['currency'][0];
                  currency['type'] = data['currency'][0]['type'] + ': ';
                } catch (e) {}
                profileURL = data['profileUrl'];
                Map<String, String> name = {
                  'formatted': '❌',
                  'givenName': '❌',
                  'familyName': '❌'
                };
                name.forEach((key, value) {
                  try {
                    name[key] = data['name'][key];
                  } catch (e) {}
                });
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
                                data['displayName'] ?? '❌',
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
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: Text(
                                    data['aboutMe'] ?? '❌',
                                    style: TextStyle(fontSize: 16),
                                  ),
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
                      Row(
                        children: [
                          Icon(Icons.location_pin),
                          Text(
                            'Location: ',
                            style: titleStyle,
                          ),
                          Text(
                            data['currentLocation'] ?? '❌',
                            style: infoStyle,
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          children: [
                            Icon(Icons.person),
                            Text(
                              'Full name: ',
                              style: titleStyle,
                            ),
                            Text(
                              name['formatted']!,
                              style: infoStyle,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          children: [
                            Icon(Icons.email),
                            Text(
                              'Email: ',
                              style: titleStyle,
                            ),
                            InkWell(
                              child: Text(
                                email,
                                style: linkStyle,
                              ),
                              onTap: () => launchURL('mailto:' + email),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          children: [
                            Icon(Icons.phone),
                            Text(
                              'Phone: ',
                              style: titleStyle,
                            ),
                            InkWell(
                              child: Text(
                                phone,
                                style: linkStyle,
                              ),
                              onTap: () => launchURL('tel:' + phone),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          children: [
                            Icon(Icons.chat),
                            Text(
                              'Twitter: ',
                              style: titleStyle,
                            ),
                            InkWell(
                              child: Text(
                                twitter['display'] ?? '❌',
                                style: linkStyle,
                              ),
                              onTap: () => launchURL(twitter['url'] ?? '❌'),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          children: [
                            Icon(Icons.link),
                            Text(
                              'Website: ',
                              style: titleStyle,
                            ),
                            InkWell(
                              child: Text(
                                website,
                                style: linkStyle,
                              ),
                              onTap: () => launchURL(website),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          children: [
                            Icon(Icons.attach_money),
                            Text(
                              currency['type'] ?? '❌',
                              style: titleStyle,
                            ),
                            Text(
                              currency['value'] ?? '❌',
                              style: infoStyle,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          children: [
                            Icon(Icons.perm_identity_outlined),
                            Text(
                              'First name: ',
                              style: titleStyle,
                            ),
                            Text(
                              name['givenName']!,
                              style: infoStyle,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          children: [
                            Icon(Icons.perm_identity_outlined),
                            Text(
                              'Last name: ',
                              style: titleStyle,
                            ),
                            Text(
                              name['familyName']!,
                              style: infoStyle,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: GridView.count(
                            crossAxisCount: 4,
                            children: List.generate(
                              data['photos'].length,
                              (int index) =>
                                  Image.network(data['photos'][index]['value']),
                            ),
                          ),
                        ),
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
