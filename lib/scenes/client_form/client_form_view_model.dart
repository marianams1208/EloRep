import '../../shared/scene_view_model.dart';
import 'server_client_form.dart';
import 'client_form_coordinator.dart';

class ClientFormViewModel extends SceneViewModel {
  ClientFormViewModel({
    required ServerClientForm server,
    required ClientFormCoordinator coordinator,
    super.args,
  }) : super(server: server, coordinator: coordinator);
  Future<void> initialize() async {
    await load();
    if (disposed || data == null) return;
    if (args['editId'] != null) {
      final c = data!.client(args['editId']);
      fields = {
        for (final k in ['name', 'city', 'uf', 'phone', 'cnpj'])
          k: (c[k] ?? '').toString(),
      };
    }
    changed();
  }
}
