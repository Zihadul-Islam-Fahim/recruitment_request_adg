import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recruitment_request_adg/data/models/job_post_list_model.dart';
import 'package:recruitment_request_adg/presentation/controllers/auth_controller.dart';
import 'package:recruitment_request_adg/presentation/controllers/dashboard_controller.dart';
import 'package:recruitment_request_adg/presentation/controllers/delete_account_controller.dart';


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

  // call: onPressed: () => showLogoutDialog();
  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm logout'),
        content: const Text('Are you sure you want to log out? You will need to log in again to continue.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // close dialog
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async { // show loading UI while logging out
              Get.back(); // close dialog first (optional)
             Get.find<AuthController>().clearAuthData();
              Get.offAllNamed('/login'); // or Get.offAll(() => LoginScreen());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Logout'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Account",
            style: TextStyle(color: Colors.red)),
        content: Text(
            "This action is permanent and cannot be undone.\nDo you want to continue?"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text("Delete"),
            onPressed: () async {
              bool res = await Get.find<DeleteAccountController>().deleteAccount();
              if(res){
                Navigator.pop(context);
                Get.find<AuthController>().clearAuthData();
                Get.offAllNamed('/login');
              }else{
                Navigator.pop(context);
              }

            }
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Requests'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                showLogoutDialog();
              } else if (value == 'delete') {
                _showDeleteDialog(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.black54),
                    SizedBox(width: 10),
                    Text('Logout'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_forever, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Delete Account',
                        style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
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



    DateTime created = DateTime.parse(request.createdAt!).toLocal();
    return InkWell(
      // onTap: () => Get.to(()=> RequestDetailScreen(jobPosts: request,)),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // STATUS INDICATOR
            Container(
              width: 6,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.indigo.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // TITLE
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          request.jobTitle ?? "",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // DETAILS
                  infoRow(Icons.groups_rounded, "${request.vacancyCount} candidates needed"),

                  infoRow(Icons.work_outline_rounded, "Job Type: ${request.jobType}"),

                  infoRow(Icons.payments_outlined,
                      "Salary: ${request.salaryMin} - ${request.salaryMax}"),

                  infoRow(Icons.priority_high_rounded,
                      "Urgency: ${request.urgency}",
                      color: request.urgency == "High"
                          ? Colors.red.shade600
                          : Colors.orange.shade700),

                  infoRow(Icons.schedule_rounded, created.toString(),
                      color: Colors.grey.shade500),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoRow(IconData icon, String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color ?? Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color ?? Colors.grey.shade700,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
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