import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class GroupButtonsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> groupList;
  final Set<String> selectedGroups;
  final Set<String> notificationGroups;
  final bool selectMode;
  final bool deleteMode;
  final Function(String) onGroupSelect;
  final Function(String) onGroupDelete;
  final Function(String) onSendSelectedGroups;

  const GroupButtonsWidget({
    required this.groupList,
    required this.selectedGroups,
    required this.notificationGroups,
    required this.selectMode,
    required this.deleteMode,
    required this.onGroupSelect,
    required this.onGroupDelete,
    required this.onSendSelectedGroups,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Text(
            "Groups",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Wrap(
            spacing: 15,
            runSpacing: 15,
            children: groupList.map((group) {
              String groupName = group["name"]!;
              bool isSelected = selectedGroups.contains(groupName);

              return GestureDetector(
                onTap: () => onGroupSelect(groupName),
                child: AnimatedContainer(
                  width: 150,
                  height: 180,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      )
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Center(
                        child: FittedBox(
                          child: Text(
                            groupName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                              fontSize: 30,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      if (deleteMode)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MaterialButton(
                              onPressed: () => onGroupDelete(group["id"]),
                              color: Colors.red,
                              textColor: Colors.white,
                              minWidth: double.infinity,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "ลบ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (selectMode)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MaterialButton(
                              onPressed: () => onSendSelectedGroups(groupName),
                              color: isSelected ? Colors.green : Colors.grey,
                              textColor: Colors.white,
                              minWidth: double.infinity,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isSelected ? "เลือกแล้ว" : "เลือก",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (group["hasNotification"] == true)
                        Positioned(
                          right: -5,
                          top: -5, 
                          child: badges.Badge(
                            badgeStyle: const badges.BadgeStyle(
                              badgeColor: Colors.red,
                              padding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
