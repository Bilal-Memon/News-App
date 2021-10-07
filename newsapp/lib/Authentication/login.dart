import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsapp/Authentication/signUp.dart';
import 'package:newsapp/Home/home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var email = '';
  var password = '';

  login() async {
    setState(() {
      email = '';
      password = '';
    });
    try {
      UserCredential loginUser = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    }
    // if (loginUser==null) {

    // }
    on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
  }

  Widget input(context, name, type, formate, hash, suggestion) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.07,
          child: TextFormField(
            keyboardType: type,
            inputFormatters: formate,
            onChanged: (e) => {
              name == 'Email'
                  ? setState(() {
                      email = e;
                    })
                  : name == 'Password'
                      ? setState(() {
                          password = e;
                        })
                      : null
            },
            style: TextStyle(fontSize: 17, color: Colors.black),

            obscureText: hash, //true
            enableSuggestions: suggestion, //false
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.only(left: 10, right: 10),
              // isDense: true,
              enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  )),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: const BorderSide(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
            child: Scaffold(
                // resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  leading: BackButton(
                      color: Colors.black,
                      onPressed: () => Navigator.popUntil(
                          context, ModalRoute.withName('/'))),
                  title: Text('Login',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  centerTitle: true,
                ),
                body: Container(
                    height: height * 1,
                    color: Colors.blue[300],
                    child: SingleChildScrollView(
                        // reverse: true,
                        child: Center(
                            child: Column(
                      children: [
                        SizedBox(height: height * 0.1),
                        MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                                onTap: () {},
                                child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 60,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 58,
                                      backgroundImage: AssetImage(
                                          'assets/images/516-5167304_transparent-background-white-user-icon-png-png-download.png'),
                                    )))),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        input(context, 'Email', TextInputType.emailAddress,
                            null, false, true),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        input(context, 'Password', TextInputType.text, null,
                            true, false),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.06,
                            child: ElevatedButton(
                              onPressed:
                                  //  _isButtonDisabled ? null :
                                  login,
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white)),
                            )),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Create New Account  ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15)),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUp()));
                                },
                                child: Text('Sign Up',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                      ],
                    )))))));
  }
}
