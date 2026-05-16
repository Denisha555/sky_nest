import 'package:flutter/material.dart';
import 'package:flutter_application_1/const_file.dart';
import 'package:flutter_application_1/services/get_batch.dart';
import 'package:flutter_application_1/services/check_batch.dart';
import 'package:flutter_application_1/services/edit_batch.dart';

// ─────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────

class _KomposisiItem {
  final String label;
  final double beratAwalValue;
  final TextEditingController beratAkhirCtrl;
  final TextEditingController susutCtrl;

  _KomposisiItem({
    required this.label,
    required this.beratAwalValue,
  })  : beratAkhirCtrl = TextEditingController(text: '0'),
        susutCtrl = TextEditingController(text: '0');

  String get beratAwalString => beratAwalValue.toStringAsFixed(2);
  double get beratAkhir => double.tryParse(beratAkhirCtrl.text) ?? 0;

  void recalcSusut() {
    if (beratAwalValue <= 0) {
      susutCtrl.text = '0';
      return;
    }
    final susut = (beratAwalValue - beratAkhir) / beratAwalValue * 100;
    susutCtrl.text = susut.toStringAsFixed(0);
  }

  void dispose() {
    beratAkhirCtrl.dispose();
    susutCtrl.dispose();
  }
}

// ─────────────────────────────────────────────
// Widget
// ─────────────────────────────────────────────

class DataProcess extends StatefulWidget {
  const DataProcess({super.key});

  @override
  State<DataProcess> createState() => _DataProcessState();
}

class _DataProcessState extends State<DataProcess> {
  static const _metodeCuciOptions = [
    'Cabut Kering',
    'Cabut Basah',
    'Cabut Setengah Basah',
  ];

  final _formKey = GlobalKey<FormState>();

  String? _selectedBatchId;
  String? _selectedMetodeCuci;
  bool _isLoading = false;
  bool _isSaving = false;

  List<Map<String, dynamic>> _dataBatch = [];
  List<_KomposisiItem> _komposisiItems = [];

  // ── Lifecycle ────────────────────────────────

  @override
  void initState() {
    super.initState();
    _loadBatches();
  }

  @override
  void dispose() {
    _disposeItems();
    super.dispose();
  }

  // ── Data loading ─────────────────────────────

