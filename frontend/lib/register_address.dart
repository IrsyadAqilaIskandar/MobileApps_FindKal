import 'package:flutter/material.dart';

class RegisterAddressPage extends StatefulWidget {
  const RegisterAddressPage({super.key});

  @override
  State<RegisterAddressPage> createState() => _RegisterAddressPageState();
}

class _RegisterAddressPageState extends State<RegisterAddressPage> {
  // Widget pembantu untuk field berformat dropdown
  Widget _buildDropdownField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: TextField(
                  style: TextStyle(fontFamily: 'Inter', fontSize: 14),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Icon(Icons.unfold_more, size: 20, color: Colors.grey.shade700),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        leading: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF4AA5A6),
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
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

              _buildDropdownField("Negara"),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: _buildDropdownField("Provinsi")),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDropdownField("Kota")),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: _buildDropdownField("Kecamatan")),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDropdownField("Kelurahan")),
                ],
              ),

              const Spacer(), // Mendorong tombol ke bawah
              // Button Buat Akun
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA5D1D6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Buat akun",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
