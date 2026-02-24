import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final _salaryType = TextEditingController();
  final _experience = TextEditingController();
  final _jobLocation = TextEditingController();
  String _urgency = 'Medium';
  String? _jobTitle;
  String? _selectedPosition;
  String? _attachedFileName; // demo only

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

  // Future<void> _pickFileDemo() async {
  //   // For demo we just show a fake file name.
  //   // To implement real files: use file_picker package + upload to server / storage and store returned URL
  //   // Uncomment file_picker import & code when ready.
  //   // FilePickerResult? res = await FilePicker.platform.pickFiles();
  //   // if (res != null) { _attachedFileName = res.files.single.name; setState(() {}); }
  //   setState(() {
  //     _attachedFileName = 'job_description.pdf'; // demo value
  //   });
  //   Get.snackbar('File', 'Attached $_attachedFileName', snackPosition: SnackPosition.BOTTOM);
  // }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final position = (_selectedPosition != null && _selectedPosition!.isNotEmpty) ? _selectedPosition! : _positionCtrl.text.trim();
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final req = RecruitmentRequest(
      id: id,
      clientName: _jobType.text.trim(),
      clientEmail: _vacancyCount.text.trim(),
      clientPhone: _clientPhone.text.trim(),
      position: position,
      jobDescription: _jobDescCtrl.text.trim(),
      quantity: int.tryParse(_salaryMin.text.trim()) ?? 1,
      salaryRange: _salaryMax.text.trim(),
      urgency: _urgency,
      createdAt: DateTime.now(),
      attachedFileName: _attachedFileName,
    );

    final ctl = Get.find<ADGController>();
    ctl.createRequest(req);

    Get.offAllNamed('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Recruitment Request')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              if (!v.contains('@')) return 'Invalid ';
              return null;
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
            Row(children: [
              // ElevatedButton.icon(onPressed: _pickFileDemo, icon: const Icon(Icons.attach_file), label: const Text('Attach file')),
              const SizedBox(width: 12),
              if (_attachedFileName != null) Text(_attachedFileName!, style: const TextStyle(color: Colors.grey)),
            ]),

            const SizedBox(height: 16),

            // CRITICAL REQUIREMENTS
            const Text('Critical requirements', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(children: [
              Flexible(
                flex: 2,
                child: TextFormField(controller: _salaryMin, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number, validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  final n = int.tryParse(v);
                  if (n == null || n <= 0) return 'Invalid';
                  return null;
                }),
              ),
              const SizedBox(width: 12),
              Flexible(flex: 3, child: TextFormField(controller: _salaryMax, decoration: const InputDecoration(labelText: 'Salary range (e.g. 1000-1500)'))),
            ]),
            const SizedBox(height: 12),

            // URGENCY
            const Text('Urgency', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(children: ['Low', 'Medium', 'High'].map((u) {
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
                icon: const Icon(Icons.send),
                label: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Submit Request')),
              ),
            ),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }
}