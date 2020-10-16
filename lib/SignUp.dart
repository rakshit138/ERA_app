import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name, _email, _password;
  bool _acceptTerms = false;
  bool _acceptPrivacy = false;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  terms() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Terms & Conditions',
            style: TextStyle(color: Color(0xff03258C)),
          ),
          content: Column(children: [
            Text(' Some Terms and condition'),
          ]),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Go Back',
                  style: TextStyle(color: Color(0xff03258C), fontSize: 14),
                ))
          ],
        );
      },
    );
  }

  privacy() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Privacy Policy',
            style: TextStyle(color: Color(0xff03258C)),
          ),
          content: Column(children: [Text('Some Privacy Text')]),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Go Back',
                  style: TextStyle(color: Color(0xff03258C), fontSize: 14),
                ))
          ],
        );
      },
    );
  }

  signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        User user = (await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        ))
            .user;
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
          {
            'email': _email,
            'name': _name,
          },
        );
        //signup sucessfully
        print("Signin sucessfully");
        // if (user != null) {
        //   UserUpdateInfo updateuser = UserUpdateInfo();
        //   updateuser.displayName = _name;
        //   user.updateProfile(updateuser);
        // }
      } catch (e) {
        showError(e.errormessage);
      }
    }
  }

  showError(String errormessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ERROR'),
          content: Text(errormessage),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 270,
                padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: Image(
                  image: AssetImage("assets/images/logo png 3.png"),
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 7, 15, 0),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) return 'Enter Name';
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Color(0xff03258C)),
                                  borderRadius: new BorderRadius.circular(25.7),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Color(0xff03258C), width: 3),
                                  borderRadius: new BorderRadius.circular(25.7),
                                ),
                                filled: true,
                                fillColor: Colors.amber,
                                labelStyle: TextStyle(
                                    color: Color(0xff03258C),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                labelText: 'Name',
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Color(0xff03258C),
                                ),
                              ),
                              onSaved: (input) => _name = input),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 7, 15, 0),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) return 'Enter Email';
                              },
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(10),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Color(0xff03258C)),
                                    borderRadius:
                                        new BorderRadius.circular(25.7),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Color(0xff03258C), width: 3),
                                    borderRadius:
                                        new BorderRadius.circular(25.7),
                                  ),
                                  filled: true,
                                  fillColor: Colors.amber,
                                  labelStyle: TextStyle(
                                      color: Color(0xff03258C),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  labelText: 'Email',
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Color(0xff03258C),
                                  )),
                              onSaved: (input) => _email = input),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 7, 15, 0),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: TextFormField(
                              validator: (input) {
                                if (input.length < 6)
                                  return 'Provide Minimum 6 Character';
                              },
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(10),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Color(0xff03258C)),
                                    borderRadius:
                                        new BorderRadius.circular(25.7),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Color(0xff03258C), width: 3),
                                    borderRadius:
                                        new BorderRadius.circular(25.7),
                                  ),
                                  filled: true,
                                  fillColor: Colors.amber,
                                  labelStyle: TextStyle(
                                      color: Color(0xff03258C),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  labelText: 'Password',
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Color(0xff03258C),
                                  )),
                              obscureText: true,
                              onSaved: (input) => _password = input),
                        ),
                      ),
                      // SizedBox(height: 20),
                      Row(
                        children: [
                          FlatButton(
                            onPressed: terms,
                            child: Text(
                              "Terms & Conditions",
                              style: TextStyle(
                                color: Color(0xff03258C),
                                fontSize: 18,
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: privacy,
                            child: Text(
                              "Privacy Policy",
                              style: TextStyle(
                                color: Color(0xff03258C),
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                      CheckboxListTile(
                        value: _acceptTerms,
                        onChanged: (bool value) {
                          setState(() {
                            _acceptTerms = value;
                          });
                        },
                        title: Text(
                          'Accept T&Cs',
                          style:
                              TextStyle(color: Color(0xff03258C), fontSize: 15),
                        ),
                        activeColor: Colors.amber,
                        checkColor: Color(0xff03258C),
                      ),
                      CheckboxListTile(
                        value: _acceptPrivacy,
                        onChanged: (bool value) {
                          setState(() {
                            _acceptPrivacy = value;
                          });
                        },
                        title: Text(
                          'Accept Privace Terms',
                          style:
                              TextStyle(color: Color(0xff03258C), fontSize: 15),
                        ),
                        activeColor: Colors.amber,
                        checkColor: Color(0xff03258C),
                      ),
                      Visibility(
                        visible: _acceptPrivacy,
                        child: Visibility(
                          visible: _acceptTerms,
                          child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                            onPressed: signUp,
                            child: Text(
                              'SignUp',
                              style: TextStyle(
                                color: Color(0xff03258C),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            color: Colors.amber,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
