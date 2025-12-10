import 'package:flutter/material.dart';

void main() {
  runApp(const RentRoomApp());
}

class RentRoomApp extends StatelessWidget {
  const RentRoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RentRoom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Roboto',
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case RoomDetailScreen.routeName:
            final room = settings.arguments as Room;
            return MaterialPageRoute(
              builder: (_) => RoomDetailScreen(room: room),
            );
          case '/':
          default:
            return MaterialPageRoute(
              builder: (_) => const MainWrapper(),
            );
        }
      },
    );
  }
}

// ---------------------------------------------------------------------------
// MODEL
// ---------------------------------------------------------------------------

class Room {
  final String id;
  final String title;
  final String location;
  final String price;
  final String imageUrl;
  final String description;
  final double rating;
  final bool available;

  Room({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.available,
  });
}

// Dummy data
final List<Room> dummyRooms = [
  Room(
    id: '1',
    title: 'Kos Eksklusif Dekat Kampus',
    location: 'Depok, Jawa Barat',
    price: 'Rp 1.500.000 / bulan',
    imageUrl:
        'https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg',
    description:
        'Kos eksklusif dengan kamar fully furnished, WiFi kencang, kamar mandi dalam, dan keamanan 24 jam. Cocok untuk mahasiswa yang butuh tempat tinggal nyaman dan tenang.',
    rating: 4.8,
    available: true,
  ),
  Room(
    id: '2',
    title: 'Kontrakan Keluarga 2 Lantai',
    location: 'Bekasi, Jawa Barat',
    price: 'Rp 3.200.000 / bulan',
    imageUrl:
        'https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg',
    description:
        'Kontrakan cocok untuk keluarga kecil. Lokasi strategis dekat minimarket, sekolah, dan akses tol. Lingkungan aman dan nyaman.',
    rating: 4.5,
    available: true,
  ),
  Room(
    id: '3',
    title: 'Kos Murah Dekat Stasiun',
    location: 'Tebet, Jakarta Selatan',
    price: 'Rp 900.000 / bulan',
    imageUrl:
        'https://images.pexels.com/photos/1454806/pexels-photo-1454806.jpeg',
    description:
        'Kos dengan harga terjangkau, lokasi hanya 5 menit jalan kaki ke stasiun. Cocok untuk pekerja kantoran yang sering naik KRL.',
    rating: 4.2,
    available: false,
  ),
];

// ---------------------------------------------------------------------------
// MAIN WRAPPER (BOTTOM NAV 5 LAYAR)
// ---------------------------------------------------------------------------

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _index = 0;

  late final List<Widget> _screens = [
    const HomeScreen(),
    const MapScreen(),
    const BookingScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  final List<String> _titles = const [
    'Beranda',
    'Peta Properti',
    'Booking / Kontak',
    'Favorit',
    'Profil',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_index],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.phone_outlined),
            selectedIcon: Icon(Icons.phone),
            label: 'Booking',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// HOME SCREEN
