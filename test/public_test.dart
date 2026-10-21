import 'package:dsc26_flt_w02/data/repositories/alert_repository.dart';
import 'package:dsc26_flt_w02/domain/models/stock_alert.dart';
import 'package:dsc26_flt_w02/main.dart';
import 'package:dsc26_flt_w02/ui/alerts/view_models/alerts_view_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

StockAlert alert(String id, Severity severity, double days,
        {String en = 'Medicine', String ar = 'دواء'}) =>
    StockAlert(
      id: id,
      medicineNameEn: en,
      medicineNameAr: ar,
      severity: severity,
      daysOfCover: days,
      branchCode: 'CAI-014',
    );

Map<String, Object?> json({Object? severity = 'CRITICAL'}) => {
      'id': 'a1',
      'medicineNameEn': 'Insulin glargine',
      'medicineNameAr': 'انسولين جلارجين',
      'severity': severity,
      'daysOfCover': 2,
      'branchCode': 'CAI-014',
    };

void main() {
  test('fromJson reads a valid alert and defaults acknowledged to false', () {
    final a = StockAlert.fromJson(json());
    expect(a.severity, Severity.critical);
    expect(a.daysOfCover, 2.0);
    expect(a.acknowledged, isFalse);
  });

  test('fromJson rejects an unknown severity with a FormatException', () {
    expect(() => StockAlert.fromJson(json(severity: 'urgent')),
        throwsFormatException);
  });

  test('visible alerts are sorted by severity, then days of cover', () async {
    final vm = AlertsViewModel(
      repository: InMemoryAlertRepository([
        alert('a', Severity.low, 1),
        alert('b', Severity.critical, 5),
        alert('c', Severity.critical, 2),
      ]),
    );
    await vm.load();
    expect(vm.visibleAlerts.map((a) => a.id), ['c', 'b', 'a']);
  });

  testWidgets('shows one row per alert and the count', (tester) async {
    await tester.pumpWidget(NourShelfApp(
      repository: InMemoryAlertRepository([
        alert('a', Severity.high, 3),
        alert('b', Severity.low, 20),
      ]),
    ));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('alert-a')), findsOneWidget);
    expect(find.byKey(const Key('alert-b')), findsOneWidget);
    expect(find.text('2 alerts'), findsOneWidget);
  });

  testWidgets('the critical filter hides other severities', (tester) async {
    await tester.pumpWidget(NourShelfApp(
      repository: InMemoryAlertRepository([
        alert('a', Severity.critical, 3),
        alert('b', Severity.low, 20),
      ]),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('filter-critical')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('alert-a')), findsOneWidget);
    expect(find.byKey(const Key('alert-b')), findsNothing);
  });
}
