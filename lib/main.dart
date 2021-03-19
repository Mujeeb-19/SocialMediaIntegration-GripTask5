import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'loginWithFacebook.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
//Gmail login function
  _login() async {
    try {
      await _googleSignIn.signIn();
      setState(() {
        _isLoggedIn = true;
      });
    } catch (err) {
      print(err);
    }
  }

//Gmail logout function
  _logout() {
    _googleSignIn.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            //Gmail login
            Expanded(
              child: Container(
                child: Center(
                  child: _isLoggedIn
                      //If gmail logged in..
                      ? Container(
                          height: double.infinity,
                          width: double.infinity,
                          //Background frame
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://st2.depositphotos.com/2706039/8690/v/950/depositphotos_86901326-stock-illustration-pink-frame-for-girls.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          //User's Details
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // User's photo
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundImage: NetworkImage(
                                    _googleSignIn.currentUser.photoUrl,
                                  ),
                                ),
                              ),
                              // User's name
                              TyperAnimatedTextKit(
                                text: [_googleSignIn.currentUser.displayName],
                                textStyle: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20.0,
                                ),
                              ),
                              // User's mail
                              TyperAnimatedTextKit(
                                text: [_googleSignIn.currentUser.email],
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                                isRepeatingAnimation: false,
                              ),
                              //Signout Button
                              SignInButtonBuilder(
                                icon: Icons.logout,
                                text: 'Sign Out',
                                onPressed: () {
                                  _logout();
                                },
                                backgroundColor: Colors.red,
                              )
                            ],
                          ),
                        )
                      //If not Logged in..
                      : Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  //Backgrounf Gmail gradient
                                  image: NetworkImage(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTr-c9RV5eBUmf1aU25JOYdIGB2KZnweXyXxw&usqp=CAU"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              height: double.infinity,
                              width: double.infinity,
                            ),
                            //Sigin Button

                            Center(
                                child: Container(
                              width: 250,
                              height: 50,
                              child: SignInButton(
                                Buttons.Google,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(29)),
                                onPressed: () {
                                  _login();
                                },
                              ),
                            ))
                          ],
                        ),
                ),
              ),
            ),
            Divider(
              thickness: 5,
              color: Colors.pink,
              height: 4,
            ),
            //Facebook login
            Expanded(child: LoginWithFacebook())
          ],
        ),
      ),
    );
  }
}
