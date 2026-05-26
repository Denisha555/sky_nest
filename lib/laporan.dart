import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/get_batch.dart';
import 'package:flutter_application_1/services/check_batch.dart';

import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import 'package:fl_chart/fl_chart.dart';

class Laporan extends StatefulWidget {
  const Laporan({super.key});

  @override
  State<Laporan> createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  List<Map<String, dynamic>> batches = [];
  List<Map<String, dynamic>> detailData = [];

  double totalPembelian = 0;
  double totalPenjualan = 0;
  double totalPengeluaran = 0;
  double totalProfit = 0;
  double marginProfit = 0;

  @override
  void initState() {
    super.initState();
    loadLaporan();
  }

  Future<void> loadLaporan() async {
    final dataBatch = await getAllBatch();

    double pembelian = 0;
    double penjualan = 0;
    double pengeluaran = 0;

    List<Map<String, dynamic>> details = [];

    for (var batch in dataBatch) {
      final batchId = batch['id'].toString();

      final detail = await getBatchDetails(batchId);

      details.addAll(detail);

      for (var item in detail) {
        final harga =
            double.tryParse(item['harga'].toString()) ?? 0;

        pembelian += harga;
      }
    }

    // otomatis
    penjualan = pembelian * 1.25;

    pengeluaran = pembelian * 0.05;

    final profit =
        penjualan - pembelian - pengeluaran;

    final double margin =
        penjualan == 0
            ? 0.0
            : ((profit / penjualan) * 100)
                .toDouble();

    setState(() {
      batches = dataBatch;
      detailData = details;

      totalPembelian = pembelian;
      totalPenjualan = penjualan;
      totalPengeluaran = pengeluaran;
      totalProfit = profit;
      marginProfit = margin;
    });
  }

