import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsnime/routes/route_name.dart';
import 'utils/form_validator.dart';
import 'utils/helper.dart';
import 'widgets/custom_form_field.dart'; // Akan dibuat nanti
import 'widgets/primary_button.dart'; // Sudah didefinisikan
import 'widgets/rich_text_widget.dart'; // Akan dibuat nanti
import '../services/api_service.dart'; // Tambahkan ini
// Tambahkan ini

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                RichTextWidget(
                  textOne: 'Halo',
                  textStyleOne: headline1.copyWith(fontWeight: semibold),
                  cTextOne: cBlack,
                  textTwo: '\nKembali!',
                  textStyleTwo: headline1.copyWith(fontWeight: semibold),
                  cTextTwo: cPrimary,
                ),
                vsSmall,
                Text(
                  'Selamat datang kembali, kami merindukanmu',
                  style: subtitle1,
                ),
                vsXLarge,
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
                  suffixIcon: IconButton(
                    onPressed: togglePasswordVisibility,
                    icon:
                        isObscure
                            ? const Icon(Icons.visibility_outlined)
                            : const Icon(Icons.visibility_off_outlined),
                  ),
                  validator: validatePassword,
                  obscureText: isObscure,
                  // Anda akan menambahkan suffixIcon untuk mengganti visibilitas nanti di CustomFormField
                ),
                vsMedium,
                GestureDetector(
                  onTap: () {
                    log('Forgot Password onTap');
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Lupa Kata Sandi?',
                      style: subtitle2.copyWith(color: cError),
                    ),
                  ),
                ),
                Spacer(),
                PrimaryButton(
                  onPressed: () async {
                    // Memastikan semua validasi formulir lulus
                    if (formkey.currentState!.validate()) {
                      try {
                        // Memanggil fungsi loginUser dari ApiService
                        // Ini adalah proses asinkron, jadi pakai 'await'
                        final user = await ApiService.loginUser(
                          email:
                              emailController
                                  .text, // Mengambil teks dari input email
                          password:
                              passwordController
                                  .text, // Mengambil teks dari input password
                        );

                        // Jika login berhasil, kita akan mendapatkan objek 'user'
                        // Logika navigasi setelah login berhasil
                        if (mounted) {
                          // 'mounted' memastikan widget masih ada sebelum navigasi
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            // Tampilkan pesan sukses
                            SnackBar(
                              content: Text('Selamat datang, ${user.name}!'),
                            ),
                          );
                          // ignore: use_build_context_synchronously
                          context.goNamed(
                            RouteNames.main,
                          ); // Arahkan ke halaman utama
                        }
                      } catch (e) {
                        // Jika terjadi error saat login (misalnya, email/password salah)
                        log('Login Error: $e'); // Log error untuk debugging
                        if (mounted) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            // Tampilkan pesan error ke pengguna
                            SnackBar(
                              content: Text('Login gagal: ${e.toString()}'),
                            ),
                          );
                        }
                      }
                    }
                  },
                  title: 'Masuk',
                ),
                vsSmall,
                GestureDetector(
                  onTap: () {
                    context.pushNamed(RouteNames.register);
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: RichTextWidget(
                      textOne: 'Belum punya akun?',
                      textStyleOne: subtitle2.copyWith(color: cBlack),
                      textTwo: 'Daftar',
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
