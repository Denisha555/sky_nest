import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                color: Colors.blue,
                child: ListTile(
                  title: Text('Total Batch', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                  trailing: Text('10', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              Card(
                color: Colors.green,
                child: ListTile(
                  title: Text('Total Modal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                  trailing: Text('50.000.000', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              Card(
                color: Colors.orange,
                child: ListTile(
                  title: Text('Total Penjualan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                  trailing: Text('100.000.000', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              Card(
                color: Colors.red,
                child: ListTile(
                  title: Text('Total Profit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                  trailing: Text('50.000.000', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Shrinkage Rata-rata: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                  trailing: Text('10%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}