import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'services/auth_state.dart';
import 'services/api_service.dart';

class UnggahanPreviewPage extends StatefulWidget {
  final List<XFile> images;
  final String locationName;
  final int rating;
  final String address;
  final String review;
  final String budget;

  const UnggahanPreviewPage({
    super.key,
    required this.images,
    required this.locationName,
    required this.rating,
    required this.address,
    required this.review,
    required this.budget,
  });

  @override
  State<UnggahanPreviewPage> createState() => _UnggahanPreviewPageState();
}

class _UnggahanPreviewPageState extends State<UnggahanPreviewPage> {
  bool _isUploading = false;

  Future<void> _upload() async {
    setState(() => _isUploading = true);
    try {
      final userId = AuthState.currentUser?['id'] as int?;
      if (userId == null) throw const ApiException('User tidak ditemukan.');

      await ApiService.uploadUnggahan(
        userId: userId,
        namaTempat: widget.locationName,
        alamat: widget.address,
        ulasan: widget.review,
        rating: widget.rating,
        budget: widget.budget,
        imagePaths: widget.images.map((x) => x.path).toList(),
      );

      if (!mounted) return;
      Navigator.pop(context);
      Navigator.pop(context);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message, style: const TextStyle(fontFamily: 'Inter'))),
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile
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
                      AuthState.currentUser?['name'] ?? 'Nama Pengguna',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter', fontSize: 16),
                    ),
                    Text(
                      "@${AuthState.currentUser?['username'] ?? 'username'}",
                      style: TextStyle(color: Colors.grey.shade500, fontFamily: 'Inter', fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Collages
            _buildImageCollage(),
            const SizedBox(height: 16),

            // Location Name and Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.locationName,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4AA5A6),
                    ),
                  ),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      color: index < widget.rating ? Colors.amber : Colors.grey.shade300,
                      size: 20,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Address
            const Text("Alamat", style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF4AA5A6))),
            const SizedBox(height: 4),
            Text(widget.address, style: const TextStyle(fontFamily: 'Inter', fontSize: 14)),
            const SizedBox(height: 16),

            // Review
            const Text("Ulasan", style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF4AA5A6))),
            const SizedBox(height: 4),
            Text(widget.review, style: const TextStyle(fontFamily: 'Inter', fontSize: 14)),
            const SizedBox(height: 16),

            // Budget
            const Text("Budget per orang", style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF4AA5A6))),
            const SizedBox(height: 4),
            Text(widget.budget, style: const TextStyle(fontFamily: 'Inter', fontSize: 14)),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
        decoration: const BoxDecoration(color: Colors.white),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isUploading ? null : _upload,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9ACAD0),
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 0,
            ),
            child: _isUploading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text(
                    "Unggah",
                    style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageCollage() {
    if (widget.images.isEmpty) return const SizedBox();

    final files = widget.images.map((x) => File(x.path)).toList();

    if (files.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(files[0], width: double.infinity, height: 260, fit: BoxFit.cover),
      );
    } else if (files.length == 2) {
      return SizedBox(
        height: 260,
        child: Row(
          children: [
            Expanded(child: ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)), child: Image.file(files[0], height: 260, fit: BoxFit.cover))),
            const SizedBox(width: 4),
            Expanded(child: ClipRRect(borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)), child: Image.file(files[1], height: 260, fit: BoxFit.cover))),
          ],
        ),
      );
    } else if (files.length == 3) {
      return SizedBox(
        height: 260,
        child: Row(
          children: [
            Expanded(
              flex: 1, 
              child: Column(
                children: [
                  Expanded(child: ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(12)), child: Image.file(files[0], width: double.infinity, fit: BoxFit.cover))),
                  const SizedBox(height: 4),
                  Expanded(child: ClipRRect(borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12)), child: Image.file(files[1], width: double.infinity, fit: BoxFit.cover))),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              flex: 1, 
              child: ClipRRect(borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)), child: Image.file(files[2], height: 260, fit: BoxFit.cover))
            ),
          ],
        ),
      );
    } else { // 4 images
      return SizedBox(
        height: 260,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(12)), child: Image.file(files[0], width: double.infinity, fit: BoxFit.cover))),
                  const SizedBox(width: 4),
                  Expanded(child: ClipRRect(borderRadius: const BorderRadius.only(topRight: Radius.circular(12)), child: Image.file(files[1], width: double.infinity, fit: BoxFit.cover))),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: ClipRRect(borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12)), child: Image.file(files[2], width: double.infinity, fit: BoxFit.cover))),
                  const SizedBox(width: 4),
                  Expanded(child: ClipRRect(borderRadius: const BorderRadius.only(bottomRight: Radius.circular(12)), child: Image.file(files[3], width: double.infinity, fit: BoxFit.cover))),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
