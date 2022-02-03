class Day {
  final int money;
  final String saleDay;
  final String colorVal;
  Day(this.money, this.saleDay, this.colorVal);

  Day.fromMap(Map<String, dynamic> map)
      : assert(map['money'] != null),
        assert(map['saleDay'] != null),
        assert(map['colorVal'] != null),
        money = map['money'],
        colorVal = map['colorVal'],
        saleDay = map['saleDay'];

  @override
  String toString() => "Record<$money:$saleDay:$colorVal>";
}
