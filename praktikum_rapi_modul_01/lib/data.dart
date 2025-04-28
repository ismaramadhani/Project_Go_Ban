import 'dart:typed_data';

import 'package:lorem_ipsum/lorem_ipsum.dart';

class Wisata {
  String nama;
  String lokasi;
  String jenis;
  int harga;
  String deskripsi;
  Uint8List gambar;

  Wisata({
    required this.nama,
    required this.lokasi,
    required this.jenis,
    required this.harga,
    required this.deskripsi,
    required this.gambar,
  });
}

List<Wisata> daftarWisata = [];

final List<Map<String, String>> places = [
  {
    'title': 'National Park Yosemite',
    'location': 'California',
    'image': 'assets/GambarPemandangan.jpeg',
    'desc': loremIpsum(words: 200),
    'price': '30.000,00',
    'category': 'Wisata Alam',
  },
  {
    'title': 'Grand Canyon',
    'location': 'Arizona',
    'image': 'assets/GambarPemandangan.jpeg',
    'desc': loremIpsum(words: 200),
    'price': '25.000,00',
    'category': 'Wisata Alam',
  },
  {
    'title': 'Yellowstone',
    'location': 'Wyoming',
    'image': 'assets/GambarPemandangan.jpeg',
    'desc': loremIpsum(words: 200),
    'price': '28.000,00',
    'category': 'Wisata Alam',
  },
  {
    'title': 'DARJO BARAT KRIAN',
    'location': 'Wyoming',
    'image': 'assets/GambarPemandangan.jpeg',
    'desc': loremIpsum(words: 200),
    'price': '10.000,00',
    'category': 'Wisata Desa',
  },
];

final List<Map<String, String>> hotels = [
  {
    'title': 'Yellowstone Hotel',
    'desc': loremIpsum(words: 200),
    'image': 'assets/GambarPemandangan.jpeg',
    'location': 'Wyoming',
    'category': 'Nature',
    'price': '28.000,00',
  },
  {
    'title': 'National Park Yosemite',
    'desc': loremIpsum(words: 200),
    'image': 'assets/GambarPemandangan.jpeg',
    'location': 'Wyoming',
    'category': 'Nature',
    'price': '28.000,00',
  },
  {
    'title': 'Grand Canyon Lodge',
    'desc': loremIpsum(words: 200),
    'image': 'assets/GambarPemandangan.jpeg',
    'location': 'Wyoming',
    'category': 'Nature',
    'price': '28.000,00',
  },
  {
    'title': 'Yellowstone Hotel',
    'desc': loremIpsum(words: 200),
    'image': 'assets/GambarPemandangan.jpeg',
    'location': 'Wyoming',
    'category': 'Nature',
    'price': '28.000,00',
  },
  {
    'title': 'New Hotel Adventure',
    'desc': loremIpsum(words: 200),
    'image': 'assets/GambarPemandangan.jpeg',
    'location': 'Wyoming',
    'category': 'Nature',
    'price': '28.000,00',
  },
];
