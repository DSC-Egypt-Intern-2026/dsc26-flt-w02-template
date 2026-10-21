import 'package:flutter/material.dart';

import 'data/repositories/alert_repository.dart';
import 'domain/models/stock_alert.dart';

void main() {
  runApp(NourShelfApp(repository: InMemoryAlertRepository(demoAlerts)));
}

/// A few alerts for running the app by hand (`flutter run`).
const List<StockAlert> demoAlerts = [
  StockAlert(
    id: 'insulin',
    medicineNameEn: 'Insulin glargine',
    medicineNameAr: 'انسولين جلارجين',
    severity: Severity.critical,
    daysOfCover: 2,
    branchCode: 'CAI-014',
  ),
  StockAlert(
    id: 'levo',
    medicineNameEn: 'Levothyroxine 50 mcg',
    medicineNameAr: 'ليفوثيروكسين ٥٠ ميكروجرام',
    severity: Severity.high,
    daysOfCover: 6,
    branchCode: 'CAI-014',
  ),
  StockAlert(
    id: 'amox',
    medicineNameEn: 'Amoxicillin syrup',
    medicineNameAr: 'شراب أموكسيسيلين',
    severity: Severity.medium,
    daysOfCover: 9,
    branchCode: 'CAI-014',
  ),
  StockAlert(
    id: 'vitd',
    medicineNameEn: 'Vitamin D3 drops',
    medicineNameAr: 'نقط فيتامين د',
    severity: Severity.low,
    daysOfCover: 30,
    branchCode: 'CAI-014',
  ),
];

/// The app root.
///
/// TODO(W2): keep this constructor. Create the AlertsViewModel here (once),
/// call load(), show AlertsScreen, and dispose the view model when this
/// widget goes away. It probably needs to become a StatefulWidget.
class NourShelfApp extends StatelessWidget {
  const NourShelfApp({super.key, required this.repository});

  final AlertRepository repository;

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('TODO: NourShelfApp'))),
    );
  }
}
