import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:petcare/Screens/Dashboard.dart';
import 'package:petcare/Screens/signup.dart';
import 'package:petcare/widget/mytextformfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  double blurValue = 0; // default blur

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onFocusChanged);
    _passwordFocusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    setState(() {
      blurValue = (_emailFocusNode.hasFocus || _passwordFocusNode.hasFocus)
          ? 5
          : 0;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _tryLogin() {
    // Trigger field validators
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      // Show a friendly message and stop navigation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors above.')),
      );
      return;
    }

    // If valid, proceed to dashboard
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background (you can remove this if you want a flat color)
          Positioned.fill(
            child: Transform.scale(
              scale: 1.3,
              child: Image.asset('assets/images/cat.jpg', fit: BoxFit.cover),
            ),
          ),

          // Dynamic blur based on focus
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
              child:
                  Container(), // transparent overlay required by BackdropFilter
            ),
          ),

          // Form contents
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: _formKey,
                // This line makes the error messages appear automatically
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Email field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: MyTextformfield(
                        controller: _emailController,
                        hintText: "example@gmail.com",
                        labelText: "Email",
                        errorMessage: "Incorrect email", // shows when empty
                        prefixIcon: const Icon(
                          Icons.email_rounded,
                          color: Colors.black,
                        ),
                        focusNode: _emailFocusNode,
                        filled: true,
                        fillcolor: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Password field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: MyTextformfield(
                        controller: _passwordController,
                        hintText: "*********",
                        labelText: "Enter Your Password",
                        errorMessage: "Incorrect Password", // shows when empty
                        prefixIcon: const Icon(
                          Icons.lock_rounded,
                          color: Colors.black,
                        ),
                        focusNode: _passwordFocusNode,
                        filled: true,
                        fillcolor: Colors.white,
                        obscureText: true,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            _tryLogin, // <-- validate first, then navigate if OK
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Signup link
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Signup()),
                        );
                      },
                      child: const Text(
                        "Don't have an Account?",
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
