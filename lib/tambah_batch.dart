import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/add_batch.dart';
import 'package:flutter_application_1/constant_file.dart';

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

  TextEditingController mangkokAController = TextEditingController();
  TextEditingController mangkokBController = TextEditingController();
  TextEditingController mangkokCController = TextEditingController();
  TextEditingController kipasAController = TextEditingController();
  TextEditingController kipasBController = TextEditingController();
  TextEditingController kipasCController = TextEditingController();
  TextEditingController segitigaAController = TextEditingController();
  TextEditingController segitigaBController = TextEditingController();
  TextEditingController kakiController = TextEditingController();
  TextEditingController patahanController = TextEditingController();
  TextEditingController seratController = TextEditingController();
  TextEditingController buluController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? selectedNamaBarang;

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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
            
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
                              dateToDetailDate(pickedDate);
                        });
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tanggal beli harus diisi';
                    }
                    return null;
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama supplier harus diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
            
                Text(
                  "Nama Barang",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedNamaBarang,
                    hint: Text(
                      'Pilih nama barang',
                      style: TextStyle(color: Colors.grey.shade900),
                    ),
                    isExpanded: true,
                    items:
                        <String>[
                          'Mangkok',
                          'Kipas',
                          'Segitiga',
                          'Kaki',
                          'Patahan',
                          'Serat',
                          'Bulu',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedNamaBarang = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama barang harus dipilih';
                      };
                    }
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Berat harus diisi';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Berat harus berupa angka';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga harus diisi';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Harga harus berupa angka';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kadar air harus diisi';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Kadar air harus berupa angka';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
            
                Text(
                  "Komposisi",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
            
                if (selectedNamaBarang != null) ...[
                  if (selectedNamaBarang == 'Mangkok') ...[
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
                            Row(
                              children: [
                                Text("A: "),
                                SizedBox(width: 5),
                                Expanded(
                                  child: TextFormField(
                                    controller: mangkokAController,
                                    decoration: InputDecoration(
                                      hintText: 'Masukkan berat (kg)',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator:(value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Berat A harus diisi';
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'Berat A harus berupa angka';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text("B: "),
                                SizedBox(width: 5),
                                Expanded(
                                  child: TextFormField(
                                    controller: mangkokBController,
                                    decoration: InputDecoration(
                                      hintText: 'Masukkan berat (kg)',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Berat B harus diisi';
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'Berat B harus berupa angka';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text("C: "),
                                SizedBox(width: 5),
                                Expanded(
                                  child: TextFormField(
                                    controller: mangkokCController,
                                    decoration: InputDecoration(
                                      hintText: 'Masukkan berat (kg)',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Berat C harus diisi';
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'Berat C harus berupa angka';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                  ] else if (selectedNamaBarang == 'Kipas') ...[
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
                            Row(
                              children: [
                                Text("A: "),
                                SizedBox(width: 5),
                                Expanded(
                                  child: TextFormField(
                                    controller: kipasAController,
                                    decoration: InputDecoration(
                                      hintText: 'Masukkan berat (kg)',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Berat A harus diisi';
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'Berat A harus berupa angka';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text("B: "),
                                SizedBox(width: 5),
                                Expanded(
                                  child: TextFormField(
                                    controller: kipasBController,
                                    decoration: InputDecoration(
                                      hintText: 'Masukkan berat (kg)',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Berat B harus diisi';
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'Berat B harus berupa angka';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text("C: "),
                                SizedBox(width: 5),
                                Expanded(
                                  child: TextFormField(
                                    controller: kipasCController,
                                    decoration: InputDecoration(
                                      hintText: 'Masukkan berat (kg)',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Berat C harus diisi';
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'Berat C harus berupa angka';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                  ] else if (selectedNamaBarang == 'Segitiga') ...[
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
                            Row(
                              children: [
                                Text("A: "),
                                SizedBox(width: 5),
                                Expanded(
                                  child: TextFormField(
                                    controller: segitigaAController,
                                    decoration: InputDecoration(
                                      hintText: 'Masukkan berat (kg)',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Berat A harus diisi';
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'Berat A harus berupa angka';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text("B: "),
                                SizedBox(width: 5),
                                Expanded(
                                  child: TextFormField(
                                    controller: segitigaBController,
                                    decoration: InputDecoration(
                                      hintText: 'Masukkan berat (kg)',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Berat B harus diisi';
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'Berat B harus berupa angka';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                  ] else if (selectedNamaBarang == 'Kaki') ...[
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[200],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text("Kaki: "),
                            SizedBox(width: 5),
                            Expanded(
                              child: TextFormField(
                                controller: kakiController,
                                decoration: InputDecoration(
                                  hintText: 'Masukkan berat (kg)',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Berat harus diisi';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Berat harus berupa angka';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                  ] else if (selectedNamaBarang == 'Patahan') ...[
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[200],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(children: [
                          Text("Patahan: "),
                          SizedBox(width: 5),
                          Expanded(
                            child: TextFormField(
                              controller: patahanController,
                              decoration: InputDecoration(
                                hintText: 'Masukkan berat (kg)',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Berat harus diisi';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Berat harus berupa angka';
                                }
                                return null;
                              },
                            ),
                          ),
                          ]),
                      ),
                    ),
                    SizedBox(height: 5),
                  ] else if (selectedNamaBarang == 'Serat') ...[
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[200],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text("Serat: "),
                            SizedBox(width: 5),
                            Expanded(
                              child: TextFormField(
                                controller: seratController,
                                decoration: InputDecoration(
                                  hintText: 'Masukkan berat (kg)',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Berat harus diisi';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Berat harus berupa angka';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                  ] else if (selectedNamaBarang == 'Bulu') ...[
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[200],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text("Bulu: "),
                            SizedBox(width: 5),
                            Expanded(
                              child: TextFormField(
                                controller: buluController,
                                decoration: InputDecoration(
                                  hintText: 'Masukkan berat (kg)',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Berat harus diisi';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Berat harus berupa angka';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                  SizedBox(height: 20),
                ],
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      
                      if (_formKey.currentState!.validate()) {
                        addBatch(tanggalBeliController.text, selectedNamaBarang!);
                        if (selectedNamaBarang == 'Mangkok') {
                          // addBatchDetails(batchId, 'A', int.parse(mangkokAController.text));
                          // addBatchDetails(batchId, 'B', int.parse(mangkokBController.text))
                        }
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Mohon isi semua field dengan benar')),
                        );
                      }
                    },
                    child: Text('Simpan'),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
