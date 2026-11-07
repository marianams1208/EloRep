import '../../app/navigation.dart';

abstract interface class OrderFormCoordinator implements SceneCoordinator {}

class DefaultOrderFormCoordinator extends AppCoordinator
    implements OrderFormCoordinator {
  DefaultOrderFormCoordinator(super.context, super.app);
}
