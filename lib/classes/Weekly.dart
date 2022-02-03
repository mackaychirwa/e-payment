class Week {
  final int saleVal;
  final String saleWeek;
  final String colorVal;
  Week(this.saleVal, this.saleWeek, this.colorVal);

  Week.fromMap(Map<String, dynamic> map)
      : assert(map['saleVal'] != null),
        assert(map['saleWeek'] != null),
        assert(map['colorVal'] != null),
        saleVal = map['saleVal'],
        colorVal = map['colorVal'],
        saleWeek = map['saleWeek'];

  @override
  String toString() => "Record<$saleVal:$saleWeek:$colorVal>";
}
