import 'package:provider/single_child_widget.dart';
import 'package:auto_forward_sms/provider/connectivity_provider.dart';
import 'package:provider/provider.dart';

List<SingleChildWidget> providers = [
  //...independentServices,
  //...dependentServices,
  ...uiConsumableProviders,
];

List<SingleChildWidget> uiConsumableProviders = [
  ChangeNotifierProvider(create: (_) => ConnectivityProvider())
];
