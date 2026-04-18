import 'package:leyu_mobile/features/auth/data/models/dialect.dart';


class DialectEntity {
  final String id;
  final String name;
  final String description;

  DialectEntity({
    required this.id,
    required this.name,
    required this.description,
  });

  static DialectEntity fromModel(Dialect dialect) {
    return DialectEntity(
      id: dialect.id,
      name: dialect.name,
      description: "No description available",
    );
  }

}