import 'package:flutter/material.dart';
import 'package:flutter_application_1/dashboard.dart';
import 'package:flutter_application_1/tambah_batch.dart';
import 'package:flutter_application_1/data_batch.dart';
import 'package:flutter_application_1/data_process.dart';
import 'package:flutter_application_1/data_margin.dart';

class PilihHalaman extends StatefulWidget {
  const PilihHalaman({super.key});

  @override
  State<PilihHalaman> createState() => _PilihHalamanState();
}

class _PilihHalamanState extends State<PilihHalaman> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Dashboard(),
    const TambahBatch(),
    const DataBatch(),
    const DataProcess(),
    const DataMargin(),
  //  const LaporanPage(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Tambah Batch',
    'Data Batch',
    'Data Proses',
    'Data Margin',
    'Laporan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),

      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Tambah Batch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Data Batch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Data Proses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Data Margin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Laporan',
          ),
        ],
      ),
    );
  }
}

// ===================== DASHBOARD =====================

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildCard(
              title: 'Total Batch',
              value: '10',
              color: Colors.blue,
            ),

            const SizedBox(height: 10),

            buildCard(
              title: 'Total Modal',
              value: '50.000.000',
              color: Colors.green,
            ),

            const SizedBox(height: 10),

            buildCard(
              title: 'Total Penjualan',
              value: '100.000.000',
              color: Colors.orange,
            ),

            const SizedBox(height: 10),

            buildCard(
              title: 'Total Profit',
              value: '50.000.000',
              color: Colors.red,
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Shrinkage Rata-rata:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '10%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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

  Widget buildCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// // ===================== HALAMAN =====================

// class TambahBatchPage extends StatelessWidget {
//   const TambahBatchPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text(
//         'Halaman Tambah Batch',
//         style: TextStyle(fontSize: 22),
//       ),
//     );
//   }
// }

// class DataBatchPage extends StatelessWidget {
//   const DataBatchPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text(
//         'Halaman Data Batch',
//         style: TextStyle(fontSize: 22),
//       ),
//     );
//   }
// }

// class DataProsesPage extends StatelessWidget {
//   const DataProsesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text(
//         'Halaman Data Proses',
//         style: TextStyle(fontSize: 22),
//       ),
//     );
//   }
// }

// class DataMarginPage extends StatelessWidget {
//   const DataMarginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text(
//         'Halaman Data Margin',
//         style: TextStyle(fontSize: 22),
//       ),
//     );
//   }
// }

// class LaporanPage extends StatelessWidget {
//   const LaporanPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text(
//         'Halaman Laporan',
//         style: TextStyle(fontSize: 22),
//       ),
//     );
//   }
// }

// ===================== PROFILE =====================

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Halaman Profil',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';

// class PilihHalaman extends StatefulWidget {
//   const PilihHalaman({super.key});

//   @override
//   State<PilihHalaman> createState() => _PilihHalamanState();
// }

// class _PilihHalamanState extends State<PilihHalaman> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }