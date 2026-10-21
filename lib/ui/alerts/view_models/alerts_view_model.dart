import 'package:flutter/foundation.dart';

import '../../../data/repositories/alert_repository.dart';
import '../../../domain/models/stock_alert.dart';

/// Turns the alerts from [AlertRepository] into what the alerts screen shows.
///
/// Keep these public signatures exactly: the hidden tests call them.
/// Add private fields and helpers as you need.
class AlertsViewModel extends ChangeNotifier {
  AlertsViewModel({required AlertRepository repository})
      : _repository = repository;

  // ignore: unused_field
  final AlertRepository _repository;

  /// True while [load] is in progress.
  bool get loading => throw UnimplementedError('loading');

  /// Fetches the alerts from the repository.
  Future<void> load() async {
    throw UnimplementedError('load');
  }

  /// Unmodifiable; filtered by severity and search query, then sorted.
  List<StockAlert> get visibleAlerts =>
      throw UnimplementedError('visibleAlerts');

  /// The severities currently shown. Empty means "show all".
  Set<Severity> get activeFilters => throw UnimplementedError('activeFilters');

  void toggleFilter(Severity severity) {
    throw UnimplementedError('toggleFilter');
  }

  void setQuery(String query) {
    throw UnimplementedError('setQuery');
  }

  Future<void> acknowledge(String id) async {
    throw UnimplementedError('acknowledge');
  }

  /// Unacknowledged critical alerts among ALL loaded alerts, whatever the
  /// current filters and search query.
  int get unacknowledgedCriticalCount =>
      throw UnimplementedError('unacknowledgedCriticalCount');
}
