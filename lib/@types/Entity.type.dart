import 'package:hive/hive.dart';

part 'Entity.type.g.dart';

@HiveType(typeId: 0)
class Entity extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String code;

  @HiveField(2)
  late String type;

  @HiveField(3)
  late String issuer;

  @HiveField(4, defaultValue: null)
  late int? count;

  @HiveField(5, defaultValue: '')
  late String lastHOTPCode;
}
