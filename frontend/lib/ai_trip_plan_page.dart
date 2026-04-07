import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String _apiBase = 'https://api-regional-indonesia.vercel.app/api';

class AiTripPlanPage extends StatefulWidget {
  const AiTripPlanPage({super.key});

  @override
  State<AiTripPlanPage> createState() => _AiTripPlanPageState();
}

class _AiTripPlanPageState extends State<AiTripPlanPage> {
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _budgetController = TextEditingController();

  // Location state
  String? _selectedProvinceId;
  String? _selectedCityId;
  String? _selectedProvince;
  String? _selectedCity;

  List<Map<String, String>> _provinces = [];
  List<Map<String, String>> _cities = [];

  bool _loadingProvinces = false;
  bool _loadingCities = false;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<List<Map<String, String>>> _fetch(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat data (${response.statusCode})');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;
    return data
        .map((e) => {'id': e['id'].toString(), 'name': e['name'].toString()})
        .toList();
  }

  Future<void> _loadProvinces() async {
    setState(() => _loadingProvinces = true);
    try {
      final list = await _fetch('$_apiBase/provinces');
      setState(() => _provinces = list);
    } catch (_) {
    } finally {
      setState(() => _loadingProvinces = false);
    }
  }

  Future<void> _onProvinceChanged(String id, String name) async {
    setState(() {
      _selectedProvinceId = id;
      _selectedProvince = name;
      _selectedCityId = null;
      _selectedCity = null;
      _cities = [];
      _loadingCities = true;
    });
    try {
      final list = await _fetch('$_apiBase/cities/$id');
      setState(() => _cities = list);
    } catch (_) {
    } finally {
      setState(() => _loadingCities = false);
    }
  }

  void _onCityChanged(String id, String name) {
    setState(() {
      _selectedCityId = id;
      _selectedCity = name;
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
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4AA5A6)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mulai Rencanakan Perjalananmu',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Biarkan AI yang membantu merencanakan\nperjalananmu kali ini.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),

              // Nama perjalanan
              _buildTextField(
                label: 'Nama perjalanan',
                controller: _nameController,
              ),
              const SizedBox(height: 16),

              // Provinsi
              _buildDropdown(
                label: 'Provinsi',
                items: _provinces,
                value: _selectedProvince,
                loading: _loadingProvinces,
                onChanged: (id, name) => _onProvinceChanged(id, name),
              ),
              const SizedBox(height: 16),

              // Kota
              _buildDropdown(
                label: 'Kota (Opsional)',
                items: _cities,
                value: _selectedCity,
                loading: _loadingCities,
                onChanged: _selectedProvinceId != null
                    ? (id, name) => _onCityChanged(id, name)
                    : null,
              ),
              const SizedBox(height: 16),

              // Durasi + Budget
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Durasi (hari)',
                      controller: _durationController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: 'Budget (Rp)',
                      controller: _budgetController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Generate button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement AI generation
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9CCCD0),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Generate Rencana Perjalanan',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4AA5A6)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.black,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.only(top: 4, bottom: 4),
            ),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<Map<String, String>> items,
    required String? value,
    required void Function(String id, String name)? onChanged,
    bool loading = false,
  }) {
    final bool enabled = !loading && items.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4AA5A6)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          if (loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF4AA5A6),
                ),
              ),
            )
          else
            SizedBox(
              height: 24,
              child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: value,
                hint: Text(
                  enabled ? 'Pilih $label' : '',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                icon: const Icon(
                  Icons.unfold_more,
                  size: 20,
                  color: Colors.black54,
                ),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: enabled
                    ? (selectedName) {
                        if (selectedName == null) return;
                        final item = items.firstWhere(
                          (e) => e['name'] == selectedName,
                        );
                        onChanged!(item['id']!, item['name']!);
                      }
                    : null,
                items: items
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e['name'],
                        child: Text(
                          e['name']!,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            ),
        ],
      ),
    );
  }
}
