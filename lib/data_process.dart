import 'package:flutter/material.dart';
import 'package:flutter_application_1/const_file.dart';
import 'package:flutter_application_1/services/get_batch.dart';
import 'package:flutter_application_1/services/check_batch.dart';
import 'package:flutter_application_1/services/edit_batch.dart';

class _KomposisiItem {
  final String label;
  final String beratAwal;
  final TextEditingController beratAkhirCtrl;
  final TextEditingController susutCtrl;

  _KomposisiItem({
    required this.label,
    required this.beratAwal,
    String beratAkhir = '0',
    String susut = '0',
  }) : beratAkhirCtrl = TextEditingController(text: beratAkhir),
       susutCtrl = TextEditingController(text: susut);

  double get beratAkhir => double.tryParse(beratAkhirCtrl.text) ?? 0;
  double get susut => double.tryParse(susutCtrl.text) ?? 0;

  void dispose() {
    beratAkhirCtrl.dispose();
    susutCtrl.dispose();
  }
}

class DataProcess extends StatefulWidget {
  const DataProcess({super.key});

  @override
  State<DataProcess> createState() => _DataProcessState();
}

class _DataProcessState extends State<DataProcess>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  String? errorMessage;
  String? selectedBatch;
  String? batchId;
  String? selectedMetodeCuci; // ← dipindah ke dalam class

  List<Map<String, dynamic>> dataBatch = [];
  List<Map<String, dynamic>> dataBatchDetail = [];
  final TextEditingController susutController = TextEditingController();
  List<_KomposisiItem> _komposisiItems = [];

  @override
  void initState() {
    super.initState();
    getBatchData();
  }

  void getBatchData() async {
    final data = await getAllBatch();
    print("Data Batch: $data");
    setState(() {
      dataBatch = data;
    });
  }

  void _onBarangChanged(String? value) async {
    if (value == null) return;

    // Dispose controller lama
    for (final item in _komposisiItems) {
      item.dispose();
    }

    // Cari data batch yang dipilih berdasarkan id
    final selectedData = dataBatch.firstWhere(
      (b) => b['id'].toString() == value,
      orElse: () => {},
    );
    

    // Gunakan nama barang sebagai key komposisiConfig
    // Sesuaikan 'name' dengan key yang ada di dataBatch kamu
    final namaBarang = selectedData['name']?.toString() ?? '';
    final labels = komposisiConfig[namaBarang] ?? [];

    // Ambil detail batch
    await _fetchBatchDetail(value);

    setState(() {
      selectedBatch = value;
      batchId = selectedData['id']?.toString() ?? '';
      print('data batch detail:$dataBatchDetail');
      _komposisiItems =
          labels.map((l) {
            final dataList = dataBatchDetail.where(
              (item) =>
                  item['komposisi'].toString().trim() ==
                  l.split(" ").last.toString().trim(),
            );

            print("Data untuk komposisi '$l': ${dataList.toList()}");

            final data = dataList.isNotEmpty ? dataList.first : null;

            return _KomposisiItem(
              label: l,
              beratAwal: (data?['berat'] ?? 0).toString(),
            );
          }).toList();
    });
  }

  Future<void> _fetchBatchDetail(String batchId) async {
    final data = await getBatchDetails(batchId);
    setState(() {
      dataBatchDetail = data;
    });
  }

  @override
  void dispose() {
    susutController.dispose();
    for (final item in _komposisiItems) {
      item.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Process'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Data Batch",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                value: selectedBatch,
                hint: const Text('Pilih Batch'),
                isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                items:
                    dataBatch.map((batch) {
                      return DropdownMenuItem<String>(
                        value: batch['id'].toString(),
                        child: Text(
                          "${batch['supplier']} - ${batch['name']} - ${batch['date']}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                onChanged: _onBarangChanged,
              ),
              const SizedBox(height: 10),
              const Text(
                "Metode Cuci",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                hint: const Text('Pilih Jenis Ongkos Cuci'),
                isExpanded: true,
                value: selectedMetodeCuci,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                items:
                    ['Cabut Kering', 'Cabut Basah', 'Cabut Setengah Basah']
                        .map(
                          (jenis) => DropdownMenuItem<String>(
                            value: jenis,
                            child: Text(jenis),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMetodeCuci = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Metode cuci harus dipilih';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),

              // Komposisi container — hanya tampil jika ada item
              if (_komposisiItems.isNotEmpty) ...[
                const Text(
                  "Komposisi",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade200),
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: const [
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Jenis",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Berat Awal",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Berat Akhir",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Susut",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      // Item rows
                      ..._komposisiItems.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            children: [
                              Expanded(flex: 3, child: Text(item.label)),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  initialValue: item.beratAwal,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Berat Awal',
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: item.beratAkhirCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Berat Akhir',
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      errorMessage =
                                          'Berat akhir tidak boleh kosong';
                                    } else if (double.tryParse(value) == null) {
                                      errorMessage =
                                          'Berat akhir harus berupa angka';
                                    } else if (double.tryParse(value)! >
                                        double.tryParse(item.beratAwal)!) {
                                      errorMessage =
                                          'Berat akhir tidak boleh lebih besar dari berat awal';
                                    }
                                  },
                                  onChanged: (_) => setState(() {
                                    final beratAkhir = item.beratAkhir;
                                    final beratAwal = double.tryParse(item.beratAwal) ?? 0;
                                    final susut = (beratAwal - beratAkhir) / beratAwal * 100;
                                    item.susutCtrl.text = susut.toStringAsFixed(2);
                                  }),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: item.susutCtrl,
                                  keyboardType: TextInputType.number,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Susut',
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Pesan jika batch sudah dipilih tapi komposisi kosong
              if (selectedBatch != null && _komposisiItems.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    border: Border.all(color: Colors.orange.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Komposisi tidak ditemukan untuk batch ini.\nPastikan nama barang sesuai dengan key di komposisiConfig.",
                    style: TextStyle(color: Colors.orange),
                  ),
                ),

              const SizedBox(height: 20),

              // Tombol simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _komposisiItems.isEmpty
                          ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Harap isikan semua data dengan lengkap',
                                ),
                              ),
                            );
                          }
                          : () async{
                            if (errorMessage == null || errorMessage! == "") {
                              await editBatchWithDetails(
                                batchId: "${batchId}_${_komposisiItems[0].label.split(' ').last}",
                                metodeCuci: selectedMetodeCuci ?? '',
                                komposisi: _komposisiItems[0].label.split(" ").last, 
                                beratAkhir: _komposisiItems[0].beratAkhir.toString(),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Data berhasil disimpan'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMessage!),
                                ),
                              );
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Simpan",
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
