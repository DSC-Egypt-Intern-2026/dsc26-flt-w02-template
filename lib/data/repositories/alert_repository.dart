import '../../domain/models/stock_alert.dart';

/// The source of truth for stock alerts.
///
/// Do not change this interface: the tests (public and hidden) pass their own
/// implementations of it to `NourShelfApp` and `AlertsViewModel`.
abstract class AlertRepository {
  Future<List<StockAlert>> fetchAlerts();

  Future<void> acknowledge(String alertId);
}

/// A repository that keeps alerts in memory. Used by the demo app and tests.
class InMemoryAlertRepository implements AlertRepository {
  InMemoryAlertRepository(List<StockAlert> alerts) : _alerts = List.of(alerts);

  final List<StockAlert> _alerts;

  /// Every id passed to [acknowledge], in call order.
  final List<String> acknowledgedIds = <String>[];

  @override
  Future<List<StockAlert>> fetchAlerts() async => List.of(_alerts);

  @override
  Future<void> acknowledge(String alertId) async {
    acknowledgedIds.add(alertId);
  }
}
