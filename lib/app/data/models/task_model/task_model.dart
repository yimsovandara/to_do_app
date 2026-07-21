import 'dart:convert';

enum TaskPriority { low, medium, high }

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final TaskPriority priority;
  final int isCompleted;
  final String? category;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.priority = TaskPriority.medium,
    this.isCompleted = 0,
    this.category,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a copy of this task with optional new values
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    int? isCompleted,
    String? category,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
/// Convert task to Map for SQLite database
Map<String, dynamic> toJson() {
  return {
    'id': id,
    'title': title,
    'description': description,
    'dueDate': dueDate?.toIso8601String(),
    'priority': priority.name,
    'isCompleted': isCompleted,
    'category': category,
    // Store tags as a JSON encoded String in SQLite
    'tags': jsonEncode(tags), 
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

/// Create task from SQLite Map
factory TaskModel.fromJson(Map<String, dynamic> json) {
  // Safe helper to parse SQLite tags column (handles String, List, or null/int)
  List<String> parseTags(dynamic tagsData) {
    if (tagsData == null) return [];
    
    // If it came back as a JSON String from SQLite
    if (tagsData is String) {
      try {
        final decoded = jsonDecode(tagsData);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {
        // Fallback if string isn't JSON (e.g., raw "tag1,tag2" or single "0")
        return [tagsData];
      }
    }
    
    // If it came back as a raw List
    if (tagsData is List) {
      return tagsData.map((e) => e.toString()).toList();
    }
    
    // Fallback for unexpected types (like a raw int)
    return [tagsData.toString()];
  }

  return TaskModel(
    id: json['id'].toString(),
    title: json['title'] as String,
    description: json['description'] as String?,
    dueDate: json['dueDate'] != null
        ? DateTime.parse(json['dueDate'].toString())
        : null,
    priority: TaskPriority.values.firstWhere(
      (e) => e.name == json['priority'],
      orElse: () => TaskPriority.medium,
    ),
    // SQLite stores int, but safely cast in case it arrives as bool or int
    isCompleted: json['isCompleted'] is int 
        ? json['isCompleted'] as int 
        : (json['isCompleted'] == true ? 1 : 0),
    category: json['category'] as String?,
    tags: parseTags(json['tags']),
    createdAt: DateTime.parse(json['createdAt'].toString()),
    updatedAt: DateTime.parse(json['updatedAt'].toString()),
  );
}

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, priority: $priority, isCompleted: $isCompleted, dueDate: $dueDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
