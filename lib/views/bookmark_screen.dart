import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'utils/helper.dart';
import 'widgets/custom_form_field.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cWhite,
        elevation: 0,
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
            Text('Bookmark', style: headline3.copyWith(fontWeight: semibold)),
            vsTiny,
            CustomFormField(
              hintText: 'Cari',
              controller: searchController,
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
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Jumlah placeholder
                itemBuilder: (context, index) {
                  return Card(
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
                              'https://picsum.photos/id/${189 + index}/300/200',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Saham Tesla melonjak setelah',
                              style: subtitle1.copyWith(fontWeight: semibold),
                            ),
                            Text('Bisnis, Teknologi', style: caption),
                            vsLarge,
                            Text('2020-12-01', style: caption),
                            Icon(Icons.bookmark_outline),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}