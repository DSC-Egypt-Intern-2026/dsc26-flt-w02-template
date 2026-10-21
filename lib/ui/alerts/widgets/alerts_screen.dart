import 'package:flutter/material.dart';

import '../view_models/alerts_view_model.dart';

/// The branch alerts screen.
///
/// TODO(W2): show what the view model exposes (loading indicator, search
/// field, severity filters, count, list or empty state) using the keys in the
/// README, and forward taps to the view model. No business rules here.
class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key, required this.viewModel});

  final AlertsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Branch alerts')),
      body: const Center(child: Text('TODO: build the alerts screen')),
    );
  }
}
