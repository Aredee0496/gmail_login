import 'package:flutter/material.dart';

class Group {
  final String id;
  final String name;
  final bool hasNotification;

  Group({
    required this.id,
    required this.name,
    required this.hasNotification,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      hasNotification: json['hasNotification'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hasNotification': hasNotification,
    };
  }

  Group copyWith({bool? hasNotification}) {
    return Group(
      id: id,
      name: name,
      hasNotification: hasNotification ?? this.hasNotification,
    );
  }
}

class GroupProvider with ChangeNotifier {
  List<Group> _groups = [];
  List<Group> get groups => _groups;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setGroups(List<Group> groups) {
    _groups = groups;
    _isLoading = false;
    notifyListeners();
  }

  void updateNotification(List<String> groupNames) {
    for (var i = 0; i < _groups.length; i++) {
      if (groupNames.contains(_groups[i].name)) {
        _groups[i] = _groups[i].copyWith(hasNotification: true);
      }
    }
    notifyListeners();
  }

  void removeGroup(String groupId) {
    _groups.removeWhere((group) => group.id == groupId);
    notifyListeners();
  }
}