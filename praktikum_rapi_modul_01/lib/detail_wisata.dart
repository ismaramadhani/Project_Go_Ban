// detail_wisata.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/asset_images.dart'; // Import file helper image
import 'data.dart';

class DetailWisataPage extends StatelessWidget {
  final Wisata wisata;

  const DetailWisataPage({super.key, required this.wisata});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          wisata.nama,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.memory(
                wisata.gambar,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Icon(Icons.broken_image),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            AssetImages.iconCategorySvg, // helper path
                            width: 25,
                            height: 25,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              wisata.jenis,
                              style: GoogleFonts.poppins(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          // Icon(Icons.location_on, size: 25),
                          SvgPicture.asset(
                            AssetImages.iconLocation,
                            width: 25,
                            height: 25,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              wisata.lokasi,
                              style: GoogleFonts.poppins(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.confirmation_number, // Icon tiket
                        size: 30,
                        color: Colors.black, // Ganti sesuai kebutuhan
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Rp ${wisata.harga.toString()}',
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              wisata.deskripsi,
              style: GoogleFonts.poppins(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
