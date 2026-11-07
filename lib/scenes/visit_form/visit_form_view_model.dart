import '../../shared/scene_view_model.dart';
import 'server_visit_form.dart';
import 'visit_form_coordinator.dart';

class VisitFormViewModel extends SceneViewModel {
  VisitFormViewModel({
    required ServerVisitForm server,
    required VisitFormCoordinator coordinator,
    super.args,
  }) : super(server: server, coordinator: coordinator);
  Future<void> initialize() async {
    await load();
    if (disposed || data == null) return;
    fields = {
      'clientId': args['clientId'] ?? data!.clients.first['id'],
      'date': '2025-06-20',
      'time': '10:30',
      'objective': '',
      'notes': '',
    };
    changed();
  }
}
