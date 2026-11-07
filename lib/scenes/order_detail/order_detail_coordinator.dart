import '../../app/navigation.dart';

abstract interface class OrderDetailCoordinator implements SceneCoordinator {}

class DefaultOrderDetailCoordinator extends AppCoordinator
    implements OrderDetailCoordinator {
  DefaultOrderDetailCoordinator(super.context, super.app);
}
