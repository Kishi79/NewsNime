import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsnime/routes/route_name.dart';
import 'utils/form_validator.dart';
import 'utils/helper.dart';
import 'widgets/custom_form_field.dart'; // Akan dibuat nanti
import 'widgets/primary_button.dart'; // Sudah didefinisikan
import 'widgets/rich_text_widget.dart'; // Akan dibuat nanti

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
                  onPressed: () {
                    log('Login onTap');
                    context.goNamed(RouteNames.main);
                    // Tambahkan logika login Anda di sini
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
