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
  int hargaBeli = 0;

  TextEditingController ongkosCuciCtrl = TextEditingController(text: "0");
  TextEditingController ongkosKirimCtrl = TextEditingController(text: "0");
  TextEditingController biayaLainCtrl = TextEditingController(text: "0");
  TextEditingController hargaJualCtrl = TextEditingController(text: "0");

  // FIX 1: Hitung totalBiaya secara dinamis dari nilai controller
  int get totalBiaya {
    final cuci = int.tryParse(ongkosCuciCtrl.text) ?? 0;
    final kirim = int.tryParse(ongkosKirimCtrl.text) ?? 0;
    final lain = int.tryParse(biayaLainCtrl.text) ?? 0;
    return cuci + kirim + lain;
  }

  int get hargaJual => int.tryParse(hargaJualCtrl.text) ?? 0;

  int get profit => hargaJual - totalBiaya - hargaBeli;

  // FIX 2: Hindari division by zero
  double get marginPersen => hargaJual == 0 ? 0 : (profit / hargaJual) * 100;

  @override
  void initState() {
    super.initState();
    _getBatchData();

    // FIX 3: Tambahkan listener agar UI kalkulasi terupdate saat input berubah
    ongkosCuciCtrl.addListener(_onFieldChanged);
    ongkosKirimCtrl.addListener(_onFieldChanged);
    biayaLainCtrl.addListener(_onFieldChanged);
    hargaJualCtrl.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {});
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

  // FIX 4: Validator yang benar menggunakan int.tryParse
  String? _validateAngka(String? value) {
    if (value == null || value.isEmpty) {
      return 'Wajib diisi';
    }
    if (int.tryParse(value) == null) {
      return 'Harus berupa angka';
    }
    return null;
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
                  hint: const Text('Pilih Batch'),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  items:
                      batch
                          .map(
                            (b) => DropdownMenuItem(
                              value: "${b["id"]}",
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
                  onChanged: (value) async {
                    List<Map<String, dynamic>> temp = await getBatchDetails(
                      value!,
                    );
                    int totalHarga = 0;
                    if (temp.isNotEmpty) {
                      for (var detail in temp) {
                        if (detail['batch_id'] == value) {
                          totalHarga +=
                              int.tryParse(detail['harga'].toString()) ?? 0;
                        }
                      }
                      print("Total Harga Beli: $totalHarga");
                    }
                    setState(() {
                      selectedBatch = value;
                      hargaBeli = totalHarga;
                    });
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
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'Masukkan Harga Jual',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateAngka,
                ),

                SizedBox(height: 20),

                const Text(
                  "Ongkos Cuci (Rp)",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: ongkosCuciCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'Masukkan Ongkos Cuci',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateAngka,
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
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'Masukkan Ongkos Kirim',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateAngka,
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
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'Masukkan Biaya Lain',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateAngka,
                ),
                const SizedBox(height: 28),

                if (selectedBatch != null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Perhitungan Margin",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue.shade200),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue.shade50,
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.blue.shade700,
                              ),
                              child: const Text(
                                "Total Biaya",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // FIX 5: Gunakan getter totalBiaya
                            Text("Total Biaya : Rp $totalBiaya"),

                            const SizedBox(height: 15),

                            const SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.blue.shade700,
                              ),
                              child: const Text(
                                "Harga Jual",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text("Harga Jual : Rp $hargaJual"),

                            SizedBox(height: 15),

                            const SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.blue.shade700,
                              ),
                              child: const Text(
                                "Harga Beli",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text("Harga Beli : Rp $hargaBeli"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.blue.shade700,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Profit",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                // FIX 6: Gunakan getter profit
                                Text(
                                  "Rp $profit",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 1,
                              height: 36,
                              color: Colors.white38,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Margin",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                // FIX 7: Gunakan getter marginPersen, format 2 desimal
                                Text(
                                  "${marginPersen.toStringAsFixed(2)}%",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        
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
