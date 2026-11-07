import 'package:flutter/widgets.dart';

import '../../app/app_controller.dart';
import '../../shared/scene_host.dart';
import 'orders_view.dart';
import 'orders_view_model.dart';
import 'orders_coordinator.dart';
import 'server_orders.dart';

abstract final class OrdersFactory {
  static Widget make(
    AppController app, {
    Map<String, dynamic> args = const {},
  }) => SceneAssembly(
    builder: (context) => OrdersView(
      viewModel: OrdersViewModel(
        server: CoreServerOrders(app.repository),
        coordinator: DefaultOrdersCoordinator(context, app),
        args: args,
      )..initialize(),
    ),
  );
}
