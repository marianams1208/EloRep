import '../../app/navigation.dart';

abstract interface class ClientFormCoordinator implements SceneCoordinator {}

class DefaultClientFormCoordinator extends AppCoordinator
    implements ClientFormCoordinator {
  DefaultClientFormCoordinator(super.context, super.app);
}
