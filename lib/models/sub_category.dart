// lib/models/sub_category.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class SubCategory {
  final String id;
  final String name;
  final int parentId;
  final String? image;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int sortOrder;
  final Map<String, dynamic>? metadata;

  SubCategory({
    required this.id,
    required this.name,
    required this.parentId,
    this.image,
    this.description,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.sortOrder = 0,
    this.metadata,
  });

  factory SubCategory.fromMap(Map<String, dynamic> map) {
    return SubCategory(
      id: map['id'],
      name: map['name'],
      parentId: map['parentId'],
      image: map['image'],
      description: map['description'],
      isActive: map['isActive'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: map['updatedAt'] != null ? (map['updatedAt'] as Timestamp).toDate() : null,
      sortOrder: map['sortOrder'] ?? 0,
      metadata: map['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'parentId': parentId,
      'image': image,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'sortOrder': sortOrder,
      'metadata': metadata,
    };
  }
}
