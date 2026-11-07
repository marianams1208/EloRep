import '../../shared/scene_view_model.dart';
import 'server_order_detail.dart';
import 'order_detail_coordinator.dart';

class OrderDetailViewModel extends SceneViewModel {
  OrderDetailViewModel({
    required ServerOrderDetail server,
    required OrderDetailCoordinator coordinator,
    super.args,
  }) : super(server: server, coordinator: coordinator);
  Future<void> initialize() async {
    await load();
    if (disposed || data == null) return;
    changed();
  }
}
