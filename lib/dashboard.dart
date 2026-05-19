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

  @override
  void initState() {
    super.initState();
    getBatch();
  }

  Future<void> getBatch() async {

    List<Map<String, dynamic>> data =
        await getAllBatch();

    setState(() {
      batches = data;
    });
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(

      child: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(16.0),

          child: Center(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,

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

                const Card(
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
                      '50.000.000',

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const Card(
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
                      '100.000.000',

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const Card(
                  color: Colors.red,

                  child: ListTile(

                    title: Text(
                      'Total Profit',

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    trailing: Text(
                      '50.000.000',

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Card(

                  child: ListTile(

                    title: Text(
                      'Shrinkage Rata-rata: ',

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    trailing: Text(
                      '10%',

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(

                  onPressed: () {

                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) =>
                            const TambahBatch(),
                      ),
                    );
                  },

                  child: const Text(
                    'Tambah Batch',
                  ),
                ),

                const SizedBox(height: 10),

                ElevatedButton(

                  onPressed: () {

                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) =>
                            const DataBatch(),
                      ),
                    );
                  },

                  child: const Text(
                    'Data Batch',
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/services/get_batch.dart';


// class Dashboard extends StatefulWidget {
//   const Dashboard({super.key});

//   @override
//   State<Dashboard> createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   List<Map<String, dynamic>> batches = [];

//   @override
//   void initState() {
//     super.initState();
//     getBatch();
//   }

//   Future<void> getBatch() async {
//     final data = await getAllBatch();

//     setState(() {
//       batches = data;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               // TOTAL BATCH
//               Card(
//                 color: Colors.blue,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: ListTile(
//                   title: const Text(
//                     'Total Batch',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   trailing: Text(
//                     batches.isEmpty
//                         ? '0'
//                         : batches.length.toString(),
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 10),

//               // TOTAL MODAL
//               Card(
//                 color: Colors.green,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: const ListTile(
//                   title: Text(
//                     'Total Modal',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   trailing: Text(
//                     '50.000.000',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 10),

//               // TOTAL PENJUALAN
//               Card(
//                 color: Colors.orange,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: const ListTile(
//                   title: Text(
//                     'Total Penjualan',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   trailing: Text(
//                     '100.000.000',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 10),

//               // TOTAL PROFIT
//               Card(
//                 color: Colors.red,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: const ListTile(
//                   title: Text(
//                     'Total Profit',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   trailing: Text(
//                     '50.000.000',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // SHRINKAGE
//               Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: const ListTile(
//                   title: Text(
//                     'Shrinkage Rata-rata:',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   trailing: Text(
//                     '10%',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }








