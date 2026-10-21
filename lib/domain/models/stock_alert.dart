/// How urgent a stock alert is. The order of the values is the display order:
/// critical first, low last.
enum Severity { critical, high, medium, low }

/// One stock alert for one branch, as sent by Nour head office.
///
/// Immutable: a change creates a new object through [copyWith].
/// Do not change the constructor, the fields or the method signatures.
final class StockAlert {
  const StockAlert({
    required this.id,
    required this.medicineNameEn,
    required this.medicineNameAr,
    required this.severity,
    required this.daysOfCover,
    required this.branchCode,
    this.acknowledged = false,
  });

  final String id;
  final String medicineNameEn;
  final String medicineNameAr;
  final Severity severity;
  final double daysOfCover;
  final String branchCode;
  final bool acknowledged;

  /// Reads one alert from the head-office JSON feed.
  ///
  /// TODO(W2): validate every field as the README says. Any invalid input
  /// throws a FormatException, never a TypeError.
  factory StockAlert.fromJson(Map<String, Object?> json) {
    throw UnimplementedError('StockAlert.fromJson');
  }

  /// TODO(W2): return a new StockAlert with the given fields replaced.
  StockAlert copyWith({
    String? id,
    String? medicineNameEn,
    String? medicineNameAr,
    Severity? severity,
    double? daysOfCover,
    String? branchCode,
    bool? acknowledged,
  }) {
    throw UnimplementedError('StockAlert.copyWith');
  }

  /// TODO(W2): value equality over all seven fields.
  @override
  bool operator ==(Object other) {
    throw UnimplementedError('StockAlert.==');
  }

  /// TODO(W2): consistent with ==.
  @override
  int get hashCode => throw UnimplementedError('StockAlert.hashCode');
}
