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
  @override
  void initState() {
    super.initState();
    getBatches();
  }

  void getBatches() async {
    List<Map<String, dynamic>> batches = await getAllBatch();
    List<Map<String, dynamic>> batchDetails = [];

    setState(() {
      _batches = batches;
    });

    for (var batch in batches) {
      batchDetails.addAll(await getBatchDetails(batch['id']));
    }

    setState(() {
      _batchDetails = batchDetails;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Batch', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              ListView.builder(itemCount: _batches.length, itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_batches[index]['name']),
                    subtitle: Text(_batches[index]['date']),
                  ),
                );
              },)
            ],
          )),
        ),
    );
  }
}