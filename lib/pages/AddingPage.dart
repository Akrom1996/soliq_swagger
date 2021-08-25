import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String? code, name, group;
  String jwt =
      "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxNUM4MDVFRkIzODE0NzI2QUM5RjU5Q0YyRjlGRTQwNSIsImV4cCI6MTYyOTg3MjAzOCwiaWF0IjoxNjI5ODU0MDM4fQ.72kW1tPR_yNBoREcowKkwpGhewsMaQyl3qpgamQn07VU3D66cZNvibkXKak9rFSrdCXa6791CV5q90BUWCpYNg";
  String uri = "https://api-tasnif.soliq.uz/cl-api/company-products/add";

  Future addNewItem() async {
    var response = await http.post(Uri.parse(uri + "/$code"),
        headers: {"Authorization": jwt},
        body: jsonEncode({"className": name, "subPositionName": group}));
    if (response.statusCode == 200) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Maxsulot qo'shildi"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context, 200);
                      },
                      child: Text("OK"))
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Maxsulot qo'shishda xatolik sodir bo'ldi"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("OK"))
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[200],
        elevation: 0,
        title: Text(
          "Yangi maxsulot qo'shish",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 70,
            ),
            TextContainer(
              icon: Icons.code_sharp,
              hint: "Code",
              change: (txt) {
                setState(() {
                  code = txt;
                });
              },
            ),
            TextContainer(
              icon: Icons.ac_unit,
              hint: "Maxsulot nomi",
              change: (txt) {
                setState(() {
                  name = txt;
                });
              },
            ),
            TextContainer(
              icon: Icons.group,
              hint: "Guruhi",
              change: (txt) {
                setState(() {
                  group = txt;
                });
              },
            ),
            Spacer(),
            SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  child: Icon(Icons.add),
                  onPressed: () async {
                    await addNewItem();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TextContainer extends StatelessWidget {
  final String? hint;
  final IconData? icon;
  final ValueChanged change;
  const TextContainer({
    Key? key,
    required this.hint,
    required this.icon,
    required this.change,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 30,
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: TextField(
        onChanged: change,
        cursorColor: Colors.teal[300],
        style: TextStyle(
            color: Colors.teal,
            letterSpacing: 1.1,
            fontSize: 16,
            fontWeight: FontWeight.w400),
        // controller: textEditingController,
        decoration: InputDecoration(
            prefixIcon: icon == null
                ? null
                : Icon(
                    icon,
                    color: Colors.teal[300],
                  ),
            hintText: "$hint",
            hintStyle: TextStyle(color: Colors.teal[300]),
            hoverColor: Colors.teal[300],
            contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal[300]!),
                borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
