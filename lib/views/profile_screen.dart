import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newsnime/views/widgets/profile_data_widget.dart';
import 'package:newsnime/views/widgets/profile_tile.dart';
import 'utils/helper.dart';
// Akan dibuat nanti

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cGrey,
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.asset('assets/images/Meliuk-liuk.png'), // Anda akan memerlukan gambar ini
              Text('Data Diri', style: headline4),
              vsTiny,
            ],
          ),
          Padding(
            padding: REdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  'Profil',
                  style: headline3.copyWith(color: cPrimary, fontWeight: bold),
                ),
                vsTiny,
                Container(
                  padding: REdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: cWhite,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          log('image onTap');
                        },
                        child: Center(
                          child: CircleAvatar(
                            backgroundColor: cGrey,
                            radius: 70.r,
                            backgroundImage: AssetImage('assets/images/news logo.png'), // Anda akan memerlukan gambar ini
                          ),
                        ),
                      ),
                      vsSmall,
                      ProfileDataWidget(
                        profile: 'Nama',
                        dataProfile: ': Theresa Webb',
                      ),
                      vsTiny,
                      ProfileDataWidget(
                        profile: 'Email',
                        dataProfile: ': theresa_we@gmail.com',
                      ),
                      vsTiny,
                      ProfileDataWidget(
                        profile: 'Nomor',
                        dataProfile: ': 089876543210',
                      ),
                      vsTiny,
                      ProfileDataWidget(
                        profile: 'Alamat',
                        dataProfile: ': Jl. Cangkring Raya, Maleer, Kec. Batununggal, Kota Bandung, Jawa Barat',
                      ),
                    ],
                  ),
                ),
                vsLarge,
                ProfileMenuTile(
                  title: 'Edit Profil',
                  onTap: () {
                    log('Edit Profile onTap');
                  },
                  leading: Icon(Icons.border_color_outlined, color: cBlack),
                  trailing: Icon(Icons.keyboard_arrow_right_rounded, color: cBlack),
                ),
                Divider(color: cBlack, height: 4.0),
                ProfileMenuTile(
                  title: 'Edit Kata Sandi',
                  onTap: () {
                    log('Edit Password onTap');
                  },
                  leading: Icon(Icons.password, color: cBlack),
                  trailing: Icon(Icons.keyboard_arrow_right_rounded, color: cBlack),
                ),
                Divider(color: cBlack, height: 4.0),
                ProfileMenuTile(
                  title: 'Keluar',
                  onTap: () {
                    log('Logout onTap');
                    // Implementasikan logika keluar
                  },
                  leading: Icon(Icons.logout_rounded, color: cBlack),
                  trailing: Icon(Icons.keyboard_arrow_right_rounded, color: cBlack),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}