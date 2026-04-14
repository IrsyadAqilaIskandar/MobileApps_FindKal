import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AiTripDetailPage extends StatefulWidget {
  final String tripName;
  final List<Map<String, dynamic>> places;
  final List<Map<String, dynamic>> transport;

  const AiTripDetailPage({
    super.key,
    required this.tripName,
    this.places = const [],
    this.transport = const [],
  });

  @override
  State<AiTripDetailPage> createState() => _AiTripDetailPageState();
}

class _AiTripDetailPageState extends State<AiTripDetailPage> {
  late List<Map<String, dynamic>> timelineItems;

  @override
  void initState() {
    super.initState();
    timelineItems = List<Map<String, dynamic>>.from(widget.places);
  }

  void _editPlan() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ubah Rencana',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4AA5A6),
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(timelineItems.length, (index) {
                  final item = timelineItems[index];
                  TextEditingController timeController = TextEditingController(
                    text: item['time'],
                  );
                  TextEditingController titleController = TextEditingController(
                    text: item['title'],
                  );
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Destinasi ${index + 1}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: timeController,
                                decoration: InputDecoration(
                                  labelText: 'Waktu',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onChanged: (val) {
                                  timelineItems[index]['time'] = val;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 5,
                              child: TextField(
                                controller: titleController,
                                decoration: InputDecoration(
                                  labelText: 'Tempat',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onChanged: (val) {
                                  timelineItems[index]['title'] = val;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9CCCD0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Simpan Perubahan',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4AA5A6)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MapPreviewCard(items: timelineItems),
                    const SizedBox(height: 24),
                    Text(
                      'Rencana Kegiatanmu: ${widget.tripName}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4AA5A6),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: const [
                        SizedBox(width: 4),
                        Icon(Icons.circle, size: 12, color: Color(0xFFE0E0E0)),
                        SizedBox(width: 16),
                        Text(
                          'Tempat',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4AA5A6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    ...List.generate(timelineItems.length, (index) {
                      final item = timelineItems[index];
                      return _buildTimelineItem(
                        time: item['time'] ?? '',
                        title: item['title'] ?? '',
                        details: item['details'] ?? '',
                        imageUrl: item['image_url'] as String?,
                        isLast: false,
                      );
                    }),
                    _buildTransportSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
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
                        'Selesai',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _editPlan,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFF9CCCD0),
                          width: 2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Ubah rencana',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9CCCD0),
                        ),
                      ),
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

  Widget _buildTimelineItem({
    required String time,
    required String title,
    required String details,
    String? imageUrl,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const SizedBox(height: 4),
            const Icon(Icons.circle, size: 10, color: Color(0xFFE0E0E0)),
            if (!isLast) ...[
              const SizedBox(height: 8),
              ...List.generate(8, (_) => const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Icon(Icons.circle, size: 6, color: Color(0xFFE0E0E0)),
              )),
            ],
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: imageUrl != null
                          ? Image.network(
                              imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, e, stack) => _imagePlaceholder(),
                            )
                          : _imagePlaceholder(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            details,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              color: Colors.grey,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.place, color: Colors.grey),
    );
  }

  Widget _buildTransportSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const SizedBox(height: 4),
            const Icon(Icons.circle, size: 10, color: Color(0xFFE0E0E0)),
            ...List.generate(
              15,
              (index) => const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(Icons.circle, size: 6, color: Color(0xFFE0E0E0)),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bisa naik transportasi ini!',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4AA5A6),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 360,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 11,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAEAEA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Rekomendasi transportasi',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            _buildTransportCard(icon: Icons.motorcycle, name: 'Motor', time: '40', isWhite: true),
                            const SizedBox(height: 12),
                            _buildTransportCard(icon: Icons.directions_car, name: 'Mobil', time: '50', isWhite: true),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 10,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _buildTransportCard(icon: Icons.directions_car, name: 'Mobil', time: '50', isWhite: false),
                          const SizedBox(height: 12),
                          _buildTransportCard(icon: Icons.motorcycle, name: 'Motor', time: '40', isWhite: false),
                          const SizedBox(height: 12),
                          _buildTransportCard(icon: Icons.directions_transit, name: 'Kereta', time: '35', isWhite: false),
                          const SizedBox(height: 12),
                          _buildTransportCard(icon: Icons.directions_bus, name: 'Bus', time: '55', isWhite: false),
                          const SizedBox(height: 12),
                          _buildTransportCard(icon: Icons.directions_walk, name: 'Jalan kaki', time: '120', isWhite: false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransportCard({
    required IconData icon,
    required String name,
    required String time,
    required bool isWhite,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isWhite ? Colors.white : const Color(0xFFEAEAEA),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isWhite ? const Color(0xFFF0F0F0) : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: Colors.black87),
                const SizedBox(width: 6),
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Lama waktu tempuh:',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4AA5A6),
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'Menit',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MapPreviewCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const MapPreviewCard({super.key, required this.items});

  static const _defaultCenter = LatLng(-6.302640, 106.639383); // BSD City

  @override
  Widget build(BuildContext context) {
    final validItems = items
        .where((p) => p['latitude'] != null && p['longitude'] != null)
        .toList();
    final points = validItems
        .map((p) => LatLng(
              (p['latitude'] as num).toDouble(),
              (p['longitude'] as num).toDouble(),
            ))
        .toList();

    MapOptions mapOptions;
    if (points.length >= 2) {
      mapOptions = MapOptions(
        initialCameraFit: CameraFit.coordinates(
          coordinates: points,
          padding: const EdgeInsets.all(64),
        ),
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.none,
        ),
      );
    } else if (points.length == 1) {
      mapOptions = MapOptions(
        initialCenter: points.first,
        initialZoom: 15,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.none,
        ),
      );
    } else {
      mapOptions = const MapOptions(
        initialCenter: _defaultCenter,
        initialZoom: 14,
        interactionOptions: InteractionOptions(
          flags: InteractiveFlag.none,
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: FlutterMap(
          options: mapOptions,
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.findkal.app',
            ),
            if (points.length >= 2)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: points,
                    color: const Color(0xFF4AA5A6),
                    strokeWidth: 3.5,
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                for (int i = 0; i < validItems.length; i++)
                  Marker(
                    point: points[i],
                    width: 155,
                    height: 100,
                    alignment: Alignment.bottomCenter,
                    child: _MapFloatingCard(
                      title: validItems[i]['title'] ?? '',
                      imageUrl: validItems[i]['image_url'] as String?,
                      time: validItems[i]['time'] ?? '',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MapFloatingCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String time;

  const _MapFloatingCard({
    required this.title,
    this.imageUrl,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    height: 50,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      height: 50,
                      color: Colors.grey[300],
                      child: const Icon(Icons.place, size: 20, color: Colors.grey),
                    ),
                  )
                : Container(
                    height: 50,
                    color: Colors.grey[300],
                    child: const Icon(Icons.place, size: 20, color: Colors.grey),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: Color(0xFF4AA5A6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
