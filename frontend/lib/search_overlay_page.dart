import 'package:flutter/material.dart';
import 'map_search_result_page.dart';
import 'services/search_history.dart';

class SearchOverlayPage extends StatefulWidget {
  const SearchOverlayPage({super.key});

  @override
  State<SearchOverlayPage> createState() => _SearchOverlayPageState();
}

class _SearchOverlayPageState extends State<SearchOverlayPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  static const List<_Recommendation> _recommendations = [
    _Recommendation(icon: Icons.restaurant_outlined, label: 'Restoran'),
    _Recommendation(icon: Icons.hotel_outlined, label: 'Hotel'),
    _Recommendation(icon: Icons.local_mall_outlined, label: 'Mall'),
    _Recommendation(icon: Icons.local_gas_station_outlined, label: 'Pom bensin'),
    _Recommendation(icon: Icons.local_cafe_outlined, label: 'Kafe'),
    _Recommendation(icon: Icons.local_hospital_outlined, label: 'Rumah sakit'),
    _Recommendation(icon: Icons.local_pharmacy_outlined, label: 'Apotek'),
    _Recommendation(icon: Icons.atm_outlined, label: 'ATM'),
  ];

  @override
  void initState() {
    super.initState();
    // autofocus after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit(String query) {
    final q = query.trim();
    if (q.isEmpty) return;
    SearchHistory.add(q);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MapSearchResultPage(query: q)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = SearchHistory.items;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Search bar row ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.black54, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 14),
                          const Icon(Icons.search,
                              color: Color(0xFF4AA5A6), size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              onSubmitted: _submit,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: 'Mau ke mana hari ini?',
                                hintStyle: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                  fontStyle: FontStyle.italic,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              style: const TextStyle(
                                  fontFamily: 'Inter', fontSize: 14),
                            ),
                          ),
                          if (_controller.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _controller.clear();
                                setState(() {});
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Icon(Icons.close,
                                    color: Colors.grey, size: 20),
                              ),
                            )
                          else
                            const SizedBox(width: 12),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1),

            // ── List ────────────────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 8),
                children: [
                  // Recent history
                  if (history.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Pencarian terbaru',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              SearchHistory.clear();
                              setState(() {});
                            },
                            child: const Text(
                              'Hapus semua',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...history.map(
                      (q) => ListTile(
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.history,
                              color: Colors.black54, size: 20),
                        ),
                        title: Text(
                          q,
                          style: const TextStyle(
                              fontFamily: 'Inter', fontSize: 14),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close,
                              size: 18, color: Colors.black38),
                          onPressed: () {
                            SearchHistory.remove(q);
                            setState(() {});
                          },
                        ),
                        onTap: () => _submit(q),
                      ),
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                  ],

                  // Recommendations
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Text(
                      'Rekomendasi',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  ..._recommendations.map(
                    (r) => ListTile(
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4AA5A6).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(r.icon,
                            color: const Color(0xFF4AA5A6), size: 20),
                      ),
                      title: Text(
                        r.label,
                        style: const TextStyle(
                            fontFamily: 'Inter', fontSize: 14),
                      ),
                      onTap: () => _submit(r.label),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Recommendation {
  final IconData icon;
  final String label;
  const _Recommendation({required this.icon, required this.label});
}
