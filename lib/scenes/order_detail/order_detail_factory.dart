import 'package:flutter/widgets.dart';

import '../../app/app_controller.dart';
import '../../shared/scene_host.dart';
import 'order_detail_view.dart';
import 'order_detail_view_model.dart';
import 'order_detail_coordinator.dart';
import 'server_order_detail.dart';

abstract final class OrderDetailFactory {
  static Widget make(
    AppController app, {
    Map<String, dynamic> args = const {},
  }) => SceneAssembly(
    builder: (context) => OrderDetailView(
      viewModel: OrderDetailViewModel(
        server: CoreServerOrderDetail(app.repository),
        coordinator: DefaultOrderDetailCoordinator(context, app),
        args: args,
      )..initialize(),
    ),
  );
}
