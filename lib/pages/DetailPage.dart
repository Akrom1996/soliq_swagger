import 'package:flutter/material.dart';
import 'package:soliq_swagger/pages/Products.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final Products product;
  const DetailPage({Key? key, required this.product}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Products? product;
  String jwt =
      "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxNUM4MDVFRkIzODE0NzI2QUM5RjU5Q0YyRjlGRTQwNSIsImV4cCI6MTYyOTg3MjAzOCwiaWF0IjoxNjI5ODU0MDM4fQ.72kW1tPR_yNBoREcowKkwpGhewsMaQyl3qpgamQn07VU3D66cZNvibkXKak9rFSrdCXa6791CV5q90BUWCpYNg";
  String uri = "https://api-tasnif.soliq.uz/cl-api/company-products/remove";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    product = widget.product;
  }

  Future deleteItem(var mixinCode) async {
    var response = await http.delete(Uri.parse(uri + "/$mixinCode"),
        headers: {"Authorization": jwt});
    if (response.statusCode == 200) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Maxsulot o'chirildi"),
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
                title: Text("Maxsulot o'chirishda xatolik sodir bo'ldi"),
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

  TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 17);
  TextStyle customStyle = TextStyle(fontSize: 15);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[200],
        elevation: 0,
        title: Text(
          "${product!.positionName}",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Card(
              child: Container(
                width: double.infinity,
                // height: 50,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Maxsulot kodi",
                      style: boldStyle,
                    ),
                    Text(
                      "${product!.mxikCode}",
                      style: customStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Guruh nomi",
                      style: boldStyle,
                    ),
                    Text("${product!.groupName}"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Turi",
                      style: boldStyle,
                    ),
                    Text("${product!.className}"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Nomi",
                      style: boldStyle,
                    ),
                    Text("${product!.subPositionName}"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Ishlab chiqarilgan sanasi",
                      style: boldStyle,
                    ),
                    Text("${product!.createdAt}"),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: double.infinity,
                  height: 60,
                  // decoration: BoxDecoration(
                  //     color: Colors.redAccent,
                  //     borderRadius: BorderRadius.circular(10)),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        elevation: 0,
                        shadowColor: Colors.transparent),
                    onPressed: () async {
                      await deleteItem(product!.mxikCode);
                    },
                    child: Icon(Icons.remove),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
