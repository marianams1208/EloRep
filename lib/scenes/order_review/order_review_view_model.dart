import '../../shared/scene_view_model.dart';
import 'server_order_review.dart';
import 'order_review_coordinator.dart';

class OrderReviewViewModel extends SceneViewModel {
  OrderReviewViewModel({
    required ServerOrderReview server,
    required OrderReviewCoordinator coordinator,
    super.args,
  }) : super(server: server, coordinator: coordinator);
  Future<void> initialize() async {
    await load();
    if (disposed || data == null) return;
    changed();
  }
}
