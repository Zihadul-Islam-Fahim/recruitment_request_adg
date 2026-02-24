import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recruitment_request_adg/presentation/controllers/request_controller.dart';

import '../../data/models/recruitment_request_model.dart';
import '../controllers/adg_controller.dart';

class NewRequestScreen extends StatefulWidget {
  const NewRequestScreen({super.key});
  @override
  State<NewRequestScreen> createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jobType = TextEditingController();
  final _vacancyCount = TextEditingController();
  final _clientPhone = TextEditingController();
  final _positionCtrl = TextEditingController();
  final _jobDescCtrl = TextEditingController();
  final _salaryMin = TextEditingController(text: '1');
  final _salaryMax = TextEditingController();
  final _email = TextEditingController();
  // final _salaryType = TextEditingController();

  final _jobLocation = TextEditingController();
  String _urgency = 'medium';
  String? _selectedPosition;


  // sample common positions (could come from backend)
  final List<String> commonPositions = [
    'Software Engineer',
    'Customer Support',
    'Forklift Operator',
    'Cleaner',
    'Nurse',
    'Driver',
    'Accountant',
  ];

  @override
  void dispose() {
    _jobType.dispose();
    _vacancyCount.dispose();
    _clientPhone.dispose();
    _positionCtrl.dispose();
    _jobDescCtrl.dispose();
    _salaryMin.dispose();
    _salaryMax.dispose();
    super.dispose();
  }

  void _submit()async {
    if (!_formKey.currentState!.validate()) return;

    final position = (_selectedPosition != null && _selectedPosition!.isNotEmpty) ? _selectedPosition! : _positionCtrl.text.trim();
    final id = DateTime.now().millisecondsSinceEpoch.toString();

   bool res = await Get.find<RequestController>().sendInfo(
        jobTitle: position ?? "",
        jobType: _jobType.text,
        vacancyCount: _vacancyCount.text,
        urgency: _urgency,
        salaryMin: _salaryMin.text,
        salaryMax: _salaryMax.text,
        jobLocation: _jobLocation.text,
        description: _jobDescCtrl.text,
        email: _email.text,
        phone: _clientPhone.text
    );

    if(res){
      Get.offAllNamed('/dashboard');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Recruitment Request')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: GetBuilder<RequestController>(
            builder: (ctl) {
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // CLIENT INFO
                // const Text('Client contact', style: TextStyle(fontWeight: FontWeight.w700)),
                // const SizedBox(height: 8),
                const Text('Position', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedPosition,
                  items: [null, ...commonPositions].map((p) {
                    if (p == null) return const DropdownMenuItem<String>(value: null, child: Text('Select or type new position'));
                    return DropdownMenuItem<String>(value: p, child: Text(p));
                  }).toList(),
                  onChanged: (v) => setState(() => _selectedPosition = v),
                  decoration: const InputDecoration(),
                ),
                const SizedBox(height: 8),
                TextFormField(controller: _positionCtrl, decoration: const InputDecoration(labelText: 'Or enter position manually (overrides)')),

                const SizedBox(height: 8),
                TextFormField(controller: _jobType, decoration: const InputDecoration(labelText: 'Job type - Fulltime/Part-time'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
                const SizedBox(height: 8),
                TextFormField(controller: _vacancyCount, decoration: const InputDecoration(labelText: 'Vacancy count'), validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';

                }),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: TextFormField(controller: _salaryMin, decoration: const InputDecoration(labelText: 'Salary Min'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null)),
                    SizedBox(width: 8,),
                    Expanded(child: TextFormField(controller: _salaryMax, decoration: const InputDecoration(labelText: 'Salary Max'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null)),
                  ],
                ),
                const SizedBox(height: 16),

                // POSITION


                // JOB DESCRIPTION
                const Text('Job description', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                TextFormField(controller: _jobDescCtrl, maxLines: 5, decoration: const InputDecoration(hintText: 'Responsibilities, skills, shift, location')),
                const SizedBox(height: 8),


                const SizedBox(height: 16),

                // CRITICAL REQUIREMENTS
                const Text('Critical requirements', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),

                  TextFormField(controller: _jobLocation, decoration: const InputDecoration(labelText: 'Job Location'), keyboardType: TextInputType.number, validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';

                  }),
                  const SizedBox(height: 8),
                  TextFormField(controller: _clientPhone,keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone')),
                  const SizedBox(height: 8),
                  TextFormField(controller: _email,keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Email'),validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (!v.contains('@')) return 'Invalid email';
                    return null;
                  }),

                const SizedBox(height: 12),
                ElevatedButton.icon(onPressed: ctl.pickFileDemo, icon: const Icon(Icons.attach_file,color: Colors.white,), label: const Text('Attach file',style: TextStyle(color: Colors.white),)),
                const SizedBox(height: 12),
                Row(children: [

                  const SizedBox(width: 12),
                  if (ctl.hasFile) Text(ctl.fileName, style: const TextStyle(color: Colors.grey)),
                ]),
                const Text('Urgency', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Row(children: ['low', 'medium', 'high'].map((u) {
                  final selected = _urgency == u;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(label: Text(u), selected: selected, onSelected: (_) => setState(() => _urgency = u)),
                  );
                }).toList()),
                const SizedBox(height: 20),

                // SUBMIT
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: ctl.inProgress? Icon(Icons.circle_outlined,color: Colors.white,) : Icon(Icons.send,color: Colors.white,),
                    label: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Submit Request',style: TextStyle(color: Colors.white),)),
                  ),
                ),
                const SizedBox(height: 20),
              ]);
            }
          ),
        ),
      ),
    );
  }
}