// ---------------------------------------------------------------------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredRooms = dummyRooms.where((room) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return room.title.toLowerCase().contains(q) ||
          room.location.toLowerCase().contains(q);
    }).toList();

    return Column(
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSearchBar(),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSummaryChipRow(),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: filteredRooms.isEmpty
              ? const Center(
                  child: Text(
                    'Kos tidak ditemukan.\nCoba kata kunci lain.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: filteredRooms.length,
                  itemBuilder: (context, index) {
                    final room = filteredRooms[index];
                    return RoomCard(room: room);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari kos / kontrakan...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
    );
  }

  Widget _buildSummaryChipRow() {
    return Row(
      children: [
        _InfoChip(
          icon: Icons.house_outlined,
          label: '${dummyRooms.length} properti',
        ),
        const SizedBox(width: 8),
        _InfoChip(
          icon: Icons.star_outline,
          label: 'Rating tinggi',
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary.withOpacity(0.1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ROOM CARD
// ---------------------------------------------------------------------------

class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RoomDetailScreen.routeName,
          arguments: room,
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleRow(colorScheme),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          room.location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    room.price,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
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

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              room.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(Icons.image_not_supported_outlined),
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            top: 12,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 14,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    room.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: room.available
                    ? Colors.green.withOpacity(0.85)
                    : Colors.red.withOpacity(0.85),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                room.available ? 'Tersedia' : 'Penuh',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleRow(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            room.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.chevron_right,
          size: 20,
          color: colorScheme.outline,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// ROOM DETAIL
// ---------------------------------------------------------------------------

class RoomDetailScreen extends StatelessWidget {
  static const String routeName = '/details';

  final Room room;

  const RoomDetailScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Properti'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderImage(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          room.location,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber.shade700,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${room.rating.toStringAsFixed(1)} • Sangat baik',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    room.price,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    room.description,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Fasilitas',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _FacilityChip(icon: Icons.wifi, label: 'WiFi'),
                      _FacilityChip(
                          icon: Icons.bed_outlined, label: 'Tempat tidur'),
                      _FacilityChip(
                          icon: Icons.shower_outlined,
                          label: 'Kamar mandi dalam'),
                      _FacilityChip(
                          icon: Icons.local_laundry_service_outlined,
                          label: 'Laundry'),
                      _FacilityChip(icon: Icons.security, label: 'Keamanan'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: room.available
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingScreen(room: room),
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.phone_outlined),
                    label: const Text('Booking / Hubungi Pemilik'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
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

  Widget _buildHeaderImage() {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            room.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey.shade300,
              child: const Center(
                child: Icon(Icons.image_not_supported_outlined),
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          bottom: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  room.available ? 'Siap Huni' : 'Tidak Tersedia',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _FacilityChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FacilityChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary.withOpacity(0.08);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MAP SCREEN
// ---------------------------------------------------------------------------

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Tampilan peta ini masih mock (contoh).\n'
            'Di proyek asli kamu bisa integrasi Google Maps atau peta lainnya.',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withOpacity(0.2),
                      colorScheme.secondary.withOpacity(0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _MapMockPainter(
                          dotColor: colorScheme.primary,
                        ),
                      ),
                    ),
                    ...dummyRooms.asMap().entries.map(
                      (entry) {
                        final index = entry.key;
                        final room = entry.value;
                        final dx = 40.0 + (index * 80);
                        final dy = 80.0 + (index * 60);
                        return Positioned(
                          left: dx,
                          top: dy,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RoomDetailScreen.routeName,
                                arguments: room,
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(999),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withOpacity(0.08),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    room.price.split('/').first,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Icon(
                                  Icons.place,
                                  color: room.available
                                      ? Colors.redAccent
                                      : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _MapMockPainter extends CustomPainter {
  final Color dotColor;

  _MapMockPainter({required this.dotColor});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = 1;

    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final pathPaint = Paint()
      ..color = dotColor.withOpacity(0.7)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.1, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.4,
          size.width * 0.6, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.7,
          size.width * 0.95, size.height * 0.2);

    canvas.drawPath(path, pathPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// BOOKING SCREEN (TAB DAN DARI DETAIL)
// ---------------------------------------------------------------------------

class BookingScreen extends StatefulWidget {
  final Room? room;

  const BookingScreen({super.key, this.room});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  String _duration = '1 bulan';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking terkirim! Pemilik akan menghubungi Anda.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.room;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (room != null) _buildRoomSummary(room),
          if (room == null)
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Isi formulir di bawah ini untuk menghubungi pemilik kos / kontrakan.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
          const SizedBox(height: 16),
          const Text(
            'Data Pemesan',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama lengkap',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Nomor WhatsApp',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Nomor WhatsApp wajib diisi';
                    }
                    if (val.length < 8) {
                      return 'Nomor kurang valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _duration,
                  decoration: const InputDecoration(
                    labelText: 'Perkiraan durasi sewa',
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: '1 bulan', child: Text('1 bulan')),
                    DropdownMenuItem(
                        value: '3 bulan', child: Text('3 bulan')),
                    DropdownMenuItem(
                        value: '6 bulan', child: Text('6 bulan')),
                    DropdownMenuItem(
                        value: '12 bulan', child: Text('12 bulan')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _duration = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Catatan tambahan (opsional)',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.note_outlined),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.send_outlined),
                  label: const Text('Kirim Booking'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomSummary(Room room) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 70,
                height: 70,
                child: Image.network(
                  room.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.home_outlined),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    room.location,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    room.price,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// FAVORITES SCREEN
// ---------------------------------------------------------------------------

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // contoh: anggap favorit = semua yang available
    final favorites =
        dummyRooms.where((room) => room.available).toList();

    if (favorites.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada properti favorit.\nTap ikon hati di daftar untuk menandai.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final room = favorites[index];
        return RoomCard(room: room);
      },
    );
  }
}

// ---------------------------------------------------------------------------
// PROFILE SCREEN
// ---------------------------------------------------------------------------

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHeader(colorScheme),
          const SizedBox(height: 24),
          _buildInfoTile(
            icon: Icons.phone_outlined,
            title: 'Nomor WhatsApp',
            subtitle: '+62 812-3456-7890',
          ),
          _buildInfoTile(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: 'user@rentroom.app',
          ),
          _buildInfoTile(
            icon: Icons.location_city_outlined,
            title: 'Domisili',
            subtitle: 'Jakarta, Indonesia',
          ),
          const SizedBox(height: 24),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: colorScheme.primary.withOpacity(0.15),
              child: Text(
                'RR',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User RentRoom',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Akun standar',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
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

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Edit Profil'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(46),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.logout_outlined),
          label: const Text('Logout'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(46),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}
