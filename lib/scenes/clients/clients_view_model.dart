import '../../shared/scene_view_model.dart';
import 'server_clients.dart';
import 'clients_coordinator.dart';

class ClientsViewModel extends SceneViewModel {
  ClientsViewModel({
    required ServerClients server,
    required ClientsCoordinator coordinator,
    super.args,
  }) : super(server: server, coordinator: coordinator);
  Future<void> initialize() async {
    await load();
    if (disposed || data == null) return;
    changed();
  }
}
