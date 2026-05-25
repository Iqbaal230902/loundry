import 'package:flutter/material.dart';

class PromoContentWidget extends StatelessWidget {
  const PromoContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 110),
      children: [
        Text(
          'Promo Menarik',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
        ),
        const SizedBox(height: 16),
        _buildPromoCard(
          'Diskon 30%',
          'Untuk Pengguna Baru!',
          [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)],
        ),
        const SizedBox(height: 16),
        _buildPromoCard(
          'Cashback 20%',
          'Pakai E-Wallet',
          [const Color(0xFF10B981), const Color(0xFF047857)],
        ),
      ],
    );
  }

  Widget _buildPromoCard(String title, String subtitle, List<Color> colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
