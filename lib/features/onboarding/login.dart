import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:messenger/features/onboarding/register.dart';
import 'package:messenger/features/services/auth/auth_services.dart';
import 'package:messenger/features/widgets/buttons.dart';
import 'package:messenger/features/widgets/text_field.dart';
import 'package:messenger/utils/constants/sizes.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/colors.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// sign in method
  void signIn() async {
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailandPassword(
          emailController.text,
          passwordController.text,
      );
    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// logo
              //SizedBox(height: 150),
              Center(child: Icon(Iconsax.message_text_15, size: 100, color: Colors.grey[800])),
              SizedBox(height: 50),

              /// welcome back message
              Text('Welcome back... you have been missed!', style: TextStyle(fontSize: 16)),
              SizedBox(height: TSizes.defaultSpace),

              /// email textfield
              MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
              ),
              SizedBox(height: TSizes.spaceBtwInputFields),

              /// password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              SizedBox(height: TSizes.spaceBtwInputFields),

              /// sign in button
              MyButton(onTap: signIn, text: 'Sign in'),
              SizedBox(height: TSizes.spaceBtwInputFields),

              /// not a member? register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member?'),
                  SizedBox(width: 4),
                  GestureDetector(
                      onTap: widget.onTap,
                      child: Text('Register', style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
