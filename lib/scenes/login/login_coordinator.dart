import '../../app/navigation.dart';

abstract interface class LoginCoordinator implements SceneCoordinator {}

class DefaultLoginCoordinator extends AppCoordinator
    implements LoginCoordinator {
  DefaultLoginCoordinator(super.context, super.app);
}
