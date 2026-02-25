import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recruitment_request_adg/data/models/job_post_list_model.dart';
import 'package:recruitment_request_adg/presentation/controllers/dashboard_controller.dart';

import '../../data/models/recruitment_request_model.dart';
import '../../data/models/request_status.dart';
import '../controllers/adg_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timestamp){
      Get.find<DashboardController>().getPosts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Requests'),
      ),

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GetBuilder<DashboardController>(
              builder: (ctl) {
                if(ctl.inProgress==false){
                final items = ctl.jobPostListModel?.jobPostList ?? [];
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
                }else{
                  return Center(child: CircularProgressIndicator(),);
                }
              },
            ),
          ),
          Positioned(bottom: 40,
              right: 20,
              child: MaterialButton(
                onPressed: () => Get.toNamed('/new_request'),
                height: 50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                ),
                minWidth: 160,
                color: Theme
                    .of(context)
                    .primaryColor,
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.white,),
                    SizedBox(width: 5,),
                    Text("New Request",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
          ),
        ],
      ),
    );
  }
}

class _RequestListItem extends StatelessWidget {

  final JobPosts request;
  const _RequestListItem({required this.request});

  @override
  Widget build(BuildContext context) {
    final created = request.createdAt;
    return InkWell(
      // onTap: () => Get.toNamed('/detail/${request.id}'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200), color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 3))]),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // left status indicator
          Container(
            width: 8,
            height: 56,
            decoration: BoxDecoration(color: Colors.indigo.shade300, borderRadius: BorderRadius.circular(6)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(request.jobTitle ?? "", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                //_smallStatusBadge(request.status),
              ]),
              const SizedBox(height: 6),
              Text('${request.jobTitle} • ${request.vacancyCount} needed', style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 6),
              Text('Salary: ${request.salaryMin} - ${request.salaryMax} • Urgency: ${request.urgency} • $created', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ]),
          ),
        ]),
      ),
    );
  }

  // Color _statusColor(RequestStatus s) {
  //   switch (s) {
  //     case RequestStatus.newRequest:
  //       return Colors.indigo.shade300;
  //     case RequestStatus.inProgress:
  //       return Colors.orange.shade300;
  //     case RequestStatus.fulfilled:
  //       return Colors.green.shade300;
  //     case RequestStatus.closed:
  //       return Colors.grey.shade400;
  //   }
  // }

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