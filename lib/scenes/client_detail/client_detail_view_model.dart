import '../../shared/scene_view_model.dart';
import 'server_client_detail.dart';
import 'client_detail_coordinator.dart';

class ClientDetailViewModel extends SceneViewModel {
  ClientDetailViewModel({
    required ServerClientDetail server,
    required ClientDetailCoordinator coordinator,
    super.args,
  }) : super(server: server, coordinator: coordinator);
  Future<void> initialize() async {
    await load();
    if (disposed || data == null) return;
    changed();
  }
}
