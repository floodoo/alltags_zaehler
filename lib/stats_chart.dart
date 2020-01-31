import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:alltags_zaehler/save_sql.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class KategorieBarChart extends StatelessWidget {
  static const secondaryMeasureAxisId = 'secondaryMeasureAxisId';

  @override
  Widget build(BuildContext context) {
    final saveSql = Provider.of<SaveSql>(context);

    // For horizontal bar charts, set the [vertical] flag to false.
    return new charts.BarChart(
      saveSql.chartBars,
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
      vertical: false,
      // It is important when using both primary and secondary axes to choose
      // the same number of ticks for both sides to get the gridlines to line
      // up.
      primaryMeasureAxis:
          new charts.NumericAxisSpec(tickProviderSpec: new charts.BasicNumericTickProviderSpec(desiredTickCount: 3)),
      secondaryMeasureAxis:
          new charts.NumericAxisSpec(tickProviderSpec: new charts.BasicNumericTickProviderSpec(desiredTickCount: 3)),
    );
  }
}
