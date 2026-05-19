import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/get_batch.dart';

class DataMargin extends StatefulWidget {
  const DataMargin({super.key});

  @override
  State<DataMargin> createState() => _DataMarginState();
}

class _DataMarginState extends State<DataMargin> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> batch = [];

  String? selectedBatch;
  TextEditingController ongkosCuciCtrl = TextEditingController(text: "0");
  TextEditingController ongkosKirimCtrl = TextEditingController(text: "0");
  TextEditingController biayaLainCtrl = TextEditingController(text: "0");
  TextEditingController hargaJualCtrl = TextEditingController(text: "0");

  @override
  void initState() {
    super.initState();
    _getBatchData();
  }

  Future<void> _getBatchData() async {
    final temp = await getAllBatch();
    setState(() {
      batch = temp;
    });
  }

  @override
  void dispose() {
    ongkosCuciCtrl.dispose();
    ongkosKirimCtrl.dispose();
    biayaLainCtrl.dispose();
    hargaJualCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Data Batch",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: selectedBatch,
                  hint: Text('Pilih Batch'),
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  items:
                      batch
                          .map(
                            (b) => DropdownMenuItem(
                              value:
                                  "${b['supplier']} - ${b['name']} - ${b['date']}",
                              child: Text(
                                "${b['supplier']} - ${b['name']} - ${b['date']}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          )
                          .toList(),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Pilih batch terlebih dahulu'
                              : null,
                  onChanged: (value) {
                    setState(() {
                      selectedBatch = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Ongkos Cuci (Rp)",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: ongkosCuciCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Masukkan Ongkos Cuci',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Wajib diisi';
                    } else if (int.parse(value) == Null) {
                      return 'Harus berupa angka';
                    }
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Ongkos Kirim (Rp)",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: ongkosKirimCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Masukkan Ongkos Kirim',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Wajib diisi';
                    } else if (int.parse(value) == null) {
                      return 'Harus berupa angka';
                    }
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Biaya Lain (Rp)",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: biayaLainCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Masukkan Biaya Lain',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Wajib diisi';
                    } else if (int.parse(value) == null) {
                      return 'Harus berupa angka';
                    }
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Harga Jual (Rp)",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: hargaJualCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Masukkan Harga Jual',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Wajib diisi';
                    } else if (int.parse(value) == null) {
                      return 'Harus berupa angka';
                    }
                  },
                ),
                const SizedBox(height: 28),

                if (selectedBatch != null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Perhitungan Margin", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,), textAlign: TextAlign.start,),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue.shade200),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue.shade50,
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Container(
                              
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.blue.shade800,
                              ),
                              child: Text("Total Biaya")
                            )
                          ]
                        ),
                      ),
                      SizedBox(height: 20,)
                    ],
                  ),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // aksi simpan
                      }
                    },
                    label: const Text('Simpan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
