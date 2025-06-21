import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:newsnime/routes/route_name.dart';
import 'utils/helper.dart';
import 'widgets/custom_form_field.dart';
import '../services/api_service.dart'; // Tambahkan ini
import '../models/article.dart'; // Tambahkan ini

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late TabController tabController;
  int currentTabIndex = 0;
  int currentCarouselIndex = 0;

  Future<List<Article>>? _articlesFuture;
  Future<List<Article>>? _trendingArticlesFuture;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);

    // Panggil API untuk mendapatkan semua artikel
    _articlesFuture = ApiService.getAllArticles();
    // Panggil API untuk mendapatkan artikel trending (untuk carousel)
    _trendingArticlesFuture = ApiService.getTrendingArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cWhite,
        leading: Image.asset(
          'assets/images/news logo.png', // Anda akan memerlukan gambar ini
          width: 36.w,
          fit: BoxFit.contain,
        ),
        title: Text(
          'NewsStream', // Diubah dari Newshive
          style: headline4.copyWith(color: cPrimary, fontWeight: bold),
        ),
      ),
      backgroundColor: cWhite,
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vsSmall,
            CustomFormField(
              controller: searchController,
              hintText: 'Cari',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              suffixIcon: const Icon(Icons.search),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pencarian tidak boleh kosong';
                }
                return null;
              },
            ),
            vsSmall,
            TabBar(
              controller: tabController,
              labelColor: cPrimary,
              unselectedLabelColor: cBlack,
              indicatorColor: cPrimary,
              tabs: const [
                Tab(text: 'Headline'),
                Tab(text: 'Top Stories'),
                Tab(text: 'Berita Serupa'),
              ],
            ),
            vsSmall,
            // ... kode sebelum CarouselSlider
            SizedBox(
              height: 150.h,
              width: 320.w,
              child: FutureBuilder<List<Article>>(
                // Menggunakan FutureBuilder
                future: _trendingArticlesFuture, // Sumber data dari API Service
                builder: (context, snapshot) {
                  // Cek status koneksi
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    ); // Tampilkan loading
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error memuat trending: ${snapshot.error}'),
                    ); // Tampilkan error
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada artikel trending.'),
                    ); // Jika data kosong
                  } else {
                    // Jika data berhasil dimuat, tampilkan CarouselSlider
                    return CarouselSlider.builder(
                      options: CarouselOptions(
                        height: 150.h,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentCarouselIndex = index;
                          });
                        },
                      ),
                      itemCount:
                          snapshot.data!.length, // Jumlah item dari data API
                      itemBuilder: (context, index, realIndex) {
                        final article =
                            snapshot.data![index]; // Ambil objek artikel
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                article.imageUrl, // URL gambar dari data API
                                width: 320.w,
                                height: 150.h,
                                fit: BoxFit.cover,
                                // Tambahkan errorBuilder untuk gambar yang gagal dimuat
                                errorBuilder:
                                    (context, error, stackTrace) => Image.asset(
                                      'assets/images/placeholder.png', // Ganti dengan gambar placeholder Anda
                                      width: 320.w,
                                      height: 150.h,
                                      fit: BoxFit.cover,
                                    ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                bottom: 8,
                              ),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  article.title, // Judul dari data API
                                  style: subtitle1.copyWith(
                                    fontWeight: bold,
                                    color: cWhite,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
            // ... kode setelah CarouselSlider
            vsSmall,
            Text(
              'Semua Berita',
              style: subtitle1.copyWith(fontWeight: semibold),
            ),
            vsTiny,
            // ... kode sebelum ListView.builder
            Expanded(
              child: FutureBuilder<List<Article>>(
                // Menggunakan FutureBuilder
                future: _articlesFuture, // Sumber data dari API Service
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error memuat berita: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada berita untuk ditampilkan.'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount:
                          snapshot.data!.length, // Jumlah item dari data API
                      itemBuilder: (context, index) {
                        final article =
                            snapshot.data![index]; // Ambil objek artikel
                        return GestureDetector(
                          onTap: () {
                            // Saat card diklik, arahkan ke DetailScreen dan teruskan ID artikel
                            context.pushNamed(
                              RouteNames.detail,
                              extra: article.id,
                            );
                          },
                          child: Card(
                            elevation: 0,
                            color: cWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 100.w,
                                  height: 100.h,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      article
                                          .imageUrl, // URL gambar dari data API
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (
                                            context,
                                            error,
                                            stackTrace,
                                          ) => Image.asset(
                                            'assets/images/placeholder.png', // Ganti dengan gambar placeholder Anda
                                            width: 100.w,
                                            height: 100.h,
                                            fit: BoxFit.cover,
                                          ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  // Penting untuk mencegah overflow teks
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title, // Judul dari data API
                                        style: subtitle1.copyWith(
                                          fontWeight: semibold,
                                        ),
                                        maxLines: 2, // Batasi jumlah baris
                                        overflow:
                                            TextOverflow
                                                .ellipsis, // Tambahkan elipsis jika teks terlalu panjang
                                      ),
                                      Text(
                                        '${article.category}, ${article.author.name}', // Kategori dan Nama Penulis
                                        style: caption,
                                      ),
                                      vsTiny, // Gunakan spasi yang sudah didefinisikan
                                    ],
                                  ),
                                ),
                                Column(
                                  // Untuk tanggal dan ikon bookmark
                                  children: [
                                    Text(
                                      article.publishedAt,
                                      style: caption,
                                    ), // Tanggal publikasi
                                    IconButton(
                                      icon: const Icon(
                                        Icons.bookmark_outline,
                                      ), // Ikon bookmark (nanti bisa diubah berdasarkan status bookmark)
                                      onPressed: () {
                                        // Logika untuk bookmark akan ditambahkan nanti
                                        // Misalnya: ApiService.saveBookmark(article.id);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            // ... kode setelah ListView.builder
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    tabController.dispose();
    super.dispose();
  }
}
