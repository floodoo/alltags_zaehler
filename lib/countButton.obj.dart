import 'package:json_annotation/json_annotation.dart';
import 'package:pref_dessert/pref_dessert_internal.dart';

part 'countButton.obj.g.dart';

@JsonSerializable()
class CountButtonObj {
  String name;
  String message;
  String icon;
  int color;

  CountButtonObj(this.name, this.message, this.icon, this.color);
}

class CountButtonDesSer extends JsonDesSer<CountButtonObj> {
  @override
  String get key => "PREF_BUTTON";

  @override
  CountButtonObj fromMap(Map<String, dynamic> map) =>
      _$CountButtonObjFromJson(map);

  @override
  Map<String, dynamic> toMap(CountButtonObj countButton) =>
      _$CountButtonObjToJson(countButton);
}
