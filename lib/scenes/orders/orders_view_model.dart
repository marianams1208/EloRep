import '../../shared/scene_view_model.dart';
import 'server_orders.dart';
import 'orders_coordinator.dart';

class OrdersViewModel extends SceneViewModel {
  OrdersViewModel({
    required ServerOrders server,
    required OrdersCoordinator coordinator,
    super.args,
  }) : super(server: server, coordinator: coordinator);
  Future<void> initialize() async {
    await load();
    if (disposed || data == null) return;
    changed();
  }
}
