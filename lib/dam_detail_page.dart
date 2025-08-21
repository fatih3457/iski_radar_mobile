import 'package:flutter/material.dart';

class DamDetailPage extends StatelessWidget {
  // Bu sayfa, dışarıdan hala tıklanan barajın tüm verilerini içeren
  // bir 'dam' nesnesi alıyor.
  final Map<String, dynamic> dam;

  const DamDetailPage({super.key, required this.dam});

  @override
  Widget build(BuildContext context) {
    final String damName = dam['baslikAdi'] ?? 'Baraj Detayı';

    return Scaffold(
      appBar: AppBar(
        title: Text(damName),
        backgroundColor: Colors.blue[800],
      ),
      // Tüm detayları alt alta listelemek için ListView kullanıyoruz.
      body: ListView(
        padding: const EdgeInsets.all(16.0), // Kenarlara boşluk verelim.
        children: [
          // Her bir bilgi için, daha önce de kullandığımız bu yardımcı metodu çağırıyoruz.
          _buildDetailRow('Mevcut Su Hacmi', '${dam['mevcutSuHacmi'] ?? 'N/A'}', 'milyon m³'),
          _buildDetailRow('Biriktirme Hacmi', '${dam['biriktirmeHacmi'] ?? 'N/A'}', 'milyon m³'),
          _buildDetailRow('Azami Su Seviyesi', '${dam['azamiSuSeviyesi'] ?? 'N/A'}', 'm'),
          _buildDetailRow('Verim', '${dam['verim'] ?? 'N/A'}', 'milyon m³/yıl'),
          _buildDetailRow('Kaynak Adı', dam['kaynakAdi'] ?? 'N/A', ''),
        ],
      ),
    );
  }

  // Tekrar eden satır yapısını oluşturan yardımcı metot.
  Widget _buildDetailRow(String label, String value, String unit) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
        trailing: Text(
          '$value $unit',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}