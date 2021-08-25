import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:soliq_swagger/pages/AddingPage.dart';
import 'package:soliq_swagger/pages/DetailPage.dart';
import 'package:soliq_swagger/pages/Products.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Products>? data1;
  TextEditingController? textEditingController;
  String jwt =
      "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxNUM4MDVFRkIzODE0NzI2QUM5RjU5Q0YyRjlGRTQwNSIsImV4cCI6MTYyOTg3MjAzOCwiaWF0IjoxNjI5ODU0MDM4fQ.72kW1tPR_yNBoREcowKkwpGhewsMaQyl3qpgamQn07VU3D66cZNvibkXKak9rFSrdCXa6791CV5q90BUWCpYNg";
  String uri = "https://api-tasnif.soliq.uz/cl-api/company-products/by-params";

  Future loadData() async {
    // print("loading");
    var response = await http.get(
      Uri.parse(uri),
      headers: {
        "Authorization": jwt,
      },
    );
    var resData = json.decode(utf8.decode(response.bodyBytes))['data'];
    var data1 = resData.map((data) => Products.fromJson(data)).toList();
    // print(data1);
    return data1;
  }

  Future filterDataByName(String name) async {
    var response = await http.get(
      Uri.parse(uri),
      headers: {"Authorization": jwt, 'Content-Type': 'application/json'},
    );
    var resData = json.decode(utf8.decode(response.bodyBytes))['data'];
    // print(resData);
    var data1 = resData.map((data) => Products.fromJson(data)).toList();
    // print("start ${data1.length}");
    List<Products> data2 = [];
    print(data1.map((e) {
      // print(name);
      if (e.className.toString().toLowerCase().contains(name)) {
        // print(e.className);
        data2.add(e);
      }
    }));

    // data2 = data1
    //     .where((element) => element.className.toString().contains(name))
    //     .toList();
    // print("data2: $data2");
    return data2;
  }

  Future? myFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFuture = loadData();
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[200],
        elevation: 0,
        title: Text(
          "Soliq.uz",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              // height: 30,
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: TextField(
                onChanged: (txt) {
                  setState(() {
                    myFuture = txt == "" ? loadData() : filterDataByName(txt);
                  });
                },
                cursorColor: Colors.teal[300],
                style: TextStyle(
                    color: Colors.teal,
                    letterSpacing: 1.1,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                // controller: textEditingController,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search_sharp,
                      color: Colors.teal[300],
                    ),
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.teal[300]),
                    hoverColor: Colors.teal[300],
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal[300]!),
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Expanded(
                child: FutureBuilder(
              future: myFuture,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  var data = snapshot.data;
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: InkWell(
                              onTap: () async {
                                var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailPage(product: data[index]),
                                  ),
                                );
                                if (result == 200)
                                  setState(() {
                                    myFuture = loadData();
                                  });
                              },
                              child: ListTile(
                                title: Text(
                                  "${data[index].className}",
                                ),
                                subtitle: Text("${data[index].createdAt}"),
                                trailing: Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          );
                        }),
                  );
                }
                return Center(
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddItem(),
            ),
          );
          if (result == 200)
            setState(() {
              myFuture = loadData();
            });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal[300],
      ),
    );
  }
}
