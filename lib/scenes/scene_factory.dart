import 'package:flutter/widgets.dart';

import '../app/app_controller.dart';
import 'login/login_factory.dart';
import 'home/home_factory.dart';
import 'clients/clients_factory.dart';
import 'client_form/client_form_factory.dart';
import 'client_detail/client_detail_factory.dart';
import 'rep_folder/rep_folder_factory.dart';
import 'orders/orders_factory.dart';
import 'order_form/order_form_factory.dart';
import 'order_review/order_review_factory.dart';
import 'order_detail/order_detail_factory.dart';
import 'visits/visits_factory.dart';
import 'visit_form/visit_form_factory.dart';
import 'reps/reps_factory.dart';
import 'rep_detail/rep_detail_factory.dart';
import 'goals/goals_factory.dart';
import 'cities/cities_factory.dart';

abstract final class SceneFactory {
  static Widget make(
    String name,
    AppController app, {
    Map<String, dynamic> args = const {},
  }) => switch (name) {
    'login' => LoginFactory.make(app, args: args),
    'home' => HomeFactory.make(app, args: args),
    'clients' => ClientsFactory.make(app, args: args),
    'clientForm' => ClientFormFactory.make(app, args: args),
    'clientDetail' => ClientDetailFactory.make(app, args: args),
    'repFolder' => RepFolderFactory.make(app, args: args),
    'orders' => OrdersFactory.make(app, args: args),
    'orderForm' => OrderFormFactory.make(app, args: args),
    'orderReview' => OrderReviewFactory.make(app, args: args),
    'orderDetail' => OrderDetailFactory.make(app, args: args),
    'visits' => VisitsFactory.make(app, args: args),
    'visitForm' => VisitFormFactory.make(app, args: args),
    'reps' => RepsFactory.make(app, args: args),
    'repDetail' => RepDetailFactory.make(app, args: args),
    'goals' => GoalsFactory.make(app, args: args),
    'cities' => CitiesFactory.make(app, args: args),
    _ => throw ArgumentError('Cena desconhecida: $name'),
  };
}
