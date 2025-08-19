import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // HTTP istekleri için
import 'dart:convert';                   // JSON decode için
import 'dam_detail_page.dart';           // YENİ DETAY SAYFAMIZI IMPORT EDİYORUZ

void main() {
  runApp(const IskiRadarApp());
}

// 1. Ana Uygulama Widget'ı
class IskiRadarApp extends StatelessWidget {
  const IskiRadarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'İSKİ Radar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const DamListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 2. Ana Ekran Widget'ı
class DamListPage extends StatefulWidget {
  const DamListPage({super.key});

  @override
  State<DamListPage> createState() => _DamListPageState();
}

// 3. Ana Ekranın Durumunu Yöneten Sınıf
class _DamListPageState extends State<DamListPage> {
  List<dynamic> _dams = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDams();
  }

  Future<void> _fetchDams() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    // Geliştirme için lokal adresi kullanıyoruz
    const String apiUrl = 'http://10.0.2.2:8090/api/dams';

    try {
      final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        setState(() {
          _dams = jsonDecode(decodedBody);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Veriler yüklenemedi. Sunucu hatası: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Bir hata oluştu: $e. Backend API\'sinin çalıştığından emin olun.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İSKİ Baraj Doluluk Oranları'),
        backgroundColor: Colors.blue[800],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Hata: $_error', textAlign: TextAlign.center),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchDams,
              child: const Text('Tekrar Dene'),
            )
          ],
        ),
      );
    }
    if (_dams.isEmpty) {
      return const Center(child: Text('Gösterilecek baraj verisi bulunamadı.'));
    }

    return RefreshIndicator(
      onRefresh: _fetchDams,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _dams.length,
        itemBuilder: (context, index) {
          final dam = _dams[index];
          final double occupancyRate = double.tryParse(dam['dolulukOrani'] ?? '0.0') ?? 0.0;

          Color progressColor;
          if (occupancyRate > 70) {
            progressColor = Colors.green;
          } else if (occupancyRate > 40) {
            progressColor = Colors.orange;
          } else {
            progressColor = Colors.red;
          }

          // --- DEĞİŞİKLİK BURADA BAŞLIYOR ---
          return InkWell(
            onTap: () {
              // Tıklandığında yeni sayfayı aç ve 'dam' verisini gönder.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DamDetailPage(dam: dam),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(dam['baslikAdi'] ?? 'İsim Yok', style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text(
                        '%${occupancyRate.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: progressColor,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: progressColor.withOpacity(0.2),
                        child: Text('${index + 1}', style: TextStyle(color: progressColor, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      child: LinearProgressIndicator(
                        value: occupancyRate / 100.0,
                        backgroundColor: Colors.grey[300],
                        color: progressColor,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          // --- DEĞİŞİKLİK BURADA BİTİYOR ---
        },
      ),
    );
  }
}