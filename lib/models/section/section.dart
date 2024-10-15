import 'package:naya_menu/models/item/item.dart';

class MenuSection {
  final String sectionId;
  final String sectionName;
  final List<MenuItem> items;

  MenuSection({
    required this.sectionId,
    required this.sectionName,
    this.items = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'sectionId': sectionId,
      'sectionName': sectionName,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  factory MenuSection.fromMap(Map<String, dynamic> map) {
    return MenuSection(
      sectionId: map['sectionId'],
      sectionName: map['sectionName'],
      items: (map['items'] as List<dynamic>?)
              ?.map((itemMap) =>
                  MenuItem.fromMap(Map<String, dynamic>.from(itemMap)))
              .toList() ??
          [],
    );
  }

  MenuSection copyWith({
    String? sectionId,
    String? sectionName,
    List<MenuItem>? items,
  }) {
    return MenuSection(
      sectionId: sectionId ?? this.sectionId,
      sectionName: sectionName ?? this.sectionName,
      items: items ?? this.items,
    );
  }
}
