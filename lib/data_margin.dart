import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/add_expenses.dart';
import 'package:flutter_application_1/services/edit_batch.dart';
import 'package:flutter_application_1/services/get_batch.dart';
import 'package:flutter_application_1/services/get_margin.dart';
import 'package:flutter_application_1/services/delete_margin.dart';

class DataMargin extends StatefulWidget {
  const DataMargin({super.key});

  @override
  State<DataMargin> createState() => _DataMarginState();
}

//
class _DataMarginState extends State<DataMargin>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> batch = [];
  List<Map<String, dynamic>> allBatch = [];
  List<Map<String, dynamic>> _marginData = [];

  // int _selectedTab = 0;
  late TabController _tabController;

  String? selectedBatch;
  // mode edit
  bool _isEdit = false;
  String? _editMarginId;
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

    _tabController = TabController(length: 2, vsync: this);

    _getBatchData();
    _loadMarginData();

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
    final temp = await getAvailableBatchForMargin();
    final all = await getAllBatchForMargin();
    setState(() {
      batch = temp;
      allBatch = all;
    });
  }

  Future<void> _loadMarginData() async {
    try {
      final data = await getMarginData();

      setState(() {
        _marginData = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();

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
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: const [
                Tab(text: "Input Data"),
                Tab(text: "Data Tersimpan"),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildInputTab(), _buildDataTersimpanTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTersimpanTab() {
    if (_marginData.isEmpty) {
      return const Center(child: Text("Belum ada data margin"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _marginData.length,
      itemBuilder: (context, index) {
        final item = _marginData[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${item['supplier']} - ${item['name']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 8),

                Text("Harga Jual : Rp ${item['harga_jual'] ?? 0}"),

                Text("Profit : Rp ${item['profit'] ?? 0}"),

                const SizedBox(height: 12),

                //button  edit dan detail
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.delete),
                      label: const Text("Hapus", style: TextStyle()),
                      onPressed: () {
                        _showDeleteDialog(item);
                      },
                    ),

                    const SizedBox(width: 8),

                    ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit"),

                      onPressed: () {
                        setState(() {
                          _isEdit = true;

                          _editMarginId = item['id'].toString();

                          //tampilkan batch lama
                          selectedBatch = item['id']?.toString();

                          // isi semua form
                          hargaJualCtrl.text =
                              (item['harga_jual'] ?? 0).toString();

                          ongkosCuciCtrl.text =
                              (item['ongkos_cuci'] ?? 0).toString();

                          ongkosKirimCtrl.text =
                              (item['ongkos_kirim'] ?? 0).toString();

                          biayaLainCtrl.text =
                              (item['biaya_lain'] ?? 0).toString();

                          //selectedBatch = null;
                        });

                        _tabController.animateTo(0);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditDialog(Map<String, dynamic> item) {
    final hargaJualCtrl = TextEditingController(
      text: item['harga_jual'].toString(),
    );

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Edit Margin"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Supplier : ${item['supplier']}"),
                Text("Batch : ${item['name']}"),

                const SizedBox(height: 15),

                TextField(
                  controller: hargaJualCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Harga Jual",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final hargaJual = int.tryParse(hargaJualCtrl.text) ?? 0;

                  await editBatch(
                    field: "harga_jual",
                    value: hargaJual,
                    batchId: item['id'].toString(),
                  );

                  Navigator.pop(context);

                  await _loadMarginData();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Data berhasil diupdate")),
                  );
                },
                child: const Text("Update"),
              ),
            ],
          ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Konfirmasi Hapus"),
            content: Text(
              "Apakah Anda yakin ingin menghapus data margin ${item['name']} ?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  await deleteMargin(item['id'].toString());

                  Navigator.pop(context);

                  await _loadMarginData();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Data berhasil dihapus")),
                  );
                },
                child: const Text(
                  "Hapus",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _onBatchChanged(String? batchId) async {
    if (batchId == null) return;

    setState(() {
      selectedBatch = batchId;
    });

    try {
      final matched = allBatch.firstWhere(
        (b) => b['id'].toString() == batchId,
        orElse: () => {},
      );

      if (matched.isEmpty) {
        print('Tidak ditemukan batch dengan id: $batchId');
        return;
      }

      final batchDetail = await getBatchDetails(batchId);
      for (var detail in batchDetail) {
        hargaBeli =
            hargaBeli +
            ((detail['harga'] ?? 0) * (detail['berat'] ?? 0) as num).toInt();
      }

      final hargaJual = matched['harga_jual'] ?? 0;

      int ongkosCuci = 0;
      int ongkosKirim = 0;
      int biayaLain = 0;
      if (matched['expenses'].length > 0) {
        for (var data in matched['expenses'].length - 1) {
          if (data['name'] == 'ongkos_cuci') {
            ongkosCuci = matched['ongkos_cuci'] ?? 0;
          } else if (data['name'] == 'ongkos_kirim') {
            ongkosKirim = matched['ongkos_kirim'] ?? 0;
          } else if (data['name'] == 'biaya_lain') {
            biayaLain = matched['biaya_lain'] ?? 0;
          }
        }
      }

      hargaJualCtrl.text = hargaJual.toString();
      ongkosCuciCtrl.text = ongkosCuci.toString();
      ongkosKirimCtrl.text = ongkosKirim.toString();
      biayaLainCtrl.text = biayaLain.toString();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat data: $e")));
    }
  }

  void _showDetailDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Detail Margin"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Supplier : ${item['supplier']}"),
                Text("Batch : ${item['name']}"),
                Text("Harga Jual : Rp ${item['harga_jual']}"),
                Text("Profit : Rp ${item['profit']}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Tutup"),
              ),
            ],
          ),
    );
  }

  Widget _buildInputTab() {
    List<Map<String, dynamic>> data = [];
    if (_isEdit) {
      data = allBatch;
    } else {
      data = batch;
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                    data
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

                onChanged: _onBatchChanged,
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_isEdit) {
                        // MODE EDIT
                        await editBatch(
                          field: "harga_jual",
                          value: hargaJual,
                          batchId: _editMarginId!,
                        );

                        await editBatch(
                          field: "profit",
                          value: profit,
                          batchId: _editMarginId!,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Data berhasil diubah')),
                        );

                        setState(() {
                          _isEdit = false;
                          _editMarginId = null;
                        });
                      } else {
                        // MODE SIMPAN BARU
                        await editBatch(
                          field: "harga_jual",
                          value: hargaJual,
                          batchId: selectedBatch!,
                        );

                        await editBatch(
                          field: "profit",
                          value: profit,
                          batchId: selectedBatch!,
                        );

                        await addExpense(
                          "ongkos cuci",
                          int.parse(ongkosCuciCtrl.text),
                          selectedBatch!,
                        );

                        await addExpense(
                          "ongkos kirim",
                          int.parse(ongkosKirimCtrl.text),
                          selectedBatch!,
                        );

                        await addExpense(
                          "biaya lain",
                          int.parse(biayaLainCtrl.text),
                          selectedBatch!,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data berhasil disimpan'),
                          ),
                        );
                      }

                      await _loadMarginData();
                      _tabController.animateTo(1);
                    }
                  },
                  label: Text(_isEdit ? 'Ubah' : 'Simpan'),
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
    );
  }
}
