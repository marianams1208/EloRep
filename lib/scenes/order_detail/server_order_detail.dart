import '../../shared/scene_server.dart';

abstract interface class ServerOrderDetail implements SceneServer {}

class CoreServerOrderDetail extends CoreSceneServer
    implements ServerOrderDetail {
  CoreServerOrderDetail(super.repository);
}
