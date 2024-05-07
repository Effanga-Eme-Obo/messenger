import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:messenger/features/services/auth/auth_services.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/sizes.dart';
import '../widgets/buttons.dart';
import '../widgets/text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  /// sign up method
  void signUp() async {
    if(passwordController.text != confirmPasswordController.text){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match')));

      return;
    }
    /// get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailandPassword(emailController.text, passwordController.text);
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

              /// welcome message
              Text("Welcome... let's create an account for you!", style: TextStyle(fontSize: 16)),
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

              /// confirm password textfield
              MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),
              SizedBox(height: TSizes.spaceBtwInputFields),

              /// sign up button
              MyButton(onTap: signUp, text: 'Sign up'),
              SizedBox(height: TSizes.spaceBtwInputFields),

              /// not a member? register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already a member?'),
                  SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text('Login', style: TextStyle(fontWeight: FontWeight.w500)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
