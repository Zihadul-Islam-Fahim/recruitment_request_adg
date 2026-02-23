import 'package:recruitment_request_adg/data/models/request_status.dart';

class RecruitmentRequest {
  final String id;
  final String clientName;
  final String clientEmail;
  final String clientPhone;
  final String position;
  final String jobDescription;
  final int quantity;
  final String salaryRange;
  final String urgency; // Low / Medium / High
  final DateTime createdAt;
  RequestStatus status;
  String? attachedFileName; // demo only; replace with URL or file metadata in production

  RecruitmentRequest({
    required this.id,
    required this.clientName,
    required this.clientEmail,
    required this.clientPhone,
    required this.position,
    required this.jobDescription,
    required this.quantity,
    required this.salaryRange,
    required this.urgency,
    required this.createdAt,
    this.status = RequestStatus.newRequest,
    this.attachedFileName,
  });
}