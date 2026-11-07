import '../../app/navigation.dart';

abstract interface class ClientDetailCoordinator implements SceneCoordinator {}

class DefaultClientDetailCoordinator extends AppCoordinator
    implements ClientDetailCoordinator {
  DefaultClientDetailCoordinator(super.context, super.app);
}
