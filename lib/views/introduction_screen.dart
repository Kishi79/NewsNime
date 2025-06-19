import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsnime/routes/route_name.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'utils/helper.dart';
import 'widgets/primary_button.dart'; // Akan dibuat nanti
import 'widgets/secondary_button.dart'; // Akan dibuat nanti

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  List<Map<String, dynamic>> pageList = [
    {
      'imageUrl': 'assets/images/intro1.png',
      'heading': 'Dunia di Ujung Jari Anda',
      'body':
          'Dapatkan pembaruan berita global 24/7 dari politik terpanas hingga tren budaya, semuanya di satu tempat',
    },
    {
      'imageUrl': 'assets/images/intro2.png',
      'heading': 'Diselarasakan dengan Rasa Ingin Tahu Anda',
      'body':
          'Pilih minat Anda dan terima cerita pilihan. Teknologi, olahraga, atau hiburan - kami siap membantu Anda',
    },
    {
      'imageUrl': 'assets/images/intro3.png',
      'heading': 'Pembaruan Tepercaya secara Real-Time',
      'body':
          'Peringatan instan untuk berita terkini, diperiksa faktanya secara ketat oleh editor kami sebelum mencapai Anda',
    },
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemCount: pageList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 100),
                      Image.asset(pageList[index]['imageUrl'], height: 300),
                      SizedBox(height: 100),
                      Text(
                        pageList[index]['heading'],
                        style: headline3.copyWith(
                          color: cPrimary,
                          fontWeight: bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(pageList[index]['body'], style: subtitle1),
                      SizedBox(height: 12),
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: pageList.length,
                        axisDirection: Axis.horizontal,
                        effect: ExpandingDotsEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          expansionFactor: 3,
                          activeDotColor: cPrimary,
                          dotColor: cLinear,
                        ),
                      ),
                      Spacer(),
                      _currentPage == pageList.length - 1
                          ? PrimaryButton(
                            onPressed: () {
                              context.goNamed(RouteNames.login);
                            },
                            title: 'Mulai',
                          )
                          : SizedBox(
                            // Tambahkan SizedBox ini
                            height:
                                50.0, // Beri tinggi yang eksplisit, sesuaikan jika perlu
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // crossAxisAlignment: CrossAxisAlignment.stretch, // Hapus atau biarkan jika tidak menyebabkan masalah lain
                              children: [
                                Expanded(
                                  child: SecondaryButton(
                                    onPressed: () {
                                      _pageController.jumpToPage(
                                        pageList.length - 1,
                                      );
                                    },
                                    title: 'Lewati',
                                  ),
                                ),
                                hsLarge,
                                Expanded(
                                  child: PrimaryButton(
                                    onPressed: () {
                                      _pageController.nextPage(
                                        duration: const Duration(
                                          milliseconds: 500,
                                        ),
                                        curve: Curves.ease,
                                      );
                                    },
                                    title: 'Selanjutnya',
                                  ),
                                ),
                              ],
                            ),
                          ), // Tutup SizedBox
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
