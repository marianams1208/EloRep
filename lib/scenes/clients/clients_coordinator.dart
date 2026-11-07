import '../../app/navigation.dart';

abstract interface class ClientsCoordinator implements SceneCoordinator {}

class DefaultClientsCoordinator extends AppCoordinator
    implements ClientsCoordinator {
  DefaultClientsCoordinator(super.context, super.app);
}
