import 'package:flutter/material.dart';
import 'services/get_batch.dart';

// ─── Helpers ────────────────────────────────────────────────────────────────

/// Pilih warna avatar berdasarkan huruf pertama nama supplier
Color _avatarBg(String name) {
  const colors = [
    Color(0xFFE3F2FD),
    Color(0xFFE1F5EE),
    Color(0xFFFAEEDA),
    Color(0xFFFBEAF0),
    Color(0xFFEAF3DE),
  ];
  return colors[name.codeUnitAt(0) % colors.length];
}

Color _avatarFg(String name) {
  const colors = [
    Color(0xFF0D47A1),
    Color(0xFF085041),
    Color(0xFF633806),
    Color(0xFF4B1528),
    Color(0xFF27500A),
  ];
  return colors[name.codeUnitAt(0) % colors.length];
}

// ─── Main Page ───────────────────────────────────────────────────────────────

class DataBatch extends StatefulWidget {
  const DataBatch({super.key});

  @override
  State<DataBatch> createState() => _DataBatchState();
}

class _DataBatchState extends State<DataBatch> {
  List<Map<String, dynamic>> _batches = [];
  List<Map<String, dynamic>> _batchDetails = [];
  List<Map<String, dynamic>> _filtered = [];
  bool _isLoading = true;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    final batches = await getAllBatch();
    final details = <Map<String, dynamic>>[];
    for (final b in batches) {
      details.addAll(await getBatchDetails(b['id']));
    }
    if (!mounted) return;
    setState(() {
      _batches = batches;
      _batchDetails = details;
      _filtered = batches;
      _isLoading = false;
    });
  }

  void _onSearch() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = _batches
          .where((b) =>
              b['supplier'].toString().toLowerCase().contains(q) ||
              b['name'].toString().toLowerCase().contains(q))
          .toList();
    });
  }

  /// Hitung jumlah komposisi untuk satu batch
  int _detailCount(dynamic batchId) =>
      _batchDetails.where((d) => d['batch_id'] == batchId).length;

  // ── Summary ──────────────────────────────────────────────────────────────

  Widget _buildSummary() {
    final totalBerat = _batchDetails.fold<double>(
      0,
      (sum, d) => sum + ((d['berat'] as num?)?.toDouble() ?? 0),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: [
          Expanded(child: _StatCard(label: 'Total Batch', value: '${_batches.length}', sub: 'tercatat')),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              label: 'Total Berat',
              value: totalBerat >= 1000
                  ? '${(totalBerat / 1000).toStringAsFixed(1)}t'
                  : '${totalBerat.toStringAsFixed(0)} kg',
              sub: 'semua komposisi',
            ),
          ),
        ],
      ),
    );
  }

  // ── List ─────────────────────────────────────────────────────────────────

  Widget _buildList() {
    if (_filtered.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 10),
            Text('Tidak ada data batch', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 80),
      itemCount: _filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final batch = _filtered[index];
        final count = _detailCount(batch['id']);
        return _BatchCard(
          batch: batch,
          detailCount: count,
          onTap: () {
            final details = _batchDetails
                .where((d) => d['batch_id'] == batch['id'])
                .toList();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BatchDetails(
                  batch: batch,
                  batchDetails: details,
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Data Batch',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: navigasi ke halaman tambah batch
        },
        backgroundColor: const Color(0xFF1565C0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // ── Search bar ──────────────────────────────────────────────────
          Container(
            color: const Color(0xFF1565C0),
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: TextField(
              controller: _searchCtrl,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Cari supplier atau nama batch...',
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ── Body ────────────────────────────────────────────────────────
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFF1565C0)),
                        SizedBox(height: 12),
                        Text('Memuat data...', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummary(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 2, 0, 4),
                        child: Text(
                          '${_filtered.length} batch ditemukan',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      Expanded(child: _buildList()),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Stat Card ───────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.sub});

  final String label;
  final String value;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
          Text(sub, style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}

// ─── Batch Card ──────────────────────────────────────────────────────────────

class _BatchCard extends StatelessWidget {
  const _BatchCard({
    required this.batch,
    required this.detailCount,
    required this.onTap,
  });

  final Map<String, dynamic> batch;
  final int detailCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final supplier = batch['supplier'] as String;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200, width: 0.5),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _avatarBg(supplier),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                supplier[0].toUpperCase(),
                style: TextStyle(
                  color: _avatarFg(supplier),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    supplier,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    batch['name'] as String,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),

            // Right side
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  batch['date'] as String,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                ),
                const SizedBox(height: 4),
                if (detailCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$detailCount komposisi',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: Colors.grey.shade300, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── Detail Page ─────────────────────────────────────────────────────────────

class BatchDetails extends StatelessWidget {
  const BatchDetails({
    super.key,
    required this.batch,
    required this.batchDetails,
  });

  final Map<String, dynamic> batch;
  final List<Map<String, dynamic>> batchDetails;

  double get _totalBerat => batchDetails.fold(
        0,
        (sum, d) => sum + ((d['berat'] as num?)?.toDouble() ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final supplier = batch['supplier'] as String;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Detail Batch',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // ── Header card ───────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200, width: 0.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _avatarBg(supplier),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    supplier[0].toUpperCase(),
                    style: TextStyle(
                      color: _avatarFg(supplier),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(supplier,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(batch['name'] as String,
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ── Info row ──────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  icon: Icons.tag_rounded,
                  label: 'ID Batch',
                  value: '${batch['id']}',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _InfoTile(
                  icon: Icons.calendar_today_outlined,
                  label: 'Tanggal',
                  value: batch['date'] as String,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Summary row ───────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  icon: Icons.science_outlined,
                  label: 'Komposisi',
                  value: '${batchDetails.length} item',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _InfoTile(
                  icon: Icons.scale_outlined,
                  label: 'Total Berat',
                  value: '${_totalBerat.toStringAsFixed(1)} kg',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Komposisi list ────────────────────────────────────────────
          const Text(
            'Detail Komposisi',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),

          if (batchDetails.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200, width: 0.5),
              ),
              child: const Center(
                child: Text('Tidak ada detail komposisi',
                    style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ...batchDetails.asMap().entries.map((entry) {
              final i = entry.key;
              final d = entry.value;
              final berat = (d['berat'] as num?)?.toDouble() ?? 0;
              final pct = _totalBerat > 0 ? berat / _totalBerat : 0.0;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            d['komposisi'] as String,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          '${berat.toStringAsFixed(1)} kg',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct,
                        minHeight: 5,
                        backgroundColor: Colors.grey.shade100,
                        valueColor: const AlwaysStoppedAnimation(Color(0xFF1565C0)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(pct * 100).toStringAsFixed(1)}% dari total berat',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

// ─── Info Tile ────────────────────────────────────────────────────────────────

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF1565C0)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}