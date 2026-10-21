/// Wraps Nour head office's alert feed (a REST API).
///
/// Not used in the W2 task. It is here to make the layering rule concrete:
/// only the data layer talks to the network, and nothing under `lib/ui/`
/// may import this file. A real repository would call this service and turn
/// its JSON into `StockAlert` objects with `StockAlert.fromJson`.
class AlertsApiService {
  const AlertsApiService();

  Future<List<Map<String, Object?>>> fetchAlertsJson(String branchCode) {
    throw UnimplementedError('AlertsApiService is not used in W2');
  }
}
