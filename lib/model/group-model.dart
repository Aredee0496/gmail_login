// To parse this JSON data, do
//
//     final groupData = groupDataFromJson(jsonString);

import 'dart:convert';

GroupData groupDataFromJson(String str) => GroupData.fromJson(json.decode(str));

String groupDataToJson(GroupData data) => json.encode(data.toJson());

class GroupData {
    int code;
    String result;
    String message;
    Data data;

    GroupData({
        required this.code,
        required this.result,
        required this.message,
        required this.data,
    });

    factory GroupData.fromJson(Map<String, dynamic> json) => GroupData(
        code: json["code"],
        result: json["result"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "result": result,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    String accesstoken;
    String refreshtoken;
    bool admin;
    Group group;

    Data({
        required this.accesstoken,
        required this.refreshtoken,
        required this.admin,
        required this.group,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        accesstoken: json["accesstoken"],
        refreshtoken: json["refreshtoken"],
        admin: json["admin"],
        group: Group.fromJson(json["group"]),
    );

    Map<String, dynamic> toJson() => {
        "accesstoken": accesstoken,
        "refreshtoken": refreshtoken,
        "admin": admin,
        "group": group.toJson(),
    };
}

class Group {
    int count;
    List<GroupRow > rows;

    Group({
        required this.count,
        required this.rows,
    });

    factory Group.fromJson(Map<String, dynamic> json) => Group(
        count: json["count"],
        rows: List<GroupRow >.from(json["rows"].map((x) => GroupRow .fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
    };
}

class GroupRow  {
    String groupId;
    String groupName;
    int status;
    String? createdBy;
    String? updatedBy;
    dynamic deletedBy;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;

    GroupRow ({
        required this.groupId,
        required this.groupName,
        required this.status,
        required this.createdBy,
        required this.updatedBy,
        required this.deletedBy,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory GroupRow .fromJson(Map<String, dynamic> json) => GroupRow (
        groupId: json["GroupID"],
        groupName: json["GroupName"],
        status: json["Status"],
        createdBy: json["CreatedBy"],
        updatedBy: json["UpdatedBy"],
        deletedBy: json["DeletedBy"],
        createdAt: DateTime.parse(json["CreatedAt"]),
        updatedAt: DateTime.parse(json["UpdatedAt"]),
        deletedAt: json["DeletedAt"],
    );

    Map<String, dynamic> toJson() => {
        "GroupID": groupId,
        "GroupName": groupName,
        "Status": status,
        "CreatedBy": createdBy,
        "UpdatedBy": updatedBy,
        "DeletedBy": deletedBy,
        "CreatedAt": createdAt.toIso8601String(),
        "UpdatedAt": updatedAt.toIso8601String(),
        "DeletedAt": deletedAt,
    };
}
