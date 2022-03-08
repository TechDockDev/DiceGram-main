import 'package:country_code_picker/country_code_picker.dart';
import 'package:dicegram/ui/screens/otp_screen.dart';
import 'package:dicegram/utils/Color.dart';
import 'package:dicegram/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  String countryPhoneCode = "+91";
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment(-0.5, 0.5),
            colors: [Color(0xffFCEE21), Color(0xFFFF0000)],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Image(
                  fit: BoxFit.fill,
                  width: width,
                  image: const AssetImage('assets/images/logo2.png')),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(4, 8), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: TextFormField(
                    obscureText: false,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name',
                        hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    controller: _usernameController,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: width,
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(4, 8), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: SizedBox(
                  width: 500,
                  child: Row(
                    children: [
                      CountryCodePicker(
                        onChanged: _onCountryCodeSelected,
                        showFlagDialog: true,
                        showFlagMain: true,
                        backgroundColor: Colors1.red,
                        showDropDownButton: true,
                        barrierColor: Colors1.red,
                        initialSelection: 'IN',
                        favorite: const ['IN'],
                        countryFilter: AppConstants.list,
                        showFlag: false,
                        flagDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          obscureText: false,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: _mobileController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Phone',
                              hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ),
                //Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 16),
                //   child: DropdownButton(
                //     value: dropdownValue,
                //     underline: SizedBox(),
                //     icon: const Icon(Icons.arrow_drop_down_rounded,color: Colors1.primary,),
                //     elevation: 16,
                //     style: const TextStyle( fontSize : 16,color: Colors.black, fontWeight: FontWeight.bold),
                //     isDense: true,
                //     onChanged: (String? newValue) {
                //       setState(() {
                //         dropdownValue = newValue!;
                //       });
                //     },
                //     items: <String>['One', 'Two', 'Free', 'Four']
                //         .map<DropdownMenuItem<String>>((String value) {
                //       return DropdownMenuItem<String>(
                //         value: value,
                //         child: Text(value),
                //       );
                //     }).toList(),
                //   ),
                // ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OtpScreen(
                            countryPhoneCode + _mobileController.text,
                            _usernameController.text)),
                  );
                },
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFFFF1803), Color(0xffFF4A0B)]),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(4, 8), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                    child: Text(
                      'Get OTP',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ))
          ],
        ),
      ),
    ));
  }

  void _onCountryCodeSelected(countryCode) {
    countryPhoneCode = countryCode;
  }
}
