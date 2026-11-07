import '../../shared/scene_server.dart';

abstract interface class ServerOrderForm implements SceneServer {}

class CoreServerOrderForm extends CoreSceneServer implements ServerOrderForm {
  CoreServerOrderForm(super.repository);
}
