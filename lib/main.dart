import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'album_model.dart';

Future fetchAlbum() async {
  final response =
  await http.get('https://jsonplaceholder.typicode.com/albums');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    //return Album.fromJson(jsonDecode(response.body));
    return response.body;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<Album> deleteAlbum(String id) async {
  final http.Response response = await http.delete(
    'https://jsonplaceholder.typicode.com/albums/$id',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {

    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to delete album.');
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  Future _album;
  @override
  void initState() {
    _album = fetchAlbum();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delete Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Delete Data Example'),
        ),
        body: Center(
          child: FutureBuilder(
            future: _album,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List list = jsonDecode(snapshot.data);
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index){
                      Album album = Album.fromJson(list.elementAt(index));
                      return Card(
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 6
                            ),
                          child: ListTile(
                            title: Text(album.title),
                            subtitle: Text(album.id.toString()),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: (){
                                setState(() {
                                  deleteAlbum(index.toString());
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}