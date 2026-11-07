import 'package:flutter/widgets.dart';

import '../../app/app_controller.dart';
import '../../shared/scene_host.dart';
import 'order_review_view.dart';
import 'order_review_view_model.dart';
import 'order_review_coordinator.dart';
import 'server_order_review.dart';

abstract final class OrderReviewFactory {
  static Widget make(
    AppController app, {
    Map<String, dynamic> args = const {},
  }) => SceneAssembly(
    builder: (context) => OrderReviewView(
      viewModel: OrderReviewViewModel(
        server: CoreServerOrderReview(app.repository),
        coordinator: DefaultOrderReviewCoordinator(context, app),
        args: args,
      )..initialize(),
    ),
  );
}
