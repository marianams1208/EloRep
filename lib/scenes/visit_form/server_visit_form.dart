import '../../shared/scene_server.dart';

abstract interface class ServerVisitForm implements SceneServer {}

class CoreServerVisitForm extends CoreSceneServer implements ServerVisitForm {
  CoreServerVisitForm(super.repository);
}
