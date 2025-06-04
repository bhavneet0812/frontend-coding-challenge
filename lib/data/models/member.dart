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
}
