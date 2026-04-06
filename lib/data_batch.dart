import 'package:flutter/material.dart';
import 'services/get_batch.dart';

class DataBatch extends StatefulWidget {
  const DataBatch({super.key});

  @override
  State<DataBatch> createState() => _DataBatchState();
}

class _DataBatchState extends State<DataBatch> {
  List<Map<String, dynamic>> _batches = [];
  List<Map<String, dynamic>> _batchDetails = [];
  bool _isLoading = true; // ← Tambah ini
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getBatches();
  }

  void getBatches() async {
    List<Map<String, dynamic>> batches = await getAllBatch();
    List<Map<String, dynamic>> batchDetails = [];

    for (var batch in batches) {
      batchDetails.addAll(await getBatchDetails(batch['id']));
    }

    if (!mounted) return; 
    setState(() {
      _batches = batches;
      _batchDetails = batchDetails;
      _isLoading = false; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Batch'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search Supplier...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child:
                _isLoading
                    // ← Tampilkan loading dulu saat fetch data
                    ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.blue),
                          SizedBox(height: 10),
                          Text('Memuat data...'),
                        ],
                      ),
                    )
                    : _batches.isEmpty
                    // ← Kalau data kosong
                    ? const Center(child: Text('Tidak ada data batch'))
                    : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
                        itemCount: _batches.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BatchDetails(
                                    batch: _batches[index],
                                    batchDetails: _batchDetails,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              child: ListTile(
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.blue.shade100,
                                  ),
                                  child: Center(
                                    child: Text(
                                      _batches[index]['supplier'][0]
                                          .toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.blue.shade900,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  _batches[index]['supplier'],
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(_batches[index]['name']),
                                trailing: Text(_batches[index]['date']),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}

class BatchDetails extends StatelessWidget {
  const BatchDetails({super.key, required this.batch, required this.batchDetails});

  final Map<String, dynamic> batch;
  final List<Map<String, dynamic>> batchDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Batch'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID Batch: ${batch['id']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Nama Batch: ${batch['name']}', style: TextStyle(fontSize: 16)),
            Text('Tanggal: ${batch['date']}', style: TextStyle(fontSize: 16)),
            Text('Supplier: ${batch['supplier']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Detail Komposisi:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: batchDetails.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(batchDetails[index]['komposisi']),
                    subtitle: Text('Berat: ${batchDetails[index]['berat']} kg'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
