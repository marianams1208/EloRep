import '../../app/navigation.dart';

abstract interface class OrderReviewCoordinator implements SceneCoordinator {}

class DefaultOrderReviewCoordinator extends AppCoordinator
    implements OrderReviewCoordinator {
  DefaultOrderReviewCoordinator(super.context, super.app);
}
