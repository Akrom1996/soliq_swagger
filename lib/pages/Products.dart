// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);

import 'dart:convert';

Products productsFromJson(String str) => Products.fromJson(json.decode(str));

String productsToJson(Products data) => json.encode(data.toJson());

class Products {
  Products({
    this.pkey,
    this.tin,
    this.mxikCode,
    this.groupName,
    this.className,
    this.positionName,
    this.subPositionName,
    this.brandName,
    this.attributeName,
    this.internationalCode,
    this.unitCode,
    this.unitName,
    this.unitValue,
    this.isActive,
    this.createdAt,
  });

  String? pkey;
  String? tin;
  String? mxikCode;
  String? groupName;
  String? className;
  String? positionName;
  String? subPositionName;
  dynamic brandName;
  dynamic attributeName;
  dynamic internationalCode;
  int? unitCode;
  String? unitName;
  String? unitValue;
  int? isActive;
  String? createdAt;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        pkey: json["pkey"],
        tin: json["tin"],
        mxikCode: json["mxikCode"],
        groupName: json["groupName"],
        className: json["className"],
        positionName: json["positionName"],
        subPositionName: json["subPositionName"],
        brandName: json["brandName"],
        attributeName: json["attributeName"],
        internationalCode: json["internationalCode"],
        unitCode: json["unitCode"],
        unitName: json["unitName"],
        unitValue: json["unitValue"],
        isActive: json["isActive"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "pkey": pkey,
        "tin": tin,
        "mxikCode": mxikCode,
        "groupName": groupName,
        "className": className,
        "positionName": positionName,
        "subPositionName": subPositionName,
        "brandName": brandName,
        "attributeName": attributeName,
        "internationalCode": internationalCode,
        "unitCode": unitCode,
        "unitName": unitName,
        "unitValue": unitValue,
        "isActive": isActive,
        "createdAt": createdAt,
      };
}
