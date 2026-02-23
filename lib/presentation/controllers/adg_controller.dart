import 'package:get/get.dart';

import '../../data/models/recruitment_request_model.dart' show RecruitmentRequest;
import '../../data/models/request_status.dart';

class ADGController extends GetxController {
  // in-memory store (replace with API)
  final List<RecruitmentRequest> requests = [
    RecruitmentRequest(
      id: 'r1',
      clientName: 'Demo Company',
      clientEmail: 'hr@demo.com',
      clientPhone: '+1 555 0100',
      position: 'Software Engineer',
      jobDescription: 'Full stack developer, 2+ yrs, remote possible',
      quantity: 3,
      salaryRange: '\$1200 - \$1500',
      urgency: 'Medium',
      createdAt: DateTime.now().subtract(Duration(days: 2)),
      attachedFileName: null,
    )
  ];

  // create and add new request
  void createRequest(RecruitmentRequest r) {
    requests.insert(0, r);
    update(); // notify GetBuilder listeners
    // notify manager — replace with push / email / webhook
    Get.snackbar('Request submitted', 'ADG manager notified', snackPosition: SnackPosition.BOTTOM);
  }

  RecruitmentRequest? findById(String id) => FirstWhereExt(requests).firstWhereOrNull((r) => r.id == id);

  void updateStatus(String id, RequestStatus newStatus) {
    final idx = requests.indexWhere((r) => r.id == id);
    if (idx >= 0) {
      requests[idx].status = newStatus;
      update();
    }
  }
}

// small helper extension
extension FirstWhereOrNull<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var e in this) if (test(e)) return e;
    return null;
  }
}
