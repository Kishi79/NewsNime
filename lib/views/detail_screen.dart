import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'utils/helper.dart';
import 'widgets/rich_text_widget.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.keyboard_arrow_left_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () {
              log('Bookmark onTap');
            },
            icon: Icon(Icons.bookmark_border_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 170.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://picsum.photos/300/200',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            vsSmall,
            Text(
              'Perang dagang Trump menghantam set roda favorit kedua, kereta golf',
              style: headline4.copyWith(fontWeight: semibold),
            ),
            vsSmall,
            RichTextWidget(
              textOne: 'Dipublikasikan pada ',
              textStyleOne: subtitle2.copyWith(color: cBlack),
              cTextOne: cBlack,
              textTwo: '30 Maret 2025',
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
              textTwo: 'nbcnews.com',
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
              textTwo: 'Umum, Politik',
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
                  'Selama 100 hari pertama masa jabatan kedua dan pasang surut ancaman tarifnya, Presiden Trump, seorang pegolf yang rajin, sering berada di lapangan dan difoto di kereta golf, biasanya kereta yang dibuat oleh perusahaan domestik Club Car atau E-Z-Go. Selama 100 hari pertama masa jabatan kedua dan pasang surut ancaman tarifnya, Presiden Trump, seorang pegolf yang rajin, sering berada di lapangan dan difoto di kereta golf, biasanya kereta yang dibuat oleh perusahaan domestik Club Car atau E-Z-Go. Selama 100 hari pertama masa jabatan kedua dan pasang surut ancaman tarifnya, Presiden Trump, seorang pegolf yang rajin, sering berada di lapangan dan difoto di kereta golf, biasanya kereta yang dibuat oleh perusahaan domestik Club Car atau E-Z-Go.',
                  style: subtitle2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}