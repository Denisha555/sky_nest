import 'package:flutter/material.dart';
import 'package:flutter_application_1/const_file.dart';
import 'package:flutter_application_1/services/add_batch.dart';
import 'package:flutter_application_1/constant_file.dart';

class _KomposisiItem {
  final String label;
  final TextEditingController beratCtrl;
  final TextEditingController hargaCtrl;

  _KomposisiItem({
    required this.label,
    String berat = '0',
    String harga = '0',
  })  : beratCtrl = TextEditingController(text: berat),
        hargaCtrl = TextEditingController(text: harga);

  double get berat => double.tryParse(beratCtrl.text) ?? 0;
  double get harga => double.tryParse(hargaCtrl.text) ?? 0;
  double get subtotal => berat * harga;

  void dispose() {
    beratCtrl.dispose();
    hargaCtrl.dispose();
  }
}

class _KomposisiRow extends StatelessWidget {
  final _KomposisiItem item;
  final VoidCallback onChanged;

  const _KomposisiRow({required this.item, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            item.label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildField(
                controller: item.beratCtrl,
                label: 'Berat (kg)',
                hint: '0',
                onChanged: onChanged,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Wajib diisi';
                  if (double.tryParse(v) == null) return 'Harus angka';
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildField(
                controller: item.hargaCtrl,
                label: 'Harga/Kg (Rp)',
                hint: '0',
                onChanged: onChanged,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Wajib diisi';
                  if (double.tryParse(v) == null) return 'Harus angka';
                  return null;
                },
              ),
            ),
          ],
        ),
        // Subtotal per komposisi
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Subtotal: Rp ${_formatRupiah(item.subtotal)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue.shade800,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required VoidCallback onChanged,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) => onChanged(),
      validator: validator,
    );
  }
}

class _KomposisiCard extends StatelessWidget {
  final List<_KomposisiItem> items;
  final VoidCallback onChanged;

  const _KomposisiCard({required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue.shade50,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map((item) => _KomposisiRow(item: item, onChanged: onChanged))
            .toList(),
      ),
    );
  }
}

class _TotalSummary extends StatelessWidget {
  final List<_KomposisiItem> items;

  const _TotalSummary({required this.items});

  @override
  Widget build(BuildContext context) {
    final totalBerat = items.fold(0.0, (sum, i) => sum + i.berat);
    final totalHarga = items.fold(0.0, (sum, i) => sum + i.subtotal);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: _summaryTile(
              label: 'Total Berat',
              value: '${totalBerat.toStringAsFixed(2)} kg',
            ),
          ),
          Container(width: 1, height: 36, color: Colors.white38),
          Expanded(
            child: _summaryTile(
              label: 'Total Harga',
              value: 'Rp ${_formatRupiah(totalHarga)}',
              valueColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryTile({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

String _formatRupiah(double value) {
  final parts = value.toStringAsFixed(0).split('');
  final result = StringBuffer();
  for (int i = 0; i < parts.length; i++) {
    if (i != 0 && (parts.length - i) % 3 == 0) result.write('.');
    result.write(parts[i]);
  }
  return result.toString();
}

class TambahBatch extends StatefulWidget {
  const TambahBatch({super.key});

  @override
  State<TambahBatch> createState() => _TambahBatchState();
}

class _TambahBatchState extends State<TambahBatch> {
  final _formKey = GlobalKey<FormState>();

  final tanggalBeliController = TextEditingController();
  final supplierController = TextEditingController();
  final kadarAirController = TextEditingController();

  String? selectedNamaBarang;
  List<_KomposisiItem> _komposisiItems = [];

  // ── Ganti barang → rebuild komposisi ──
  void _onBarangChanged(String? value) {
    for (final item in _komposisiItems) {
      item.dispose();
    }
    final labels = komposisiConfig[value] ?? [];
    setState(() {
      selectedNamaBarang = value;
      _komposisiItems =
          labels.map((l) => _KomposisiItem(label: l)).toList();
    });
  }

  void _refreshTotals() => setState(() {});

  @override
  void dispose() {
    tanggalBeliController.dispose();
    supplierController.dispose();
    kadarAirController.dispose();
    for (final item in _komposisiItems) {
      item.dispose();
    }
    super.dispose();
  }

  // ── Submit ──
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final details = _komposisiItems.map((item) {
      // Ambil label komposisi terakhir (A/B/C atau nama barang)
      final komposisi = item.label.contains(' ')
          ? item.label.split(' ').last
          : item.label;
      return {
        'komposisi': komposisi,
        'berat': item.berat,
        'harga': item.subtotal,
      };
    }).toList();

    final batchId = await addBatchWithDetails(
      batchName: selectedNamaBarang!,
      date: detailDateToStringDate(tanggalBeliController.text),
      supplier: supplierController.text,
      kadarAir: kadarAirController.text,
      details: details,
    );

    if (!mounted) return;

    if (batchId != null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Batch berhasil ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menambahkan batch, coba lagi'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ── Section label helper ──
  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Batch'),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Tanggal Beli ──
              _sectionLabel('Tanggal Beli'),
              TextFormField(
                controller: tanggalBeliController,
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: 'Pilih tanggal beli',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                  isDense: true,
                ),
                onTap: () => showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                ).then((date) {
                  if (date != null) {
                    setState(() {
                      tanggalBeliController.text = dateToDetailDate(date);
                    });
                  }
                }),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Tanggal beli harus diisi' : null,
              ),
              const SizedBox(height: 14),

              // ── Supplier ──
              _sectionLabel('Supplier'),
              TextFormField(
                controller: supplierController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan nama supplier',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Nama supplier harus diisi' : null,
              ),
              const SizedBox(height: 14),

              // ── Nama Barang ──
              _sectionLabel('Nama Barang'),
              DropdownButtonFormField<String>(
                value: selectedNamaBarang,
                hint: const Text('Pilih nama barang'),
                isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                items: komposisiConfig.keys
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: _onBarangChanged,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Nama barang harus dipilih' : null,
              ),
              const SizedBox(height: 14),

              // ── Kadar Air ──
              _sectionLabel('Kadar Air (%)'),
              TextFormField(
                controller: kadarAirController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan kadar air',
                  border: OutlineInputBorder(),
                  suffixText: '%',
                  isDense: true,
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Kadar air harus diisi';
                  if (double.tryParse(v) == null) return 'Harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // ── Komposisi ──
              if (_komposisiItems.isNotEmpty) ...[
                _sectionLabel('Komposisi'),
                _KomposisiCard(
                  items: _komposisiItems,
                  onChanged: _refreshTotals,
                ),
                const SizedBox(height: 8),
                // Total ringkasan
                _TotalSummary(items: _komposisiItems),
                const SizedBox(height: 20),
              ] else
                const SizedBox(height: 6),

              // ── Tombol Simpan ──
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  label: const Text(
                    'Simpan',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}