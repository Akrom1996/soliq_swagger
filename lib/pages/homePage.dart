import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:soliq_swagger/pages/Products.dart';
import 'package:soliq_swagger/pages/cetificate.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  Color mainColor = Color(0xff325ECD);
  Color greyColor = Color(0xff8D959E);
  List<String> years = ["2021", "2020", "2019"];
  String jwt = "Bearer ";
  Future? myFuture;
  Future signIn() async {
    String uri = "https://api-tasnif.soliq.uz/cl-api/e-imzo";
    var response = await http.post(Uri.parse(uri), headers: {
      "Content-Type": "application/json"
    }, body: {
      "certificateId": "string",
      "orgTin": "string",
      "signData": cert,
      "viaDirectorKey": 0
    });
    if (response.statusCode == 200) {
      setState(() {
        jwt += jsonDecode(response.body)["data"]["jwtToken"];
      });
      return response;
    } else
      return Future.error("error");
  }

  Future loadData() async {
    String uri = "https://api-tasnif.soliq.uz/cl-api/mxik/popular";
    var response = await http.get(
      Uri.parse(uri),
      headers: {"Authorization": jwt},
    );
    // print("jwt: $jwt");
    if (response.statusCode == 200) {
      // print("load data 200");
      // print("data: ${json.decode(utf8.decode(response.bodyBytes))['data']}");
      var input = json.decode(utf8.decode(response.bodyBytes))["data"];
      // print("length: ${input.map((data) => Products.fromJson(data)).toList()}");
      return input.map((data) => Products.fromJson(data)).toList();
    } else if (response.statusCode == 401) {
      // print("load data 401");
      var res = await signIn();
      if (res.statusCode == 200) {
        await loadData();
      } else {
        return Future.error("error");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    myFuture = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: Icon(
          Icons.arrow_back_sharp,
          color: mainColor,
        ),
        centerTitle: true,
        elevation: 0,
        title: Column(
          children: [
            Text("My mxik code",
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    fontSize: 12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "806 600 000",
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: mainColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 2,
                ),
                Text('сӯм',
                    style: GoogleFonts.ptSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: mainColor))
              ],
            )
          ],
        ),
      ),
      body: FutureBuilder(
        future: myFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            return Stack(
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 0),
                      height: 40,
                      // width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 36,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: ListView.builder(
                              itemCount: 3,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(right: 30),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        currentIndex = index;
                                      });
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${years[index]}",
                                          style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: currentIndex == index
                                                  ? mainColor
                                                  : greyColor),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 12, bottom: 0),
                                          height: currentIndex == index ? 2 : 0,
                                          width: 66,
                                          color: mainColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                          )
                        ],
                      ),
                    ),

                    Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                height: 214,
                                width: double.infinity,
                                margin: EdgeInsets.fromLTRB(16, 21, 16, 16),
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${snapshot.data[index].groupName}",
                                      //"ГУП Государственный центр экспертизы и стандартизации лекарственных средств",
                                      style: GoogleFonts.ptSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    MyRow(
                                      text1:
                                          "${snapshot.data[index].className}", //"Начисленная зарплата",
                                      text2: "999 157 894.00",
                                      text3: "сӯм",
                                    ),
                                    MyRow(
                                      text1:
                                          "${snapshot.data[index].positionName}", //"Налог на доходы (НДФЛ 12%)",
                                      text2: "888 613 789.39",
                                      text3: "сӯм",
                                    ),
                                    MyRow(
                                      text1:
                                          "${snapshot.data[index].subPositionName}", //"Отработанных месяцев",
                                      text2: "2",
                                      text3: "",
                                    ),
                                    MyRow(
                                      text1:
                                          "Сумма", //"Сумма на пенсионный счет (ИНПС)",
                                      text2:
                                          "${snapshot.data[index].unitCode}", //"613 789.39",
                                      text3:
                                          "${snapshot.data[index].unitName}", //"сӯм",
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 1,
                                      color: Colors.grey.withOpacity(0.4),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.calendar_view_week,
                                          color: mainColor,
                                          size: 13.3,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Показать по месяцам",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Spacer(),
                                        SvgPicture.asset(
                                          "assets/images/image.svg",
                                          color: mainColor,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          "Скачать",
                                          style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }))
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(13),
                    //   ),
                    //   height: 214,
                    //   width: double.infinity,
                    //   margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    //   padding:
                    //       EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         "ГУП Государственный центр экспертизы и стандартизации лекарственных средств",
                    //         style: GoogleFonts.ptSans(
                    //             fontSize: 14, fontWeight: FontWeight.w700),
                    //       ),
                    //       MyRow(
                    //         text1: "Начисленная зарплата",
                    //         text2: "999 157 894.00",
                    //         text3: "сӯм",
                    //       ),
                    //       MyRow(
                    //         text1: "Налог на доходы (НДФЛ 12%)",
                    //         text2: "888 613 789.39",
                    //         text3: "сӯм",
                    //       ),
                    //       MyRow(
                    //         text1: "Отработанных месяцев",
                    //         text2: "2",
                    //         text3: "",
                    //       ),
                    //       MyRow(
                    //         text1: "Сумма на пенсионный счет (ИНПС)",
                    //         text2: "613 789.39",
                    //         text3: "сӯм",
                    //       ),
                    //       Container(
                    //         width: double.infinity,
                    //         height: 1,
                    //         color: Colors.grey.withOpacity(0.4),
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         children: [
                    //           Icon(
                    //             Icons.calendar_view_week,
                    //             color: mainColor,
                    //             size: 13.3,
                    //           ),
                    //           SizedBox(
                    //             width: 8,
                    //           ),
                    //           Text(
                    //             "Показать по месяцам",
                    //             style: GoogleFonts.montserrat(
                    //               fontSize: 12,
                    //               fontWeight: FontWeight.w400,
                    //             ),
                    //           ),
                    //           Spacer(),
                    //           SvgPicture.asset(
                    //             "assets/images/image.svg",
                    //             color: mainColor,
                    //           ),
                    //           SizedBox(
                    //             width: 2,
                    //           ),
                    //           Text(
                    //             "Скачать",
                    //             style: GoogleFonts.montserrat(
                    //                 fontSize: 12, fontWeight: FontWeight.w400),
                    //           )
                    //         ],
                    //       )
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: mainColor),
                        child: Icon(
                          Icons.filter_alt_outlined,
                          color: Colors.white,
                        )
                        // SvgPicture.asset(
                        //   "assets/images/image2.svg",
                        //   color: Colors.white,
                        //   width: 2,
                        //   height: 2,
                        // ),
                        ),
                  ),
                )
              ],
            );
          }
          return Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class MyRow extends StatelessWidget {
  final text1;
  final text2;
  final text3;
  const MyRow({
    Key? key,
    required this.text1,
    required this.text2,
    required this.text3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Text(
            "$text1",
            style: GoogleFonts.ptSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              // height: 16,
            ),
          ),
        ),
        Spacer(),
        Text(
          "$text2",
          style: GoogleFonts.ptSans(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        text3 == ""
            ? SizedBox.shrink()
            : SizedBox(
                width: 4,
              ),
        Text(
          "$text3",
          style: GoogleFonts.ptSans(fontSize: 12, fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}
