import '../../shared/scene_server.dart';

abstract interface class ServerClientForm implements SceneServer {}

class CoreServerClientForm extends CoreSceneServer implements ServerClientForm {
  CoreServerClientForm(super.repository);
}
