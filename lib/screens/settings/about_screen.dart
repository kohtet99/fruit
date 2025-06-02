import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bgColor = Colors.white;
    final sectionColor = Colors.grey[100];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Color(0xFF58211B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'About Application',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 24),
          _buildCardSection(
            sectionColor,
            title: 'App Information',
            children: const [
              _InfoRow(label: 'App Name', value: 'Assignment App'),
              _InfoRow(label: 'Version', value: '1.0.0'),
              _InfoRow(label: 'Platform', value: 'Flutter'),
            ],
          ),
          const SizedBox(height: 24),
          _buildCardSection(
            sectionColor,
            title: 'Developer',
            children: const [
              _InfoRow(label: 'Name', value: 'Lufi'),
              _InfoRow(label: 'Email', value: 'Lufi9492@gmail.com'),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Assignment1 \nUsed Provider and Hive',
            style: TextStyle(color: Colors.grey[700], fontSize: 14, height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }


  Widget _buildCardSection(Color? color, {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -1),
      title: Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
      trailing: Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87)),
    );
  }
}
