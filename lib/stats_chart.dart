import 'package:alltags_zaehler/model/zaehler.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleTimeSeriesChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      defaultRenderer: charts.LineRendererConfig(),
    );
  }

  static List<charts.Series<Zaehler, DateTime>> createData(List<Zaehler> data) {
    return [
      new charts.Series<Zaehler, DateTime>(
        id: 'Zähler',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Zaehler zaehler, _) => zaehler.zeitstempel,
        measureFn: (Zaehler zaehler, _) => zaehler.zahl,
        data: data,
      )
    ];
  }
}
