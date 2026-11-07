import '../../shared/scene_server.dart';

abstract interface class ServerClientDetail implements SceneServer {}

class CoreServerClientDetail extends CoreSceneServer
    implements ServerClientDetail {
  CoreServerClientDetail(super.repository);
}
