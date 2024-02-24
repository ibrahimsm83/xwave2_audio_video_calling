import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:chat_app_with_myysql/controller/auth_controller.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/util/export.dart';
import 'package:chat_app_with_myysql/widget/custome_button.dart';
import 'package:chat_app_with_myysql/widget/myBtn.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
  }

  bool positive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Image.asset(
                      'images/signupbg 1.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, right: 10.0),
                    child: AnimatedToggleSwitch<bool>.dual(
                      current: positive,
                      first: false,
                      second: true,
                      spacing: 2.0,
                      style: ToggleStyle(
                        borderColor: Colors.transparent,
                        backgroundColor:
                            ColorManager.kDarkGreyColor.withOpacity(0.6),
                      ),
                      borderWidth: 2.0,
                      height: 38,
                      onChanged: (b) => setState(() => positive = b),
                      styleBuilder: (b) => ToggleStyle(
                          indicatorColor: b ? Colors.black : Colors.white),
                      iconBuilder: (value) => value
                          ? SvgPicture.asset(
                              ImageAssets.kMoonIcon,
                              height: 15,
                              width: 15,
                            ) //Icon(Icons.coronavirus_rounded)
                          : SvgPicture.asset(ImageAssets.kSunIcon,
                              height: 15,
                              width: 15,
                              color: ColorManager.kPrimaryColor),
                      textBuilder: (value) => value
                          ? Center(
                              child: Text(
                              'Light',
                              style: getSemiBoldStyle(
                                  color: ColorManager.kBlackColor,
                                  fontFamily: FontConstants.fontFamilyJakarta),
                            ))
                          : Center(
                              child: Text(
                              'Dark',
                              style: getSemiBoldStyle(
                                  color: ColorManager.kBlackColor,
                                  fontFamily: FontConstants.fontFamilyJakarta),
                            )),
                    ),
                  ),
                ],
              ),
              container(),
              SizedBox(height: 30),
              Image.asset(
                'images/Logo.png',
                width: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget container() {
    return Container(
      // width: Get.width,
      height: 320,
      decoration: BoxDecoration(
        color: appBlack,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Login to Your Account",
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(
                  color: ColorManager.kWhiteColor,
                  fontFamily: FontConstants.fontFamilyJakarta,
                  fontSize: 16),
            ),
          ),
          button(
              text: "Phone Number",
              color: ColorManager.kWhiteColor,
              onTap: () {
              }),
          phone(),

          button(
              text: "Send OTP",
              color: ColorManager.kPrimaryColor,
              onTap: () {
                authController.login(number.phoneNumber);
              }),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  PhoneNumber number = PhoneNumber(isoCode: 'PK');

  Widget button({Function()? onTap, String? text, Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppSize.sizeWidth(context) * 0.04, vertical: 10.0),
      child: CustomButton(
          color: color!,
          text: text ?? "",
          style: getBoldStyle(
            color: ColorManager.kBlackColor,
            fontFamily: FontConstants.fontFamilyJakarta,
            fontSize: 14
          ),
          onTap: onTap),
    );
  }

  Widget phone() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10,10,20,10),
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber numbe) {
          number = numbe;
        },
        onInputValidated: (bool value) {
          print(value);
        },
        selectorConfig: SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          useBottomSheetSafeArea: true,
        ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.disabled,
        selectorTextStyle: TextStyle(color: Colors.white),
        initialValue: number,
        formatInput: true,
        keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
        inputBorder: OutlineInputBorder(),
        // hintText: 'Phone Number',
        inputDecoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 8.0),
            hintText: 'Phone Number',
          hintStyle: getSemiBoldStyle(color: ColorManager.kWhiteColor,fontSize: 14),
          // border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        textStyle: const TextStyle(color: Colors.white),
        onSaved: (PhoneNumber number) {
          print('On Saved: $number');
        },
      ),
    );
  }
}
