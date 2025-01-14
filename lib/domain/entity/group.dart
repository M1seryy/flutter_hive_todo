import 'package:hive/hive.dart';

part 'group.g.dart';

@HiveType(typeId: 1)
class Group extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  Group({required this.name});
}
