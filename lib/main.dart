import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dam_detail_page.dart';

// --- API URL YAPILANDIRMASI ---
const String localApiUrl = 'http://10.0.2.2:8090';
const String liveApiUrl = 'http://iski-radar-app-env.eba-mgdiqfpx.eu-north-1.elasticbeanstalk.com';

// Geliştirme ve canlı ortam arasında geçiş yapmak için bu satırı değiştir.
const String currentApiUrl = liveApiUrl; // Canlı test için 'liveApiUrl'
// const String currentApiUrl = localApiUrl; // Lokal test için 'localApiUrl'

void main() {
  runApp(const IskiRadarApp());
}

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

class DamListPage extends StatefulWidget {
  const DamListPage({super.key});

  @override
  State<DamListPage> createState() => _DamListPageState();
}

class _DamListPageState extends State<DamListPage> {
  List<dynamic> _dams = [];
  Map<String, dynamic>? _overviewData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final damsFuture = http.get(Uri.parse('$currentApiUrl/api/dams'));
      final overviewFuture = http.get(Uri.parse('$currentApiUrl/api/dams/overview'));

      final responses = await Future.wait([damsFuture, overviewFuture]);

      final damsResponse = responses[0];
      final overviewResponse = responses[1];

      if (damsResponse.statusCode == 200 && overviewResponse.statusCode == 200) {
        final decodedDams = utf8.decode(damsResponse.bodyBytes);
        final decodedOverview = utf8.decode(overviewResponse.bodyBytes);

        setState(() {
          _dams = jsonDecode(decodedDams);
          _overviewData = jsonDecode(decodedOverview);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Veriler yüklenemedi. Baraj Listesi: ${damsResponse.statusCode}, Özet: ${overviewResponse.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Bir hata oluştu: $e. Sunucunun çalıştığından emin olun.';
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
      body: RefreshIndicator(
        onRefresh: _fetchAllData,
        child: _buildBody(),
      ),
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
              onPressed: _fetchAllData,
              child: const Text('Tekrar Dene'),
            )
          ],
        ),
      );
    }

    return Column(
      children: [
        _buildOverviewCard(),
        const Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Barajlar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
        Expanded(
          child: _buildDamList(),
        ),
      ],
    );
  }

  Widget _buildOverviewCard() {
    if (_overviewData == null) return const SizedBox.shrink();

    final average = _overviewData!['genelDolulukOraniOrtalamasi'] as double;
    final count = _overviewData!['barajSayisi'] as int;
    final lastUpdate = _overviewData!['sonGuncellemeZamani'] as String;

    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "İstanbul Barajları Genel Doluluk Oranı",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "%${average.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "$count baraj verisine göre | Son Güncelleme: $lastUpdate",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDamList() {
    if (_dams.isEmpty) {
      return const Center(child: Text('Gösterilecek baraj verisi bulunamadı.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _dams.length,
      itemBuilder: (context, index) {
        final dam = _dams[index];
        final double occupancyRate = double.tryParse(dam['dolulukOrani']?.toString().replaceAll(',', '.') ?? '0.0') ?? 0.0;

        Color progressColor;
        if (occupancyRate > 70) {
          progressColor = Colors.green;
        } else if (occupancyRate > 40) {
          progressColor = Colors.orange;
        } else {
          progressColor = Colors.red;
        }

        return InkWell(
          onTap: () {
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
      },
    );
  }
}