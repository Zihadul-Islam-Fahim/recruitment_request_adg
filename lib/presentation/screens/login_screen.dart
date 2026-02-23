import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recruitment_request_adg/presentation/controllers/login_controller.dart';
import 'package:recruitment_request_adg/presentation/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Simple demo login (replace with real auth)
    return Scaffold(
      appBar: AppBar(title: const Text('Recruitment Request ADG')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          const SizedBox(height: 12),
          Text('Company login', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 18),
          TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 12),
          TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
          const SizedBox(height: 18),
          GetBuilder<LoginController>(
            builder: (ctl) {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: ()async {
                    // demo: any non-empty logs in
                    if (_emailCtrl.text.trim().isEmpty) {
                      Get.snackbar('Error', 'Enter email', snackPosition: SnackPosition.TOP);
                      return;
                    }else if (_passCtrl.text.trim().isEmpty) {
                      Get.snackbar('Error', 'Enter password', snackPosition: SnackPosition.TOP);
                      return;
                    }else{
                      bool res = await ctl.login(_emailCtrl.text, _passCtrl.text);
                      if(res){
                        Get.offAllNamed('/dashboard');
                      }
                    }

                  },
                  child: ctl.inProgress ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  :Text('Login',style: TextStyle(color: Colors.white),),
                ),
              );
            }
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              Get.toNamed('/register'); // demo quick access
            },
            child: const Text('Register as a Company'),
          )
        ]),
      ),
    );
  }
}
