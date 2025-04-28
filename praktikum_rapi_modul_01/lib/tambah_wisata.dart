import 'dart:typed_data'; //nyimpen gamabr format byte
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart'; // biar bisa pilih gambar dari galeri
import 'data.dart'; // import file data.dart kamu di sini

class TambahWisata extends StatefulWidget {
  @override
  _TambahWisataState createState() => _TambahWisataState();
}

class _TambahWisataState extends State<TambahWisata> {
  Uint8List? _imageBytes;
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _hargaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  String? _jenisWisata; // buat nyimpen pilihan dropdown

  //buat menghindari kebocoran memori (membersihkan controller)
  @override
  void dispose() {
    _namaController.dispose();
    _lokasiController.dispose();
    _hargaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  //untuk upload gambar
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  //untuk validasi form
  void _validateForm() {
    if (_formKey.currentState!.validate()) {
      if (_imageBytes == null) {
        _showSnackbar('Silakan upload gambar wisata');
        return;
      }

      // buat objek Wisata baru
      final wisataBaru = Wisata(
        nama: _namaController.text,
        lokasi: _lokasiController.text,
        jenis: _jenisWisata!,
        harga: int.parse(_hargaController.text),
        deskripsi: _deskripsiController.text,
        gambar: _imageBytes!,
      );

      // tambahkan objek Wisata baru ke daftarWisata
      daftarWisata.add(wisataBaru);

      // langsung kembali ke halaman sebelumnya
      Navigator.pop(
        context,
        'Wisata berhasil ditambahkan',
      ); // kembali ke homepage
    }
  }

  //untuk reset form
  void _resetForm() async {
    // tampilkan dialog konfirmasi
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          // buat dialog konfirmasi
          (context) => AlertDialog(
            title: Text('Konfirmasi'),
            content: Text('Apakah Anda yakin ingin mereset form?'),
            // buat tombol batal dan ya
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Ya'),
              ),
            ],
          ),
    );

    // reset form jika konfirmasi berhasil
    if (confirm == true) {
      _showSnackbar('Form berhasil direset!');
      // reset gambar dan dropdown
      setState(() {
        _imageBytes = null;
        _jenisWisata = null;
      });
      _formKey.currentState?.reset();
      _namaController.clear();
      _lokasiController.clear();
      _hargaController.clear();
      _deskripsiController.clear();
    }
  }

  //untuk menampilkan snackbar
  void _showSnackbar(String message) {
    // tampilkan snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(fontFamily: 'Poppins'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE2E2E2),
      appBar: AppBar(
        title: Text(
          "Tambah Wisata",
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // border: Border.all(
                  //   color:
                  //       _imageBytes == null ? Colors.red : Colors.transparent,
                  //   width: 2,
                  // ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    _imageBytes != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            _imageBytes!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder:
                                (context, error, stackTrace) => Icon(
                                  Icons.broken_image,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                          ),
                        )
                        : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/Add image.png',
                                width: 60,
                                height: 60,
                                errorBuilder:
                                    (context, error, stackTrace) => Icon(
                                      Icons.image,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tambah Foto',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
              ),
              SizedBox(height: 24),
              _buildButton('Upload Image', _pickImage),
              SizedBox(height: 24),
              _buildTextField(
                'Nama Wisata:',
                'Masukkan Nama Wisata Disini',
                _namaController,
              ),
              _buildTextField(
                'Lokasi Wisata:',
                'Masukkan Lokasi Wisata Disini',
                _lokasiController,
              ),
              _buildDropdown(),
              _buildTextField(
                'Harga Tiket:',
                'Masukkan Harga Tiket Disini',
                _hargaController,
                inputType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              _buildTextField(
                'Deskripsi:',
                'Masukkan Deskripsi Wisata Disini',
                _deskripsiController,
                maxLines: 6,
              ),
              SizedBox(height: 24),
              _buildButton('Simpan', _validateForm),
              SizedBox(height: 16),
              TextButton(
                onPressed: _resetForm,
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xFF261FB3),
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    fontFamily: 'Poppins',
                  ),
                ),
                child: Text('Reset'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //untuk textfield
  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator:
              (value) =>
                  value == null || value.isEmpty ? '$label wajib diisi' : null,
          keyboardType: inputType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          decoration: _inputDecoration(hint),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Color(0xFF424040),
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  //untuk dropdown
  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jenis Wisata:',
          style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _jenisWisata,
          validator:
              (value) => value == null ? 'Jenis wisata wajib dipilih' : null,
          decoration: _inputDecoration('Pilih Jenis Wisata'),
          items:
              ['Pantai', 'Pegunungan', 'Kuliner', 'Taman Hiburan', 'Sejarah']
                  .map(
                    (jenis) => DropdownMenuItem(
                      value: jenis,
                      child: Text(
                        jenis,
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: (value) => setState(() => _jenisWisata = value),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  //untuk tombol
  Widget _buildButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF261FB3),
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  //untuk inputan
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        color: Color(0xFF424040),
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
