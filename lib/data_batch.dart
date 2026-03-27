import 'package:flutter/material.dart';

class DataBatch extends StatelessWidget {
  const DataBatch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Batch'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Text('Halaman Data Batch'),
      ),
    );
  }
}