import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/imageview.dart';

import 'data.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _keyword = '';
  Timer _debounce;
  List<Results> _data = [];

  onChangeText(text) {
    _keyword = text;
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () async {
      var data = await fetchData(_keyword);
      setState(() {
        _data = data.results;
      });
    });
  }

  Future<Data> fetchData(keyword) async {
    var url =
        'https://api.unsplash.com/search/photos?client_id=cf49c08b444ff4cb9e4d126b7e9f7513ba1ee58de7906e4360afc1a33d1bf4c0&page=1&query=$keyword';
    var responseApi = await http.get(url);
    if (responseApi.statusCode == 200) {
      var resJSON = json.decode(responseApi.body);
      var data = Data.fromJson(resJSON);
      return data;
    } else {
      print('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: TextField(
                textAlign: TextAlign.center,
                onChanged: onChangeText,
                decoration: InputDecoration(
                  hintText: 'Тапайте',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            _keyword.isNotEmpty
                ? Text(
                    'Картинки по запросу \"$_keyword\"',
                    style: TextStyle(fontSize: 20),
                  )
                : Text(
                    '',
                  ),
            Visibility(
              visible: _data.length > 0,
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ImageView(_data[index].urls.full))),
                              child: Column(
                                children: <Widget>[
                                  Image.network(_data[index].urls.small),
                                  Text(
                                    _data[index].user.name,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(_data[index].altDescription),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
