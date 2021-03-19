import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginWithFacebook extends StatefulWidget {
  @override
  _LoginWithFacebookState createState() => _LoginWithFacebookState();
}

class _LoginWithFacebookState extends State<LoginWithFacebook> {
  bool isSignIn = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;
  FacebookLogin facebookLogin = FacebookLogin();
  //Facebook login

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSignIn
          //If Facebook logged in..

          ? Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  //Background frame

                  image: NetworkImage(
                      "https://png.pngtree.com/thumb_back/fw800/background/20200526/pngtree-pink-baby-card-with-flowers-for-girls-image_336612.jpg"),
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //User's Details

                  children: <Widget>[
                    SizedBox(
                      height: 60,
                    ),
                    // User's photo

                    CircleAvatar(
                      radius: 55,
                      backgroundImage: NetworkImage(_user.photoURL),
                    ),
                    // User's name
                    TyperAnimatedTextKit(
                      text: [
                        _user.displayName,
                      ],
                      textStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // User's mail
                    TyperAnimatedTextKit(
                      isRepeatingAnimation: false,
                      text: [_user.email],
                      textStyle: TextStyle(
                        // backgroundColor: Colors.pinkAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                      ),
                    ),
                    //Signout Button
                    SignInButtonBuilder(
                      icon: Icons.logout,
                      text: 'Sign Out',
                      onPressed: () {
                        gooleSignout();
                      },
                      backgroundColor: Colors.red,
                    )
                  ],
                ),
              ),
            )
          //If not Logged in..

          : Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      //Background Facebook gradient

                      image: NetworkImage(
                          "https://htmlcolors.com/gradients-images/26-caribbean-waters-gradient.jpg"),
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
                  child: SignInButtonBuilder(
                    fontSize: 13,
                    text: 'Sign in with Facebook',
                    icon: FontAwesomeIcons.facebookF,
                    image: ClipRRect(
                      child: Image(
                        image: AssetImage(
                          'assets/logos/facebook_new.png',
                          package: 'flutter_signin_button',
                        ),
                        height: 24.0,
                      ),
                    ),
                    backgroundColor: Color(0xFF1877f2),
                    onPressed: () async {
                      await handleLogin();
                    },
                    padding: EdgeInsets.fromLTRB(12, 0, 11, 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(29)),
                  ),
                ))
              ],
            ),
    );
  }
// login function

  Future<void> handleLogin() async {
    final FacebookLoginResult result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
      case FacebookLoginStatus.loggedIn:
        try {
          await loginWithfacebook(result);
        } catch (e) {
          print(e);
        }
        break;
    }
  }
//Facebook login function

  Future loginWithfacebook(FacebookLoginResult result) async {
    final FacebookAccessToken accessToken = result.accessToken;
    AuthCredential credential =
        FacebookAuthProvider.credential(accessToken.token);
    var a = await _auth.signInWithCredential(credential);
    setState(() {
      isSignIn = true;
      _user = a.user;
    });
  }
// logout function

  Future<void> gooleSignout() async {
    await _auth.signOut().then((onValue) {
      setState(() {
        facebookLogin.logOut();
        isSignIn = false;
      });
    });
  }
}
// THANK YOU
