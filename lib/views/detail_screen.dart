import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'utils/helper.dart';
import 'widgets/rich_text_widget.dart';
import '../services/api_service.dart'; // Tambahkan ini
import '../models/article.dart'; // Tambahkan ini

class DetailScreen extends StatefulWidget {
  final String articleId; // Ini akan menerima ID dari navigasi

  const DetailScreen({super.key, required this.articleId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Future<Article>? _articleFuture; // Untuk menampung future dari artikel
  bool _isBookmarked = false; // Untuk status bookmark

  @override
  void initState() {
    super.initState();
    // Panggil API untuk mendapatkan detail artikel berdasarkan ID
    _articleFuture = ApiService.getArticleById(widget.articleId);
    // Periksa status bookmark saat pertama kali dimuat
    _checkBookmarkStatus();
  }

  // Fungsi untuk memeriksa status bookmark
  Future<void> _checkBookmarkStatus() async {
    try {
      final status = await ApiService.checkBookmarkStatus(widget.articleId);
      setState(() {
        _isBookmarked = status;
      });
    } catch (e) {
      log('Error checking bookmark status: $e');
      // Anda bisa menambahkan pesan toast atau snackbar di sini jika mau
    }
  }

  // Fungsi untuk mengubah status bookmark (simpan/hapus)
  Future<void> _toggleBookmark() async {
    try {
      if (_isBookmarked) {
        await ApiService.removeBookmark(widget.articleId);
      } else {
        await ApiService.saveBookmark(widget.articleId);
      }
      setState(() {
        _isBookmarked = !_isBookmarked; // Balik statusnya
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isBookmarked
                ? 'Berita disimpan!'
                : 'Berita dihapus dari bookmark.',
          ),
        ),
      );
    } catch (e) {
      log('Error toggling bookmark: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengubah status bookmark: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.keyboard_arrow_left_rounded),
        ),
        actions: [
          IconButton(
            onPressed: _toggleBookmark, // Panggil fungsi toggle bookmark
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border_rounded,
            ), // Ubah ikon berdasarkan status
          ),
        ],
      ),
      body: FutureBuilder<Article>(
        // Menggunakan FutureBuilder untuk menampilkan artikel
        future: _articleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Artikel tidak ditemukan.'));
          } else {
            final article =
                snapshot.data!; // Ambil objek artikel yang sudah dimuat
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 170.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        article.imageUrl, // Gambar dari API
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Image.asset(
                              'assets/images/placeholder.png', // Ganti dengan gambar placeholder Anda
                              width: MediaQuery.of(context).size.width,
                              height: 170.h,
                              fit: BoxFit.cover,
                            ),
                      ),
                    ),
                  ),
                  vsSmall,
                  Text(
                    article.title, // Judul dari API
                    style: headline4.copyWith(fontWeight: semibold),
                  ),
                  vsSmall,
                  RichTextWidget(
                    textOne: 'Dipublikasikan pada ',
                    textStyleOne: subtitle2.copyWith(color: cBlack),
                    cTextOne: cBlack,
                    textTwo: article.publishedAt, // Tanggal dari API
                    textStyleTwo: subtitle2.copyWith(
                      color: cBlack,
                      fontWeight: semibold,
                    ),
                    cTextTwo: cBlack,
                  ),
                  RichTextWidget(
                    textOne: 'Sumber: ',
                    textStyleOne: subtitle2.copyWith(color: cBlack),
                    cTextOne: cBlack,
                    textTwo: article.author.name, // Nama penulis dari API
                    textStyleTwo: subtitle2.copyWith(
                      color: cBlack,
                      fontWeight: semibold,
                    ),
                    cTextTwo: cBlack,
                  ),
                  RichTextWidget(
                    textOne: 'Kategori: ',
                    textStyleOne: subtitle2.copyWith(color: cBlack),
                    cTextOne: cBlack,
                    textTwo: article.category, // Kategori dari API
                    textStyleTwo: subtitle2.copyWith(
                      color: cBlack,
                      fontWeight: semibold,
                    ),
                    cTextTwo: cBlack,
                  ),
                  vsSmall,
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        article.content, // Konten dari API
                        style: subtitle2,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
