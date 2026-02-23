import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/request_status.dart';
import '../controllers/adg_controller.dart';

class RequestDetailScreen extends StatelessWidget {
  const RequestDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.parameters['id'] ?? '';
    return GetBuilder<ADGController>(
      builder: (ctl) {
        final r = ctl.findById(id);
        if (r == null) {
          return Scaffold(appBar: AppBar(title: const Text('Request')), body: const Center(child: Text('Not found')));
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Request details')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Header
              Row(children: [
                Expanded(child: Text(r.position, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
                _statusChip(r.status),
              ]),
              const SizedBox(height: 8),
              Text('${r.clientName} • ${r.clientEmail} • ${r.clientPhone}', style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 12),

              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Job description', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(r.jobDescription.isNotEmpty ? r.jobDescription : '—'),
                    const SizedBox(height: 12),
                    Row(children: [
                      const Icon(Icons.people_outline, size: 16),
                      const SizedBox(width: 8),
                      Text('Quantity: ${r.quantity}'),
                      const SizedBox(width: 20),
                      const Icon(Icons.monetization_on_outlined, size: 16),
                      const SizedBox(width: 8),
                      Text('Salary: ${r.salaryRange.isNotEmpty ? r.salaryRange : '—'}'),

                    ]),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        const Icon(Icons.priority_high_outlined, size: 16),
                        const SizedBox(width: 8),
                        Text('Urgency: ${r.urgency}'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (r.attachedFileName != null) ...[
                      const Divider(),
                      Text('Attachment', style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      ListTile(
                        leading: const Icon(Icons.attach_file),
                        title: Text(r.attachedFileName!),
                        trailing: IconButton(icon: const Icon(Icons.download_outlined), onPressed: () => Get.snackbar('Download', 'Download not implemented')),
                      ),
                    ],
                  ]),
                ),
              ),

              const SizedBox(height: 12),
              const Text('Actions', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, children: [
                ElevatedButton.icon(onPressed: () => ctl.updateStatus(r.id, RequestStatus.inProgress), icon: const Icon(Icons.play_arrow), label: const Text('Start')),
                OutlinedButton.icon(onPressed: () => ctl.updateStatus(r.id, RequestStatus.fulfilled), icon: const Icon(Icons.done), label: const Text('Mark fulfilled')),
                OutlinedButton.icon(onPressed: () => ctl.updateStatus(r.id, RequestStatus.closed), icon: const Icon(Icons.close), label: const Text('Close')),
              ]),

              const SizedBox(height: 18),
              Text('Audit & history', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              // Minimal history (replace with real event log)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Created: ${r.createdAt}'),
                    const SizedBox(height: 6),
                    Text('Current status: ${_statusLabel(r.status)}'),
                  ]),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }

  Widget _statusChip(RequestStatus s) {
    final label = _statusLabel(s);
    Color bg;
    Color text;
    switch (s) {
      case RequestStatus.newRequest:
        bg = Colors.indigo.shade50;
        text = Colors.indigo.shade800;
        break;
      case RequestStatus.inProgress:
        bg = Colors.orange.shade50;
        text = Colors.orange.shade800;
        break;
      case RequestStatus.fulfilled:
        bg = Colors.green.shade50;
        text = Colors.green.shade800;
        break;
      default:
        bg = Colors.grey.shade100;
        text = Colors.grey.shade800;
    }
    return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)), child: Text(label, style: TextStyle(color: text, fontWeight: FontWeight.w700)));
  }

  String _statusLabel(RequestStatus s) {
    switch (s) {
      case RequestStatus.newRequest:
        return 'New';
      case RequestStatus.inProgress:
        return 'In progress';
      case RequestStatus.fulfilled:
        return 'Fulfilled';
      case RequestStatus.closed:
        return 'Closed';
    }
  }
}