  String rupiah(double value) {
    return value
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  // ================= EXPORT PDF =================

  Future<void> printLaporan() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,

        build: (context) => [
          pw.Text(
            'Laporan Profit',
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 20),

          pw.Table(
            border: pw.TableBorder.all(),

            children: [
              tableRow(
                'Total Pembelian',
                'Rp ${rupiah(totalPembelian)}',
              ),

              tableRow(
                'Total Penjualan',
                'Rp ${rupiah(totalPenjualan)}',
              ),

              tableRow(
                'Total Pengeluaran',
                'Rp ${rupiah(totalPengeluaran)}',
              ),

              tableRow(
                'Total Profit',
                'Rp ${rupiah(totalProfit)}',
              ),

              tableRow(
                'Margin Profit',
                '${marginProfit.toStringAsFixed(2)}%',
              ),
            ],
          ),

          pw.SizedBox(height: 30),

          pw.Text(
            'Daftar Transaksi',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 10),

          pw.Table(
            border: pw.TableBorder.all(),

            children: [
              pw.TableRow(
                children: [
                  tableCell('Tanggal', true),
                  tableCell('Supplier', true),
                  tableCell('Barang', true),
                  tableCell('Total', true),
                ],
              ),

              ...batches.map(
                (e) => pw.TableRow(
                  children: [
                    tableCell(
                      e['date'].toString(),
                      false,
                    ),

                    tableCell(
                      e['supplier'].toString(),
                      false,
                    ),

                    tableCell(
                      e['name'].toString(),
                      false,
                    ),

                    tableCell(
                      'Rp ${rupiah(getTotalBatch(e['id'].toString()))}',
                      false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  pw.TableRow tableRow(
    String title,
    String value,
  ) {
    return pw.TableRow(
      children: [
        tableCell(title, false),
        tableCell(value, false),
      ],
    );
  }

  pw.Widget tableCell(
    String text,
    bool bold,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),

      child: pw.Text(
        text,

        style: pw.TextStyle(
          fontWeight:
              bold
                  ? pw.FontWeight.bold
                  : pw.FontWeight.normal,
        ),
      ),
    );
  }

  double getTotalBatch(String batchId) {
    double total = 0;

    for (var item in detailData) {
      if (item['batch_id'].toString() ==
          batchId) {
        total +=
            double.tryParse(
              item['harga'].toString(),
            ) ??
            0;
      }
    }

    return total;
  }

  // ================= CARD =================

  Widget buildCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(14),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                0.05,
              ),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            CircleAvatar(
              backgroundColor:
                  color.withOpacity(0.15),

              child: Icon(
                icon,
                color: color,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              title,

              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              value,

              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SUMMARY =================

  Widget buildSummary(
    String title,
    String value, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [
          Text(
            title,

            style: TextStyle(
              fontSize: 14,
              fontWeight:
                  isBold
                      ? FontWeight.bold
                      : FontWeight.normal,
            ),
          ),

          Text(
            value,

            style: TextStyle(
              fontSize: 14,
              fontWeight:
                  isBold
                      ? FontWeight.bold
                      : FontWeight.w500,

              color:
                  isBold
                      ? Colors.green
                      : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ================= LEGEND =================

  Widget buildLegend(
    Color color,
    String text,
  ) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,

          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 6),

        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

// ================= GRAFIK =================

Widget buildProfitChart() {
  List<FlSpot> penjualanSpots = [];
  List<FlSpot> pembelianSpots = [];
  List<FlSpot> pengeluaranSpots = [];
  List<FlSpot> profitSpots = [];

  double totalBeli = 0;
  double totalJual = 0;
  double totalKeluar = 0;
  double totalUntung = 0;

  for (int i = 0; i < batches.length; i++) {
    final batchId = batches[i]['id'].toString();

    double batchTotal =
        getTotalBatch(batchId);

    // pengaman data error
    if (batchTotal.isNaN ||
        batchTotal.isInfinite) {
      batchTotal = 0;
    }

    totalBeli += batchTotal;

    totalJual = totalBeli * 1.25;

    totalKeluar = totalBeli * 0.05;

    totalUntung =
        totalJual -
        totalBeli -
        totalKeluar;

    penjualanSpots.add(
      FlSpot(
        i.toDouble(),
        totalJual / 1000000,
      ),
    );

    pembelianSpots.add(
      FlSpot(
        i.toDouble(),
        totalBeli / 1000000,
      ),
    );

    pengeluaranSpots.add(
      FlSpot(
        i.toDouble(),
        totalKeluar / 1000000,
      ),
    );

    profitSpots.add(
      FlSpot(
        i.toDouble(),
        totalUntung / 1000000,
      ),
    );
  }

  // wajib minimal 2 titik supaya fl_chart tidak error
  if (penjualanSpots.length < 2) {
    penjualanSpots = [
      const FlSpot(0, 0),
      const FlSpot(1, 0),
    ];

    pembelianSpots = [
      const FlSpot(0, 0),
      const FlSpot(1, 0),
    ];

    pengeluaranSpots = [
      const FlSpot(0, 0),
      const FlSpot(1, 0),
    ];

    profitSpots = [
      const FlSpot(0, 0),
      const FlSpot(1, 0),
    ];
  }

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(18),

      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(
            0.05,
          ),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),

    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        const Text(
          'Grafik Profit',

          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Analisis pembelian, penjualan, pengeluaran dan profit',

          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 24),

        SizedBox(
          height: 300,

          child: LineChart(
            LineChartData(
              minX: 0,

              maxX:
                  penjualanSpots.length
                      .toDouble() -
                  1,

              minY: 0,

              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
              ),

              borderData:
                  FlBorderData(show: false),

              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),

                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),

                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,

                    getTitlesWidget:
                        (value, meta) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(
                              top: 8,
                            ),

                        child: Text(
                          '${value.toInt() + 1}',

                          style:
                              const TextStyle(
                                fontSize: 11,
                              ),
                        ),
                      );
                    },
                  ),
                ),

                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,

                    reservedSize: 40,

                    getTitlesWidget:
                        (value, meta) {
                      return Text(
                        '${value.toInt()} jt',

                        style:
                            const TextStyle(
                              fontSize: 10,
                            ),
                      );
                    },
                  ),
                ),
              ),

              lineBarsData: [
                // PENJUALAN

                LineChartBarData(
                  spots: penjualanSpots,
                  isCurved: false,
                  color: Colors.green,
                  barWidth: 4,

                  dotData: FlDotData(
                    show: true,
                  ),
                ),

                // PEMBELIAN

                LineChartBarData(
                  spots: pembelianSpots,
                  isCurved: false,
                  color: Colors.red,
                  barWidth: 4,

                  dotData: FlDotData(
                    show: true,
                  ),
                ),

                // PENGELUARAN

                LineChartBarData(
                  spots: pengeluaranSpots,
                  isCurved: false,
                  color: Colors.orange,
                  barWidth: 4,

                  dotData: FlDotData(
                    show: true,
                  ),
                ),

                // PROFIT

                LineChartBarData(
                  spots: profitSpots,
                  isCurved: false,
                  color: Colors.blue,
                  barWidth: 4,

                  dotData: FlDotData(
                    show: true,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        Wrap(
          spacing: 16,
          runSpacing: 10,

          children: [
            buildLegend(
              Colors.green,
              'Penjualan',
            ),

            buildLegend(
              Colors.red,
              'Pembelian',
            ),

            buildLegend(
              Colors.orange,
              'Pengeluaran',
            ),

            buildLegend(
              Colors.blue,
              'Profit',
            ),
          ],
        ),
      ],
    ),
  );
}

  // ================= TABLE =================

  Widget buildTableRow({
    required String tanggal,
    required String keterangan,
    required String jenis,
    required String total,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),

      child: Row(
        children: [
          Expanded(
            flex: 2,

            child: Text(
              tanggal,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),

          Expanded(
            flex: 3,

            child: Text(
              keterangan,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),

          Expanded(
            flex: 2,

            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),

              decoration: BoxDecoration(
                color: jenis == 'Jual'
                    ? Colors.green.shade100
                    : Colors.red.shade100,

                borderRadius:
                    BorderRadius.circular(8),
              ),

              child: Text(
                jenis,

                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 11,

                  color:
                      jenis == 'Jual'
                          ? Colors.green
                          : Colors.red,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            flex: 2,

            child: Text(
              total,

              textAlign: TextAlign.end,

              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F6FA),

      floatingActionButton:
          FloatingActionButton.extended(
            onPressed: printLaporan,

            backgroundColor: Colors.green,

            icon: const Icon(Icons.download),

            label: const Text(
              'Export Laporan',
            ),
          ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Row(
                children: [
                  buildCard(
                    title: 'Pembelian',

                    value:
                        'Rp ${rupiah(totalPembelian)}',

                    icon:
                        Icons.shopping_cart,

                    color: Colors.red,
                  ),

                  const SizedBox(width: 12),

                  buildCard(
                    title: 'Penjualan',

                    value:
                        'Rp ${rupiah(totalPenjualan)}',

                    icon:
                        Icons.shopping_bag,

                    color: Colors.green,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  buildCard(
                    title: 'Pengeluaran',

                    value:
                        'Rp ${rupiah(totalPengeluaran)}',

                    icon:
                        Icons.receipt_long,

                    color: Colors.orange,
                  ),

                  const SizedBox(width: 12),

                  buildCard(
                    title: 'Profit',

                    value:
                        'Rp ${rupiah(totalProfit)}',

                    icon:
                        Icons.attach_money,

                    color: Colors.blue,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              buildProfitChart(),

              const SizedBox(height: 20),

              // ================= RINGKASAN KEUANGAN =================

              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(
                  16,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                        16,
                      ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.05),

                      blurRadius: 8,

                      offset: const Offset(
                        0,
                        3,
                      ),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Ringkasan Keuangan',

                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    buildSummary(
                      'Total Pembelian',
                      'Rp ${rupiah(totalPembelian)}',
                    ),

                    buildSummary(
                      'Total Penjualan',
                      'Rp ${rupiah(totalPenjualan)}',
                    ),

                    buildSummary(
                      'Total Pengeluaran',
                      'Rp ${rupiah(totalPengeluaran)}',
                    ),

                    const Divider(
                      height: 28,
                    ),

                    buildSummary(
                      'Total Profit',
                      'Rp ${rupiah(totalProfit)}',
                      isBold: true,
                    ),

                    buildSummary(
                      'Margin Profit',
                      '${marginProfit.toStringAsFixed(2)}%',
                      isBold: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ================= TRANSAKSI =================

              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(
                  16,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                        16,
                      ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.05),

                      blurRadius: 8,

                      offset: const Offset(
                        0,
                        3,
                      ),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Transaksi Terbaru',

                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    ...batches.map(
                      (e) => Column(
                        children: [
                          buildTableRow(
                            tanggal:
                                e['date']
                                    .toString(),

                            keterangan:
                                '${e['supplier']} - ${e['name']}',

                            jenis: 'Beli',

                            total:
                                'Rp ${rupiah(getTotalBatch(e['id'].toString()))}',
                          ),

                          const Divider(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}






// import 'package:flutter/material.dart';

// class Laporan extends StatelessWidget {
//   const Laporan({super.key});

//   Widget buildCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     required Color color,
//   }) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 8,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),

//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CircleAvatar(
//               backgroundColor: color.withOpacity(0.15),
//               child: Icon(icon, color: color),
//             ),

//             const SizedBox(height: 14),

//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 13,
//                 color: Colors.grey,
//               ),
//             ),

//             const SizedBox(height: 6),

//             Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildTableRow({
//     required String tanggal,
//     required String keterangan,
//     required String jenis,
//     required String total,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),

//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               tanggal,
//               style: const TextStyle(fontSize: 12),
//             ),
//           ),

//           Expanded(
//             flex: 3,
//             child: Text(
//               keterangan,
//               style: const TextStyle(fontSize: 12),
//             ),
//           ),

//           Expanded(
//             flex: 2,
//             child: Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 8,
//                 vertical: 4,
//               ),

//               decoration: BoxDecoration(
//                 color: jenis == 'Jual'
//                     ? Colors.green.shade100
//                     : Colors.red.shade100,

//                 borderRadius: BorderRadius.circular(8),
//               ),

//               child: Text(
//                 jenis,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: jenis == 'Jual'
//                       ? Colors.green
//                       : Colors.red,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),

//           Expanded(
//             flex: 2,
//             child: Text(
//               total,
//               textAlign: TextAlign.end,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6FA),

//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),

//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [

//               // ===== CARD ATAS =====

//               Row(
//                 children: [
//                   buildCard(
//                     title: 'Pembelian',
//                     value: 'Rp 28.750.000',
//                     icon: Icons.shopping_cart,
//                     color: Colors.green,
//                   ),

//                   const SizedBox(width: 12),

//                   buildCard(
//                     title: 'Penjualan',
//                     value: 'Rp 37.000.000',
//                     icon: Icons.shopping_bag,
//                     color: Colors.blue,
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 12),

//               Row(
//                 children: [
//                   buildCard(
//                     title: 'Pengeluaran',
//                     value: 'Rp 2.000.000',
//                     icon: Icons.receipt_long,
//                     color: Colors.orange,
//                   ),

//                   const SizedBox(width: 12),

//                   buildCard(
//                     title: 'Profit',
//                     value: 'Rp 6.250.000',
//                     icon: Icons.attach_money,
//                     color: Colors.green,
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 20),

//               // ===== RINGKASAN =====

//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),

//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),

//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 8,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),

//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [

//                     const Text(
//                       'Ringkasan Keuangan',
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     const SizedBox(height: 18),

//                     buildSummary(
//                       'Total Pembelian',
//                       'Rp 28.750.000',
//                     ),

//                     buildSummary(
//                       'Total Penjualan',
//                       'Rp 37.000.000',
//                     ),

//                     buildSummary(
//                       'Total Pengeluaran',
//                       'Rp 2.000.000',
//                     ),

//                     const Divider(height: 28),

//                     buildSummary(
//                       'Profit',
//                       'Rp 6.250.000',
//                       isBold: true,
//                     ),

//                     buildSummary(
//                       'Margin Profit',
//                       '16.89%',
//                       isBold: true,
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // ===== TRANSAKSI =====

//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),

//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),

//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 8,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),

//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [

//                     const Text(
//                       'Transaksi Terbaru',
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     buildTableRow(
//                       tanggal: '02/05/2026',
//                       keterangan: 'Pembelian Supplier A',
//                       jenis: 'Beli',
//                       total: '16.000.000',
//                     ),

//                     const Divider(),

//                     buildTableRow(
//                       tanggal: '05/05/2026',
//                       keterangan: 'Penjualan Pelanggan X',
//                       jenis: 'Jual',
//                       total: '12.000.000',
//                     ),

//                     const Divider(),

//                     buildTableRow(
//                       tanggal: '10/05/2026',
//                       keterangan: 'Pembelian Supplier B',
//                       jenis: 'Beli',
//                       total: '12.750.000',
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildSummary(
//     String title,
//     String value, {
//     bool isBold = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 14),

//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,

//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight:
//                   isBold ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),

//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight:
//                   isBold ? FontWeight.bold : FontWeight.w500,
//               color: isBold ? Colors.green : Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

















// import 'package:flutter/material.dart';

// class Laporan extends StatefulWidget {
//   const Laporan({super.key});

//   @override
//   State<Laporan> createState() => _LaporanState();
// }

// class _LaporanState extends State<Laporan> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text(
//           'Halaman Laporan',
         
//         ),
//       ),
//     );
//   }
// }