  Future<void> _loadBatches() async {
    setState(() => _isLoading = true);
    try {
      final data = await getAllBatch();
      setState(() => _dataBatch = data);
    } catch (e) {
      _showError('Gagal memuat data batch: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onBatchChanged(String? batchId) async {
    if (batchId == null) return;

    _disposeItems();
    setState(() {
      _selectedBatchId = batchId;
      _komposisiItems = [];
      _isLoading = true;
    });

    try {
      final selectedBatch = _dataBatch.firstWhere(
        (b) => b['id'].toString() == batchId,
        orElse: () => {},
      );

      final namaBarang = selectedBatch['name']?.toString() ?? '';
      final labels = komposisiWajibConfig[namaBarang] ?? [];
      final detail = await getBatchDetails(batchId);

      final items = labels.map((label) {
        final key = label.split(' ').last.trim();
        final match = detail.firstWhere(
          (d) => d['komposisi'].toString().trim() == key,
          orElse: () => {},
        );
        final berat =
            double.tryParse(match['berat']?.toString() ?? '') ?? 0.0;
        return _KomposisiItem(label: label, beratAwalValue: berat);
      }).toList();

      setState(() => _komposisiItems = items);
    } catch (e) {
      _showError('Gagal memuat detail batch: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ── Save ─────────────────────────────────────

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      for (final item in _komposisiItems) {
        final komposisiKey = item.label.split(' ').last;
        await editBatchWithDetails(
          batchId: '${_selectedBatchId}_$komposisiKey',
          metodeCuci: _selectedMetodeCuci!,
          komposisi: komposisiKey,
          beratAkhir: item.beratAkhir.toString(),
        );
      }
      if (mounted) {
        _showSuccess('Data berhasil disimpan');
        Navigator.pop(context);
      }
    } catch (e) {
      _showError('Gagal menyimpan data: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ── Helpers ───────────────────────────────────

  void _disposeItems() {
    for (final item in _komposisiItems) {
      item.dispose();
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Build ─────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Data Process',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor:  const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.grey.shade200),
        ),
      ),
      body: _isLoading && _dataBatch.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCard(
                      children: [
                        _buildSectionTitle('Data Batch'),
                        const SizedBox(height: 8),
                        _buildBatchDropdown(),
                        const SizedBox(height: 16),
                        _buildSectionTitle('Metode Cuci'),
                        const SizedBox(height: 8),
                        _buildMetodeDropdown(),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildKomposisiSection(),
                    const SizedBox(height: 20),
                    _buildSaveButton(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  // ── Sub-builders ──────────────────────────────

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.black87,
        ),
      );

  Widget _buildBatchDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedBatchId,
      hint: const Text('Pilih Batch'),
      isExpanded: true,
      decoration: _inputDecoration(),
      items: _dataBatch.map((batch) {
        return DropdownMenuItem<String>(
          value: batch['id'].toString(),
          child: Text(
            '${batch['supplier']} – ${batch['name']} – ${batch['date']}',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
      onChanged: _isLoading ? null : _onBatchChanged,
      validator: (v) => v == null ? 'Batch harus dipilih' : null,
    );
  }

  Widget _buildMetodeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedMetodeCuci,
      hint: const Text('Pilih Metode Cuci'),
      isExpanded: true,
      decoration: _inputDecoration(),
      items: _metodeCuciOptions
          .map((m) => DropdownMenuItem(value: m, child: Text(m)))
          .toList(),
      onChanged: (v) => setState(() => _selectedMetodeCuci = v),
      validator: (v) => v == null ? 'Metode cuci harus dipilih' : null,
    );
  }

  Widget _buildKomposisiSection() {
    if (_isLoading && _selectedBatchId != null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_selectedBatchId != null && _komposisiItems.isEmpty) {
      return _buildCard(children: [
        Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange.shade600),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Komposisi tidak ditemukan untuk batch ini.',
                style: TextStyle(color: Colors.orange.shade800, fontSize: 14),
              ),
            ),
          ],
        ),
      ]);
    }

    if (_komposisiItems.isEmpty) return const SizedBox.shrink();

    return _buildCard(children: [
      _buildSectionTitle('Komposisi'),
      const SizedBox(height: 12),
      // Header
      _buildKomposisiHeader(),
      Divider(color: Colors.grey.shade200),
      // Rows
      ..._komposisiItems.map(_buildKomposisiRow),
    ]);
  }

  Widget _buildKomposisiHeader() {
    const headerStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 12,
      color: Colors.black54,
    );
    return Row(
      children: const [
        Expanded(flex: 3, child: Text('Jenis', style: headerStyle)),
        SizedBox(width: 8),
        Expanded(flex: 3, child: Text('Berat Awal', style: headerStyle)),
        SizedBox(width: 8),
        Expanded(flex: 3, child: Text('Berat Akhir', style: headerStyle)),
        SizedBox(width: 8),
        Expanded(flex: 2, child: Text('Susut %', style: headerStyle)),
      ],
    );
  }

  Widget _buildKomposisiRow(_KomposisiItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Jenis
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(item.label, style: const TextStyle(fontSize: 13)),
            ),
          ),
          const SizedBox(width: 8),
          // Berat Awal (read-only)
          Expanded(
            flex: 3,
            child: TextFormField(
              initialValue: item.beratAwalString,
              readOnly: true,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
              decoration: _inputDecoration(hint: 'Berat awal'),
            ),
          ),
          const SizedBox(width: 8),
          // Berat Akhir
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: item.beratAkhirCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(fontSize: 13),
              decoration: _inputDecoration(hint: 'Berat akhir'),
              onChanged: (_) => setState(() => item.recalcSusut()),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Wajib diisi';
                final parsed = double.tryParse(v);
                if (parsed == null) return 'Harus angka';
                if (parsed < 0) return 'Tidak boleh negatif';
                // if (parsed > item.beratAwalValue) {
                //   return '> berat awal';
                // }
                return null;
              },
            ),
          ),
          const SizedBox(width: 8),
          // Susut (read-only)
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: item.susutCtrl,
              readOnly: true,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
              decoration: _inputDecoration(hint: '%'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    final canSave = _komposisiItems.isNotEmpty;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: canSave && !_isSaving ? _save : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          disabledBackgroundColor: Colors.grey.shade300,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: _isSaving
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Simpan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        filled: true,
        fillColor: Colors.grey.shade50,
        errorStyle: const TextStyle(fontSize: 10),
      );
}