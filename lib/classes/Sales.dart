class Sales {
  final int saleVal;
  final String saleYear;
  final String colorVal;
  Sales(this.saleVal, this.saleYear, this.colorVal);

  Sales.fromMap(Map<String, dynamic> map)
      : assert(map['saleVal'] != null),
        assert(map['saleYear'] != null),
        assert(map['colorVal'] != null),
        saleVal = map['saleVal'],
        colorVal = map['colorVal'],
        saleYear = map['saleYear'];

  @override
  String toString() => "Record<$saleVal:$saleYear:$colorVal>";
}

class Month {
  final int saleVal;
  final String saleMonth;
  final String colorVal;
  Month(this.saleVal, this.saleMonth, this.colorVal);

  Month.fromMap(Map<String, dynamic> map)
      : assert(map['saleVal'] != null),
        assert(map['saleMonth'] != null),
        assert(map['colorVal'] != null),
        saleVal = map['saleVal'],
        colorVal = map['colorVal'],
        saleMonth = map['saleMonth'];

  @override
  String toString() => "Record<$saleVal:$saleMonth:$colorVal>";
}
