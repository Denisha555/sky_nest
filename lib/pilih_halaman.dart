import 'package:flutter/material.dart';
import 'package:flutter_application_1/dashboard.dart';
import 'package:flutter_application_1/tambah_batch.dart';
import 'package:flutter_application_1/data_batch.dart';
import 'package:flutter_application_1/data_process.dart';
import 'package:flutter_application_1/data_margin.dart';
import 'package:flutter_application_1/laporan.dart';
import 'package:flutter_application_1/profil.dart';

class PilihHalaman extends StatefulWidget {
  const PilihHalaman({super.key});

  @override
  State<PilihHalaman> createState() => _PilihHalamanState();
}

class _PilihHalamanState extends State<PilihHalaman> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Dashboard(),
    //const TambahBatch(),
    const DataBatch(),
    const DataProcess(),
    const DataMargin(),
    const Laporan(),
  ];

  final List<String> _titles = [
    'Dashboard',
    //'Tambah Batch',
    'Data Batch',
    'Data Proses',
    'Hitung Margin',
    'Laporan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ================= APPBAR =================
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
                  builder: (context) =>
                      const HalamanProfil(),
                ),
              );
            },
            icon: const Icon(
              Icons.account_circle,
              size: 35,
              color: Colors.white,
            ),
          ),
        ],
      ),
      // ================= BODY =================

      body: _pages[_selectedIndex],

 // ================= NAVBAR BAWAH =================
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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.add_box),
          //   label: 'Tambah Batch',
          // ),
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
            label: 'Margin',
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


