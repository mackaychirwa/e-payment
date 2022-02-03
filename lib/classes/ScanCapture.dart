class ScanResult {
  final String location;
  final int amount;
  final String user;

  ScanResult({this.location, this.amount, this.user});
  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
        location: json['location'], amount: json['amount'], user: json['user']);
  }
}
