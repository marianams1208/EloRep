import '../../app/navigation.dart';

abstract interface class OrdersCoordinator implements SceneCoordinator {}

class DefaultOrdersCoordinator extends AppCoordinator
    implements OrdersCoordinator {
  DefaultOrdersCoordinator(super.context, super.app);
}
