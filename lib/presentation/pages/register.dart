import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_com/core/layouts/no_appbar_layout.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return NoAppBarLayout(
        child: SingleChildScrollView(
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            width: width * 0.5,
            child: SvgPicture.asset('assets/images/tree.svg'),
          ),
          Container(
            width: width,
            height: height,
            decoration: const BoxDecoration(color: Color(0x7fffffff)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/banner.png",
                    height: height * 0.15,
                    fit: BoxFit.fitHeight,
                  ),
                  const SizedBox(height: 10),
                  const Text("Where Environmentalists gather.",
                      style: TextStyle(fontSize: 17, color: Color(0xffbfbfbf))),
                  SizedBox(height: height * 0.07),
                  Container(
                    width: width * 0.9,
                    padding: EdgeInsets.all(width * 0.05),
                    decoration: BoxDecoration(
                      color: const Color(0x335BE7C4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff7A57D1),
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              height: 3,
                              width: width * 0.2,
                              decoration: const BoxDecoration(
                                color: Color(0xff7A57D1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: height * 0.07,
                          decoration: BoxDecoration(
                            color: const Color(0xffeeeeee),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            onTapOutside: (e) {
                              FocusScope.of(context).unfocus();
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: "Enter your Full Name",
                                hintStyle: TextStyle(
                                    color: Color(0xff666666),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                                prefixIcon: Icon(
                                  BootstrapIcons.person,
                                  color: Color(0xff0D7194),
                                )),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: height * 0.07,
                          decoration: BoxDecoration(
                            color: const Color(0xffeeeeee),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            onTapOutside: (e) {
                              FocusScope.of(context).unfocus();
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: "Enter your E-mail ID",
                                hintStyle: TextStyle(
                                    color: Color(0xff666666),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                                prefixIcon: Icon(
                                  BootstrapIcons.envelope,
                                  color: Color(0xff0D7194),
                                )),
                          ),
                        ),
                        // const SizedBox(height: 10),
                        // Container(
                        //   height: height * 0.07,
                        //   decoration: BoxDecoration(
                        //     color: const Color(0xffeeeeee),
                        //     borderRadius: BorderRadius.circular(30),
                        //   ),
                        //   child: TextField(
                        //     decoration: const InputDecoration(
                        //         border: OutlineInputBorder(
                        //             borderSide: BorderSide.none),
                        //         hintText: "Enter your location",
                        //         hintStyle: TextStyle(
                        //             color: Color(0xff666666),
                        //             fontSize: 15,
                        //             fontWeight: FontWeight.w400),
                        //         prefixIcon: Icon(
                        //           BootstrapIcons.geo_alt,
                        //           color: Color(0xff0D7194),
                        //         )),
                        //   ),
                        // ),
                        const SizedBox(height: 10),
                        Container(
                          height: height * 0.07,
                          decoration: BoxDecoration(
                            color: const Color(0xffeeeeee),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            onTapOutside: (e) {
                              FocusScope.of(context).unfocus();
                            },
                            obscureText: isPasswordObscure,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: "Set a password",
                              hintStyle: const TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isPasswordObscure = !isPasswordObscure;
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Icon(
                                      BootstrapIcons.eye,
                                      color: Color(0xff0D7194),
                                    ),
                                  ),
                                ),
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  BootstrapIcons.key,
                                  color: Color(0xff0D7194),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/register");
                          },
                          child: Container(
                            height: height * 0.06,
                            decoration: BoxDecoration(
                              color: const Color(0xff0D7194),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
          ),
        ],
      ),
    ));
  }
}
