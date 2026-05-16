import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/get_batch.dart';

class DataMargin extends StatefulWidget {
  const DataMargin({super.key});

  @override
  State<DataMargin> createState() => _DataMarginState();
}

class _DataMarginState extends State<DataMargin> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> batch = [];

  String selectedBatch = '';

  @override
  void initState() {
    super.initState();
    _getBatchData();
  }

  Future<void> _getBatchData() async {
    final temp = await getAllBatch();
    setState(() {
      batch = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Margin', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Data Batch"),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Pilih Batch',
                    border: OutlineInputBorder(),
                  ),
                  items: batch.map((b) => DropdownMenuItem(
                    value: "${b['supplier']} - ${b['name']} - ${b['date']}",
                    child: Text("${b['supplier']} - ${b['name']} - ${b['date']}"),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBatch = value ?? '';
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}