import 'package:flutter/material.dart';
import 'order_detail_page.dart';

class OrdersContentWidget extends StatelessWidget {
  const OrdersContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 110),
      children: [
        Text(
          'Riwayat Pesanan',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
        ),
        const SizedBox(height: 16),
        _buildOrderItem(context, 'Sedang Dicuci', 'INV-001', 'Besok, 14:00', Colors.blue),
        const SizedBox(height: 16),
        _buildOrderItem(context, 'Selesai', 'INV-002', '12 Mei 2026', Colors.green),
      ],
    );
  }

  Widget _buildOrderItem(BuildContext context, String status, String id, String date, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderDetailPage()));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.local_shipping, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Order $id • $date',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
