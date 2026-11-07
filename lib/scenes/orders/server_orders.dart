import '../../shared/scene_server.dart';

abstract interface class ServerOrders implements SceneServer {}

class CoreServerOrders extends CoreSceneServer implements ServerOrders {
  CoreServerOrders(super.repository);
}
