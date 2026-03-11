import 'package:flutter/material.dart';

class TambahBatch extends StatefulWidget {
  const TambahBatch({super.key});

  @override
  State<TambahBatch> createState() => _TambahBatchState();
}

class _TambahBatchState extends State<TambahBatch> {
  TextEditingController tanggalBeliController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  TextEditingController beratController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController kadarAirController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Batch'),
        backgroundColor: Colors.blue,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tanggal Beli",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: tanggalBeliController,
                decoration: InputDecoration(
                  hintText: 'Masukkan tanggal beli',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  ).then((pickedDate) {
                    if (pickedDate != null) {
                      setState(() {
                        tanggalBeliController.text =
                            pickedDate.toString().split(' ')[0];
                      });
                    }
                  });
                },
              ),
              SizedBox(height: 10),

              Text(
                "Supplier",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: supplierController,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama supplier',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              Text(
                "Berat (kg)",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: beratController,
                decoration: InputDecoration(
                  hintText: 'Masukkan berat dalam kg',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),

              Text(
                "Harga (Rp)",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: hargaController,
                decoration: InputDecoration(
                  hintText: 'Masukkan harga dalam Rupiah',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),

              Text(
                "Kadar Air (%)",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: kadarAirController,
                decoration: InputDecoration(
                  hintText: 'Masukkan kadar air dalam persen',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),

              Text(
                "Komposisi",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Mangkok"),
                      SizedBox(height: 5),
                      Text("A"),
                      SizedBox(height: 5),
                      Text("B"),
                      SizedBox(height: 5),
                      Text("C"),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Kipas"),
                      SizedBox(height: 5),
                      Text("A"),
                      SizedBox(height: 5),
                      Text("B"),
                      SizedBox(height: 5),
                      Text("C"),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Segitiga"),
                      SizedBox(height: 5),
                      Text("A"),
                      SizedBox(height: 5),
                      Text("B"),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5,),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Kaki")
                ),
              ),
              SizedBox(height: 5,),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Patahan")
                ),
              ),
              SizedBox(height: 5,),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Serat")
                ),
              ),
              SizedBox(height: 5,),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("BUlu")
                ),
              ),
              SizedBox(height: 5,),

              
            ],
          ),
        ),
      ),
    );
  }
}
