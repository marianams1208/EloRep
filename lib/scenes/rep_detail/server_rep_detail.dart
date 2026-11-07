import '../../shared/scene_server.dart';

abstract interface class ServerRepDetail implements SceneServer {}

class CoreServerRepDetail extends CoreSceneServer implements ServerRepDetail {
  CoreServerRepDetail(super.repository);
}
