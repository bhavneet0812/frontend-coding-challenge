import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final int id;
  final int userId;
  final int crewId;
  final String name;
  final String? image;

  const Member({
    required this.id,
    required this.userId,
    required this.crewId,
    required this.name,
    this.image,
  });

  @override
  List<Object?> get props => [id];

  /// Creates a copy of the Member instance with optional new values.
  /// If a value is not provided, the original value is retained.
  Member copyWith({
    int? id,
    int? userId,
    int? crewId,
    String? name,
    String? image,
  }) => Member(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    crewId: crewId ?? this.crewId,
    name: name ?? this.name,
    image: image ?? this.image,
  );

  /// Creates a Member instance from a JSON map.
  static Member fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      userId: json['userId'],
      crewId: json['crewId'],
      name: json['name'],
      image: json['image'],
    );
  }

  /// Converts the Member instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'crewId': crewId,
      'name': name,
      'image': image,
    };
  }
}
