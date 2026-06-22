import 'package:flutter/material.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  final String phoneNumber;
  const SignUpScreen({super.key, required this.phoneNumber});

  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  void _saveUser() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phoneNumber = '+91${_phoneController.text.trim()}';

    if (name.isEmpty || email.isEmpty || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    // Basic email validation
    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // Firestore-il user doc update cheyyu
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'displayName': name,
        'email': email,
        'phoneNumber': '+91${widget.phoneNumber}',
        'photoURL': '',
        'createdAt': Timestamp.now(),
      });

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => _isLoading = false);
  }

  void initState() {
    super.initState();
    _phoneController.text =
        widget.phoneNumber; // already verified number pre-fill
  }

  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            const Text(
              "Create account",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Fill in your details to get started",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
            ),

            const SizedBox(height: 40),

            // Name field
            _buildInputField(
              controller: _nameController,
              hint: "Full name",
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 16),

            // Email field
            _buildInputField(
              controller: _emailController,
              hint: "Email address",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16),
            _buildInputField(
              controller: _phoneController,
              hint: "Phone number",
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),

            // Phone number (read only)
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            //   decoration: BoxDecoration(
            //     color: AppColors.card,
            //     borderRadius: BorderRadius.circular(12),
            //     border: Border.all(color: AppColors.border),
            //   ),
            //   child: Row(
            //     children: [
            //       const Icon(
            //         Icons.phone_outlined,
            //         color: AppColors.textHint,
            //         size: 20,
            //       ),
            //       const SizedBox(width: 12),
            //       Expanded(
            //         child: Text(
            //           widget.phoneNumber.isNotEmpty
            //               ? "+91 ${widget.phoneNumber}"
            //               : "Phone number",
            //           style: TextStyle(
            //             color: widget.phoneNumber.isNotEmpty
            //                 ? AppColors.textSecondary
            //                 : AppColors.textHint,
            //             fontSize: 15,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 60),

            // Continue button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.black,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Create Account",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const Spacer(),
                Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text(
                    "Log in",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Reusable input field widget
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      cursorColor: AppColors.primary,
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textHint),
        prefixIcon: Icon(icon, color: AppColors.textHint, size: 20),
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
