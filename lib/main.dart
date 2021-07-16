// In the name of Allah

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TextEditingController queryController = new TextEditingController();
  void _search(String text) {
    print(text);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MWX Gravatar Viewer',
      home: Scaffold(
        appBar: AppBar(
          title: Text('MWX Gravatar Viewer'),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  onSubmitted: _search,
                  controller: queryController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Gravatar ID',
                    hintText: 'Enter Gravatar ID Here ...',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _search(queryController.text),
                child: Icon(
                  Icons.search,
                  size: 30,
                ),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(150, 50)),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ElevatedButton(
                            onPressed: () =>
                                _launchURL('https://mwxgaf.github.io/mgv'),
                            child: Text(
                              'About App',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.purple),
                              fixedSize:
                                  MaterialStateProperty.all(Size(100, 50)),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _launchURL('http://mwxgaf.ir/'),
                          child: Text(
                            'About Developer',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.pink),
                            fixedSize: MaterialStateProperty.all(Size(100, 50)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
