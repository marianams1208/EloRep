import '../../shared/scene_view_model.dart';
import 'server_order_form.dart';
import 'order_form_coordinator.dart';

class OrderFormViewModel extends SceneViewModel {
  OrderFormViewModel({
    required ServerOrderForm server,
    required OrderFormCoordinator coordinator,
    super.args,
  }) : super(server: server, coordinator: coordinator);
  Future<void> initialize() async {
    await load();
    if (disposed || data == null) return;
    fields = {
      'clientId': args['clientId'] ?? data!.clients.first['id'],
      'repId': args['repId'] ?? 'r1',
      'amount': '',
      'reference': '',
    };
    changed();
  }
}
