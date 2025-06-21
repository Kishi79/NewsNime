import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'widgets/custom_form_field.dart';
import 'utils/form_validator.dart';
import 'utils/helper.dart';
import 'widgets/primary_button.dart';
import 'widgets/rich_text_widget.dart';
import '../services/api_service.dart'; // Tambahkan ini
// Tambahkan ini

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Halo', style: headline1.copyWith(fontWeight: semibold)),
                vsSmall,
                Text('Daftar untuk memulai', style: subtitle1),
                SizedBox(height: 96.h),
                RichTextWidget(
                  textOne: '*',
                  textStyleOne: subtitle2.copyWith(color: cError),
                  textTwo: 'Nama',
                  textStyleTwo: subtitle2.copyWith(color: cBlack),
                ),
                vsSuperTiny,
                CustomFormField(
                  controller: nameController,
                  hintText: 'Nama',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: validateName,
                ),
                vsSmall,
                RichTextWidget(
                  textOne: '*',
                  textStyleOne: subtitle2.copyWith(color: cError),
                  textTwo: 'Nomor Telepon',
                  textStyleTwo: subtitle2.copyWith(color: cBlack),
                ),
                vsSuperTiny,
                CustomFormField(
                  controller: phoneNumberController,
                  hintText: 'Nomor Telepon',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: validatePhoneNumber,
                ),
                vsSmall,
                RichTextWidget(
                  textOne: '*',
                  textStyleOne: subtitle2.copyWith(color: cError),
                  textTwo: 'Email',
                  textStyleTwo: subtitle2.copyWith(color: cBlack),
                ),
                vsSuperTiny,
                CustomFormField(
                  controller: emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: validateEmail,
                ),
                vsSmall,
                RichTextWidget(
                  textOne: '*',
                  textStyleOne: subtitle2.copyWith(color: cError),
                  textTwo: 'Kata Sandi',
                  textStyleTwo: subtitle2.copyWith(color: cBlack),
                ),
                vsSuperTiny,
                CustomFormField(
                  controller: passwordController,
                  hintText: 'Kata Sandi',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  validator: validatePassword,
                  obscureText: isObscure,
                  // Anda akan menambahkan suffixIcon untuk mengganti visibilitas nanti di CustomFormField
                ),
                Spacer(),
                PrimaryButton(
                  onPressed: () async {
                    // Memastikan semua validasi formulir lulus
                    if (formkey.currentState!.validate()) {
                      try {
                        // Memanggil fungsi registerUser dari ApiService
                        // Ingat, kita juga mengirim nama pengguna untuk registrasi
                        final user = await ApiService.registerUser(
                          email: emailController.text,
                          password: passwordController.text,
                          name: nameController.text,
                          // Anda bisa menambahkan 'title' dan 'avatar' di sini
                          // title: 'Pengguna Baru',
                          // avatar: 'https://example.com/default_avatar.jpg',
                        );

                        // Jika registrasi berhasil
                        log('Registrasi berhasil untuk user: ${user.name}');
                        if (mounted) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            // Tampilkan pesan sukses
                            const SnackBar(
                              content: Text(
                                'Registrasi berhasil! Silakan masuk.',
                              ),
                            ),
                          );
                          // ignore: use_build_context_synchronously
                          context
                              .pop(); // Kembali ke halaman Login setelah registrasi berhasil
                        }
                      } catch (e) {
                        // Jika terjadi error saat registrasi
                        log(
                          'Registrasi Error: $e',
                        ); // Log error untuk debugging
                        if (mounted) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            // Tampilkan pesan error ke pengguna
                            SnackBar(
                              content: Text(
                                'Registrasi gagal: ${e.toString()}',
                              ),
                            ),
                          );
                        }
                      }
                    }
                  },
                  title: 'Daftar',
                ),
                vsSmall,
                GestureDetector(
                  onTap: () {
                    context.pop(); // Kembali ke layar Login
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: RichTextWidget(
                      textOne: 'Sudah punya akun? ',
                      textStyleOne: subtitle2.copyWith(color: cBlack),
                      textTwo: 'Masuk',
                      textStyleTwo: subtitle2.copyWith(color: cPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void togglePasswordVisibility() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
