import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/recruitment_request_model.dart';
import '../../data/models/request_status.dart';
import '../controllers/adg_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            tooltip: 'New Request',
            onPressed: () => Get.toNamed('/new_request'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GetBuilder<ADGController>(
          builder: (ctl) {
            final items = ctl.requests;
            if (items.isEmpty) {
              return Center(child: Text('No requests yet. Tap + to create one.'));
            }
            return ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (ctx, i) {
                final r = items[i];
                return _RequestListItem(request: r);
              },
            );
          },
        ),
      ),
    );
  }
}

class _RequestListItem extends StatelessWidget {
  final RecruitmentRequest request;
  const _RequestListItem({required this.request});

  @override
  Widget build(BuildContext context) {
    final created = '${request.createdAt.year}-${request.createdAt.month.toString().padLeft(2, '0')}-${request.createdAt.day.toString().padLeft(2, '0')}';
    return InkWell(
      onTap: () => Get.toNamed('/detail/${request.id}'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200), color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 3))]),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // left status indicator
          Container(
            width: 8,
            height: 56,
            decoration: BoxDecoration(color: _statusColor(request.status), borderRadius: BorderRadius.circular(6)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(request.position, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                _smallStatusBadge(request.status),
              ]),
              const SizedBox(height: 6),
              Text('${request.clientName} • ${request.quantity} needed', style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 6),
              Text('Salary: ${request.salaryRange} • Urgency: ${request.urgency} • $created', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ]),
          ),
        ]),
      ),
    );
  }

  Color _statusColor(RequestStatus s) {
    switch (s) {
      case RequestStatus.newRequest:
        return Colors.indigo.shade300;
      case RequestStatus.inProgress:
        return Colors.orange.shade300;
      case RequestStatus.fulfilled:
        return Colors.green.shade300;
      case RequestStatus.closed:
        return Colors.grey.shade400;
    }
  }

  Widget _smallStatusBadge(RequestStatus s) {
    String label;
    Color bg;
    Color txt;
    switch (s) {
      case RequestStatus.newRequest:
        label = 'New';
        bg = Colors.indigo.shade50;
        txt = Colors.indigo.shade700;
        break;
      case RequestStatus.inProgress:
        label = 'In progress';
        bg = Colors.orange.shade50;
        txt = Colors.orange.shade800;
        break;
      case RequestStatus.fulfilled:
        label = 'Fulfilled';
        bg = Colors.green.shade50;
        txt = Colors.green.shade800;
        break;
      default:
        label = 'Closed';
        bg = Colors.grey.shade100;
        txt = Colors.grey.shade800;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(30)),
      child: Text(label, style: TextStyle(color: txt, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}