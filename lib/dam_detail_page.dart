import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart'; // Grafik paketimizi import ediyoruz

class DamDetailPage extends StatefulWidget {
  final Map<String, dynamic> dam;

  const DamDetailPage({super.key, required this.dam});

  @override
  State<DamDetailPage> createState() => _DamDetailPageState();
}

class _DamDetailPageState extends State<DamDetailPage> {
  bool _isGraphLoading = true;
  String? _graphError;
  List<dynamic> _graphData = [];

  @override
  void initState() {
    super.initState();
    _fetchGraphData();
  }

  Future<void> _fetchGraphData() async {
    // Tıklanan barajın adını alıyoruz.
    final String damName = widget.dam['baslikAdi'] ?? 'default';
    final String apiUrl = 'http://10.0.2.2:8090/api/dams/$damName/graph';

    try {
      final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        setState(() {
          _graphData = jsonDecode(decodedBody);
          _isGraphLoading = false;
        });
      } else {
        setState(() {
          _graphError = 'Grafik verisi yüklenemedi: ${response.statusCode}';
          _isGraphLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _graphError = 'Grafik verisi çekilirken hata oluştu: $e';
        _isGraphLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String damName = widget.dam['baslikAdi'] ?? 'Baraj Detayı';

    return Scaffold(
      appBar: AppBar(
        title: Text(damName),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Son 14 Günlük Doluluk Değişimi',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250, // Grafik alanını biraz büyüttük
              child: _isGraphLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _graphError != null
                  ? Center(child: Text('Hata: $_graphError'))
                  : _graphData.isEmpty
                  ? const Center(child: Text('Grafik için veri bulunamadı.'))
                  : LineChart( // fl_chart paketinden gelen ana grafik widget'ı
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Tarihleri göstermiyoruz, çok kalabalık olur
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [ // Grafiğin çizgi verisi
                    LineChartBarData(
                      spots: _graphData.asMap().entries.map((entry) {
                        int index = entry.key;
                        var dataPoint = entry.value;
                        return FlSpot(
                          index.toDouble(), // X ekseni: 0, 1, 2...
                          dataPoint['dolulukOrani']?.toDouble() ?? 0.0, // Y ekseni: Doluluk Oranı
                        );
                      }).toList(),
                      isCurved: true, // Çizgiyi yumuşatır
                      color: Colors.blue,
                      barWidth: 4,
                      belowBarData: BarAreaData( // Çizginin altını doldurur
                        show: true,
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}