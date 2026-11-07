import 'package:flutter/widgets.dart';

import '../../app/app_controller.dart';
import '../../shared/scene_host.dart';
import 'order_form_view.dart';
import 'order_form_view_model.dart';
import 'order_form_coordinator.dart';
import 'server_order_form.dart';

abstract final class OrderFormFactory {
  static Widget make(
    AppController app, {
    Map<String, dynamic> args = const {},
  }) => SceneAssembly(
    builder: (context) => OrderFormView(
      viewModel: OrderFormViewModel(
        server: CoreServerOrderForm(app.repository),
        coordinator: DefaultOrderFormCoordinator(context, app),
        args: args,
      )..initialize(),
    ),
  );
}
