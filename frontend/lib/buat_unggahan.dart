import 'package:flutter/material.dart';
import 'services/auth_state.dart';

class BuatUnggahanPage extends StatefulWidget {
  const BuatUnggahanPage({super.key});

  @override
  State<BuatUnggahanPage> createState() => _BuatUnggahanPageState();
}

class _BuatUnggahanPageState extends State<BuatUnggahanPage> {
  int _selectedRating = 0;
  String _selectedBudget = "";

  void _onBudgetSelected(String budget) {
    setState(() {
      _selectedBudget = budget;
    });
  }

  void _onRatingSelected(int rating) {
    setState(() {
      _selectedRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF4AA5A6)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Buat unggahan",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User section
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFF4AA5A6),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AuthState.currentUser?['name'] ?? "Zaenal Yudha Zala",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                    ),
                    Text(
                      "@${AuthState.currentUser?['username'] ?? 'username'}",
                      style: TextStyle(color: Colors.grey.shade500, fontFamily: 'Inter', fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Gambar
            const Text("Gambar", style: TextStyle(fontFamily: 'Inter', fontSize: 14)),
            const SizedBox(height: 8),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade400, width: 0.5),
              ),
              child: const Center(
                child: Icon(Icons.camera_alt, color: Colors.white, size: 32),
              ),
            ),
            const SizedBox(height: 24),

            // Rating Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () => _onRatingSelected(index + 1),
                  icon: Icon(
                    Icons.star,
                    color: index < _selectedRating ? Colors.amber : Colors.grey.shade300,
                    size: 40,
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // Form inputs
            const Text("Nama tempat", style: TextStyle(fontFamily: 'Inter', fontSize: 13)),
            const SizedBox(height: 8),
            _buildTextField(),
            const SizedBox(height: 16),

            const Text("Alamat", style: TextStyle(fontFamily: 'Inter', fontSize: 13)),
            const SizedBox(height: 8),
            _buildTextField(maxLines: 3),
            const SizedBox(height: 16),

            const Text("Ulasan", style: TextStyle(fontFamily: 'Inter', fontSize: 13)),
            const SizedBox(height: 8),
            _buildTextField(maxLines: 3),
            const SizedBox(height: 24),

            // Budget
            const Text(
              "Berapa budget yang kamu untuk pergi ke sini (per orang)?",
              style: TextStyle(fontFamily: 'Inter', fontSize: 13),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildBudgetChip("Rp 1k - Rp 50k"),
                _buildBudgetChip("Rp 50k - Rp 100k"),
                _buildBudgetChip("Rp 100k - Rp 150k"),
                _buildBudgetChip("Rp 150k - Rp 200k"),
                _buildBudgetChip("Rp 250k+"),
              ],
            ),

            const SizedBox(height: 40),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // Handle action
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9ACAD0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Lanjutkan",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF4AA5A6)),
        ),
      ),
    );
  }

  Widget _buildBudgetChip(String text) {
    final isSelected = _selectedBudget == text;
    return InkWell(
      onTap: () => _onBudgetSelected(text),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4AA5A6) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF4AA5A6) : Colors.grey.shade400,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}