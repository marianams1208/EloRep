import '../../shared/scene_server.dart';

abstract interface class ServerClients implements SceneServer {}

class CoreServerClients extends CoreSceneServer implements ServerClients {
  CoreServerClients(super.repository);
}
