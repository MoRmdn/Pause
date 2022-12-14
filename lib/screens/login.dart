import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../dialog/custom_generic_dialog.dart';
import '../dialog/loading_screen_dialog.dart';
import '../helper/app_config.dart';
import 'widget/login_screen/auth_view.dart';
import 'widget/login_screen/custom_text_button.dart';

typedef OnLoginTapped = void Function(
  String email,
  String password,
);

class LoginScreen extends StatefulWidget {
  static const routeName = AppConfig.loginRouteName;

  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

//? When an AnimationController is being created from a State,
//? you should have the State to extend either TickerProviderStateMixin or SingleTickerProviderStateMixin.
//? The latter is more optimized for when you only need to use a single ticker, which should be most of the case.
class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AuthPageController pageController = AuthPageController.loginPage;
  // bool isLogin = true;
  // bool isSignUp = false;
  // bool isForgetPassword = false;
  // bool isAnimated = false;
  final loading = LoadingScreen.instance();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  AnimationController? _animationController;
  Animation<Size>? _animationTween;

  @override
  void initState() {
    //* control the state and duration
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    //* values of size that animation works between
    _animationTween = Tween<Size>(
      begin: const Size(double.infinity, 230),
      end: const Size(double.infinity, 300),
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear,
      ),
    );
    //? to listen to any change and update UI
    _animationController!.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _animationController!.dispose();
    super.dispose();
  }

  void _switchController(AuthPageController page) => setState(() {
        pageController = page;
        pageController == AuthPageController.signUpPage
            ? _animationController!.forward()
            : _animationController!.reverse();
      });

  void _dialogBox(String title, String content) {
    //const
    loading.show(
      context: context,
      content: AppConfig.pleaseWait,
    );

    Future.delayed(const Duration(seconds: 1)).then((value) {
      loading.hide();
      customGenericDialog(
        context: context,
        title: title,
        content: content,
        dialogOptions: () {
          return {
            AppConfig.ok: true,
          };
        },
      );
    });
  }

  bool _checkEmptyTextField() {
    final email = emailController.text;
    final name = nameController.text;
    final password = passwordController.text;
    if (pageController == AuthPageController.loginPage) {
      if (email.isEmpty || password.isEmpty) {
        _dialogBox(
          AppConfig.emailOrPasswordEmptyDialogTitle,
          AppConfig.emailOrPasswordEmptyDescription,
        );
        return false;
      }
      return true;
    } else if (pageController == AuthPageController.signUpPage) {
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        _dialogBox(
          AppConfig.emailOrPasswordOrNameEmptyDialogTitle,
          AppConfig.emailOrPasswordOrNameEmptyDescription,
        );
        return false;
      }
      return true;
    } else if (pageController == AuthPageController.forgetPassword) {
      if (email.isEmpty) {
        _dialogBox(
          AppConfig.forgetPasswordEmptyTitle,
          AppConfig.forgetPasswordEmptyDescription,
        );
        return false;
      }
      return true;
    }
    return true;
  }

  void _onSave() {
    final email = emailController.text;
    final password = passwordController.text;
    final name = nameController.text;
    final emptyError = _checkEmptyTextField();
    if (!emptyError) {
      log('EmptyFieldError');
      return;
    }

    if (pageController == AuthPageController.loginPage) {
      // ToDo code for login logic
      loading.show(context: context, content: AppConfig.pleaseWait);
      Future.delayed(const Duration(seconds: 1)).then((value) {
        loading.hide();
        Navigator.of(context).pushReplacementNamed(AppConfig.homeRouteName);
      });
    } else if (pageController == AuthPageController.signUpPage) {
      // ToDo code for sign up logic
      loading.show(context: context, content: AppConfig.pleaseWait);
      Future.delayed(const Duration(seconds: 1)).then((value) {
        loading.hide();
        Navigator.of(context).pushReplacementNamed(AppConfig.homeRouteName);
      });
    } else if (pageController == AuthPageController.forgetPassword) {
      // ToDo code for rest Password
      //? Reset Password
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          width: size.width,
          constraints: BoxConstraints(
            maxHeight: size.height,
            maxWidth: size.width,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                pageController == AuthPageController.loginPage
                    ? AppConfig.loginBackgroundImage
                    : pageController == AuthPageController.signUpPage
                        ? AppConfig.signUpBackgroundImage
                        : AppConfig.forgetPasswordBackgroundImage,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //? Top Space
              const Expanded(
                flex: 2,
                child: SizedBox(),
              ),
              //? page title
              Text(
                pageController == AuthPageController.loginPage
                    ? AppConfig.login
                    : pageController == AuthPageController.signUpPage
                        ? AppConfig.signUp
                        : AppConfig.forgetPassword,
                style: GoogleFonts.lato(
                  color: pageController == AuthPageController.forgetPassword
                      ? AppConfig.primaryColor
                      : AppConfig.authColors,
                  textStyle: pageController == AuthPageController.forgetPassword
                      ? Theme.of(context).textTheme.headline3
                      : Theme.of(context).textTheme.headline2,
                  // fontSize: 48,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),

              SizedBox(height: size.height * 0.05),
              AuthView(
                animationTween: _animationTween!,
                animationController: _animationController!,
                size: size,
                loading: loading,
                emailController: emailController,
                nameController: nameController,
                passwordController: passwordController,
                pageController: pageController,
                onLoginTap: _onSave,
              ),
              CustomTextButton(
                changeColor: pageController == AuthPageController.forgetPassword
                    ? true
                    : false,
                title: pageController == AuthPageController.loginPage
                    ? AppConfig.signUp
                    : AppConfig.login,
                buttonFun: () => _switchController(
                  pageController == AuthPageController.loginPage
                      ? AuthPageController.signUpPage
                      : AuthPageController.loginPage,
                ),
              ),
              if (pageController == AuthPageController.loginPage)
                CustomTextButton(
                  title: AppConfig.forgetPassword,
                  buttonFun: () => _switchController(
                    AuthPageController.forgetPassword,
                  ),
                ),
              //? bottom Space
              const Expanded(
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
