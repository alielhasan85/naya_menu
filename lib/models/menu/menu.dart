import 'package:naya_menu/models/section/section.dart';

class MenuModel {
  final String menuId;
  final String venueId; // Association with VenueModel
  final String menuName;
  final String description; // Optional description of the menu
  final List<MenuSection> sections;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive; // To indicate if the menu is currently active
  final Map<String, dynamic>? settings; // Any additional settings

  MenuModel({
    required this.menuId,
    required this.venueId,
    required this.menuName,
    this.description = '',
    this.sections = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isActive = true,
    this.settings,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'menuId': menuId,
      'venueId': venueId,
      'menuName': menuName,
      'description': description,
      'sections': sections.map((section) => section.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'settings': settings,
    };
  }

  factory MenuModel.fromMap(Map<String, dynamic> map, String menuId) {
    return MenuModel(
      menuId: menuId,
      venueId: map['venueId'],
      menuName: map['menuName'],
      description: map['description'] ?? '',
      sections: (map['sections'] as List<dynamic>?)
              ?.map((sectionMap) =>
                  MenuSection.fromMap(Map<String, dynamic>.from(sectionMap)))
              .toList() ??
          [],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isActive: map['isActive'] ?? true,
      settings: map['settings'],
    );
  }

  MenuModel copyWith({
    String? menuId,
    String? venueId,
    String? menuName,
    String? description,
    List<MenuSection>? sections,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    Map<String, dynamic>? settings,
  }) {
    return MenuModel(
      menuId: menuId ?? this.menuId,
      venueId: venueId ?? this.venueId,
      menuName: menuName ?? this.menuName,
      description: description ?? this.description,
      sections: sections ?? this.sections,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      settings: settings ?? this.settings,
    );
  }
}
