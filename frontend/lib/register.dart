import 'package:flutter/material.dart';
import 'register_address.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _showVerifyDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        "Verify your phone number",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      children: [
                        const TextSpan(text: "Enter the 6-digit code send to you at "),
                        TextSpan(
                          text: "+62 ${_phoneController.text.isEmpty ? '80000000000' : _phoneController.text}",
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // 6 Digit OTP fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: "",
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                      ),
                    ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                // Resend text
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.black),
                    children: [
                      TextSpan(text: "Didn't get the code? "),
                      TextSpan(
                        text: "Resend code",
                        style: TextStyle(
                          color: Color(0xFF4AA5A6),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: " in 00:30"),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Verify button
                SizedBox(
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA5D1D6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Verify",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Sign up Heading
              const Text(
                "Sign up",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 25),

              // Full Name Field
              const Text(
                "Nama lengkap",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 40,
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Color(0xFF4AA5A6)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Username Field
              const Text(
                "Username",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 40,
                child: TextField(
                  controller: _usernameController,
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Color(0xFF4AA5A6)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              const Text(
                "Password",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 40,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Color(0xFF4AA5A6)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Phone Number Field
              const Text(
                "Nomor telepon",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Row(
                  children: [
                    // Country Code Dropdown Fake
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(29),
                          bottomLeft: Radius.circular(29),
                        ),
                      ),
                      child: Row(
                        children: const [
                          Text(
                            "+62",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 4),
                        ],
                      ),
                    ),
                    // Divider
                    Container(width: 1, color: Colors.grey.shade400),
                    // Phone Number Input
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textAlignVertical: TextAlignVertical.center, 
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 14),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          isDense: true,
                        ),
                      ),
                    ),
                    // Verify Button
                    Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: InkWell(
                        onTap: () {
                          _showVerifyDialog(context);
                        },
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF9ACAD0),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.black54, width: 0.5),
                          ),
                          child: const Text(
                            "verify",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(), // Use Spacer to push buttons to the bottom without scrolling

              // Button Selanjutnya
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterAddressPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA5D1D6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Selanjutnya",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Sudah Punya Akun Link
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context); // Go back to login
                  },
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  child: const Text(
                    "Sudah punya akun? Masuk",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Color(0xFF4AA5A6),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF4AA5A6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
