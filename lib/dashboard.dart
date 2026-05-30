import 'package:flutter/material.dart';
import 'package:flutter_application_1/data_batch.dart';
import 'package:flutter_application_1/services/get_batch.dart';
import 'package:flutter_application_1/tambah_batch.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<Map<String, dynamic>> batches = [];
  int totalModal = 0;
  int totalPenjualan = 0;
  int totalProfit = 0;

  @override
  void initState() {
    super.initState();
    getBatch();
  }

  Future<void> getBatch() async {

    List<Map<String, dynamic>> data =
        await getAllBatchThisMonth();

    int tempHargaJual = 0;
    int tempProfit = 0;

    int tempModal = await getTotalModalThisMonth();

    for (var d in data) {
      if (d['harga_jual'] != null) {
        tempHargaJual += int.parse(d['harga_jual'].toString());
        tempProfit += int.parse(d['profit'].toString());
      }
    }

    setState(() {
      batches = data;
      totalPenjualan = tempHargaJual;
      totalProfit = tempProfit;
      totalModal = tempModal;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F6FA),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat,

      floatingActionButton: Padding(

        padding: EdgeInsets.only(
          bottom: 5,
        ),

        child: ElevatedButton.icon(

          onPressed: () {

            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (context) =>
                    const TambahBatch(),
              ),
            );
          },

          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),

          label: const Text(
            'Tambah Batch',
          ),

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,

            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),

            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(18),
            ),

            elevation: 5,
          ),
        ),
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(
            padding: EdgeInsets.all(16.0),

            child: Center(

              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.start,

                children: [

                  Card(
                    color: Colors.blue,

                    child: ListTile(

                      title: const Text(
                        'Total Batch',

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      trailing: Text(
                        batches.isEmpty
                            ? '0'
                            : batches.length.toString(),

                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  Card(
                    color: Colors.green,

                    child: ListTile(

                      title: Text(
                        'Total Modal',

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      trailing: Text(
                        totalModal.toString(),

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  Card(
                    color: Colors.orange,

                    child: ListTile(

                      title: Text(
                        'Total Penjualan',

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      trailing: Text(
                        totalPenjualan.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  
                  const SizedBox(height: 20),

                  Card(

                    child: ListTile(

                      title: Text(
                        'Total Profit: ',

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      trailing: Text(
                        totalProfit.toString(),

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


