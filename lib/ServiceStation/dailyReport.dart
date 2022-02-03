import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:total_load_up/classes/Day.dart';

class Daily extends StatefulWidget {
  @override
  _DailyState createState() {
    return _DailyState();
  }
}

class _DailyState extends State<Daily> {
  List<charts.Series<Day, String>> _seriesBarData;
  List<Day> mydata;
  _generateData(mydata) {
    _seriesBarData = List<charts.Series<Day, String>>();
    _seriesBarData.add(
      charts.Series(
        domainFn: (Day sales, _) => sales.saleDay.toString(),
        measureFn: (Day sales, _) => sales.money,
        colorFn: (Day sales, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(sales.colorVal))),
        id: 'Reports',
        data: mydata,
        labelAccessorFn: (Day row, _) => "${row.saleDay}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Daily Sales'),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Reports').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<Day> day = snapshot.data.docs
              .map((documentSnapshot) => Day.fromMap(documentSnapshot.data()))
              .toList();
          return _buildChart(context, day);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<Day> saledata) {
    mydata = saledata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Daily Sales',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.BarChart(
                  _seriesBarData,
                  animate: true,
                  animationDuration: Duration(seconds: 5),
                  behaviors: [
                    new charts.DatumLegend(
                      entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.purple.shadeDefault,
                          fontFamily: 'Georgia',
                          fontSize: 18),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
