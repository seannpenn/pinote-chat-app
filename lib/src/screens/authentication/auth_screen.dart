import 'package:chat_app/src/controllers/auth_controller.dart';
import 'package:chat_app/src/controllers/navigation/navigation_service.dart';
import 'package:chat_app/src/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

import '../../../service_locators.dart';

class AuthScreen extends StatefulWidget {
  static const String route = 'auth-screen';

  const AuthScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCon = TextEditingController(),
      _passCon = TextEditingController(),
      _pass2Con = TextEditingController(),
      _usernameCon = TextEditingController();
  final AuthController _authController = locator<AuthController>();

  String prompts = '';

  @override
  void initState() {
    _authController.addListener(handleLogin);
    super.initState();
  }

  handleLogin() {
    if (_authController.currentUser != null) {
      locator<NavigationService>().pushReplacementNamed(HomeScreen.route);
    }
  }

  @override
  void dispose() {
    _emailCon.dispose();
    _passCon.dispose();
    _pass2Con.dispose();
    _usernameCon.dispose();
    _authController.removeListener(handleLogin);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _authController,
        builder: (context, Widget? w) {
          ///shows a loading screen while initializing
          if (_authController.working) {
            return const Scaffold(
              body: Center(
                child: SizedBox(
                    width: 50, height: 50, child: CircularProgressIndicator()),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Chat App'),
                backgroundColor: Colors.teal[400],
                centerTitle: true,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 4 / 5,
                      child: Container(
                        // decoration: BoxDecoration(
                        //   color: ,
                        // ),
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Form(
                            key: _formKey,
                            onChanged: () {
                              _formKey.currentState?.validate();
                              if (mounted) {
                                setState(() {});
                              }
                            },
                            child: DefaultTabController(
                              length: 2,
                              initialIndex: 0,
                              child: Column(
                                children: [
                                  TabBar(tabs: [
                                    Tab(
                                      // icon: Icon(Icons.login, color: Colors.black,),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.login,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Log In',
                                            style: TextStyle(
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Tab(
                                      // icon: Icon(Icons.login, color: Colors.black,),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.app_registration_rounded,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Register',
                                            style: TextStyle(
                                                color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                  Expanded(
                                    child: TabBarView(
                                      children: [
                                        ///login
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(_authController
                                                    .error?.message ??
                                                ''),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 20.0, 20.0, 20.0),
                                                hintText: "Email",
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: Icon(
                                                    Icons.person,
                                                    color:
                                                        _emailCon.text.isEmpty
                                                            ? Colors.black
                                                            : Colors.teal[400],
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  borderSide: const BorderSide(
                                                      width: 3.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xFF26A69A),
                                                      width: 3.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                              ),
                                              controller: _emailCon,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your email';
                                                }
                                                return null;
                                              },
                                            ),
                                            TextFormField(
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 20.0, 20.0, 20.0),
                                                hintText: "password",
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: Icon(
                                                    Icons.lock,
                                                    color:
                                                        _passCon.text.isEmpty
                                                            ? Colors.black
                                                            : Colors.teal[400],
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  borderSide: const BorderSide(
                                                      width: 3.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xFF26A69A),
                                                      width: 3.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                              ),
                                              
                                              controller: _passCon,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your password';
                                                }
                                                return null;
                                              },
                                            ),
                                            ElevatedButton(
                                              onPressed: (_formKey.currentState
                                                          ?.validate() ??
                                                      false)
                                                  ? () {
                                                      _authController.login(
                                                          _emailCon.text.trim(),
                                                          _passCon.text.trim());
                                                    }
                                                  : null,
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 50,
                                                      vertical: 20),
                                                  primary: (_formKey
                                                              .currentState
                                                              ?.validate() ??
                                                          false)
                                                      ? const Color(0xFF303030)
                                                      : Colors.grey),
                                              child: const Text('Log in'),
                                            )
                                          ],
                                        ),

                                        ///register
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(_authController
                                                    .error?.message ??
                                                ''),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 20.0, 20.0, 20.0),
                                                hintText: "Email",
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: Icon(
                                                    Icons.lock,
                                                    color:
                                                        _passCon.text.isEmpty
                                                            ? Colors.black
                                                            : Colors.teal[400],
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  borderSide: const BorderSide(
                                                      width: 3.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xFF26A69A),
                                                      width: 3.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                              ),
                                              controller: _emailCon,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your email';
                                                }
                                                return null;
                                              },
                                            ),
                                            TextFormField(
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 20.0, 20.0, 20.0),
                                                hintText: "Password",
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: Icon(
                                                    Icons.lock,
                                                    color:
                                                        _passCon.text.isEmpty
                                                            ? Colors.black
                                                            : Colors.teal[400],
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  borderSide: const BorderSide(
                                                      width: 3.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xFF26A69A),
                                                      width: 3.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                              ),
                                              controller: _passCon,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your password';
                                                }
                                                return null;
                                              },
                                            ),
                                            TextFormField(
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 20.0, 20.0, 20.0),
                                                hintText: "Confirm Password",
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: Icon(
                                                    Icons.lock,
                                                    color:
                                                        _pass2Con.text.isEmpty
                                                            ? Colors.black
                                                            : Colors.teal[400],
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  borderSide: const BorderSide(
                                                      width: 3.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xFF26A69A),
                                                      width: 3.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                              ),
                                              
                                              controller: _pass2Con,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please confirm your password';
                                                } else if (_passCon.text !=
                                                    _pass2Con.text) {
                                                  return 'Passwords do not match!';
                                                }
                                                return null;
                                              },
                                            ),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        20.0, 20.0, 20.0, 20.0),
                                                hintText: "Enter username",
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: Icon(
                                                    Icons.lock,
                                                    color:
                                                        _usernameCon.text.isEmpty
                                                            ? Colors.black
                                                            : Colors.teal[400],
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  borderSide: const BorderSide(
                                                      width: 3.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xFF26A69A),
                                                      width: 3.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                              ),
                                              
                                              controller: _usernameCon,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter username';
                                                }
                                                return null;
                                              },
                                            ),
                                            ElevatedButton(
                                              onPressed: (_formKey.currentState
                                                          ?.validate() ??
                                                      false)
                                                  ? () {
                                                      _authController.register(
                                                          email: _emailCon.text
                                                              .trim(),
                                                          password: _passCon
                                                              .text
                                                              .trim(),
                                                          username: _usernameCon
                                                              .text
                                                              .trim());
                                                    }
                                                  : null,
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 50,
                                                      vertical: 20),
                                                  primary: (_formKey
                                                              .currentState
                                                              ?.validate() ??
                                                          false)
                                                      ? const Color(0xFF303030)
                                                      : Colors.grey),
                                              child: const Text('Register'),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
