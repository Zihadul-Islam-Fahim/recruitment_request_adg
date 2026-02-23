import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:recruitment_request_adg/presentation/screens/dashboard_screen.dart';

import '../controllers/signup_controller.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  // register controller (or you can use Get.find if already put elsewhere)
  final SignupController ctl = Get.find<SignupController>();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: GetBuilder<SignupController>(
          builder: (c) {

            return Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Create an account', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                const Text('Register to post requests and manage hires.'),

                const SizedBox(height: 20),

                // Name
                TextFormField(
                  controller: c.nameCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person)),
                  validator: c.validateName,
                ),
                const SizedBox(height: 12),

                // Company name
                TextFormField(
                  controller: c.companyCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Company name', prefixIcon: Icon(Icons.business)),
                  validator: c.validateCompany,
                ),
                const SizedBox(height: 12),

                // Email
                TextFormField(
                  controller: c.emailCtrl,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                  validator: c.validateEmail,
                ),
                const SizedBox(height: 12),

                // Password with visibility toggle (controller-driven)
                TextFormField(
                  controller: c.passwordCtrl,
                  obscureText: !c.passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(c.passwordVisible ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => c.togglePasswordVisibility(),
                      tooltip: c.passwordVisible ? 'Hide password' : 'Show password',
                    ),
                  ),
                  validator: c.validatePassword,
                ),
                const SizedBox(height: 20),

                // Signup button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: ()async{
                      if(_formKey.currentState!.validate()){
                       bool res = await  ctl.signup();
                       if(res){
                         Get.offAll(()=>DashboardScreen());
                       }
                      }

                                  },
                    child: c.inProgress
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Sign up',style: TextStyle(color: Colors.white),)),
                  ),
                ),

                const SizedBox(height: 12),

                // Optional: small CTA to login
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('Already have an account?'),
                  TextButton(onPressed: () => Get.back(), child: const Text('Log in')),
                ]),

                const SizedBox(height: 20),

                // Demo: show created users (for development)

              ]),
            );
          },
        ),
      ),
    );
  }
}