// Flutter imports:
import 'package:auto_forward_sms/provider/connectivity_provider.dart';
import 'package:auto_forward_sms/ui/check_network/no_internert.dart';
import 'package:flutter/material.dart';

// Project imports:
// Package imports:
import 'package:provider/provider.dart';

class CheckNetwork extends StatelessWidget {
  final Widget child;

  const CheckNetwork({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOnline = Provider.of<ConnectivityProvider>(context).isOnline;
    // TODO: implement build

    return !isOnline ? const InternetConnectionCheck() : child;
  }
}
