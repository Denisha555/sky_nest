import 'package:flutter/material.dart';
import 'package:flutter_application_1/tambah_batch.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard'), backgroundColor: Colors.blue, centerTitle: true, titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Card(
                color: Colors.blue,
                child: ListTile(
                  title: Text('Total Batch', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                  trailing: Text('10', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const Card(
                color: Colors.green,
                child: ListTile(
                  title: Text('Total Modal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                  trailing: Text('50.000.000', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const Card(
                color: Colors.orange,
                child: ListTile(
                  title: Text('Total Penjualan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                  trailing: Text('100.000.000', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const Card(
                color: Colors.red,
                child: ListTile(
                  title: Text('Total Profit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                  trailing: Text('50.000.000', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))
                ),
              ),
              SizedBox(height: 20),
              const Card(
                child: ListTile(
                  title: Text('Shrinkage Rata-rata: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                  trailing: Text('10%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ),
              ElevatedButton(onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TambahBatch()),
                );
              }, 
              child: const Text('Tambah Batch'))
              
            ],
          ),
        ),
      ),
    );
  }
}