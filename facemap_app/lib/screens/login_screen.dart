import 'package:facemap_app/api/auth.dart';
import 'package:facemap_app/screens/dashboard.dart';
import 'package:facemap_app/utils/result.dart';
import 'package:facemap_app/utils/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginScreen(),
//     );
//   }
// }

enum loginOptions { login, register }

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userNameControler, emailController, passwordController;
  loginOptions option = loginOptions.login;

  @override
  void initState() {
    emailController = TextEditingController();
    userNameControler = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/parchment_paper1.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * .75,
              child: Card(
                elevation: 5.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.centerRight,
                      width: kIsWeb
                          ? MediaQuery.of(context).size.width * .3
                          : MediaQuery.of(context).size.width * .6,
                      height: kIsWeb
                          ? MediaQuery.of(context).size.width * .4
                          : MediaQuery.of(context).size.width * .7,
                      child: Card(
                        elevation: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  option == loginOptions.login
                                      ? "Login"
                                      : "Register",
                                  style: TextStyle(fontSize: Styles.txt_h1),
                                )),
                            option == loginOptions.register
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 40),
                                    child: TextField(
                                      controller: userNameControler,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Username',
                                          hintText: 'Enter Username'),
                                    ),
                                  )
                                : SizedBox(),
                            Padding(
                              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 5.0),
                              child: TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Email',
                                    hintText:
                                        'Enter valid email id as abc@gmail.com'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 40.0, right: 40.0, top: 0, bottom: 0),
                              //padding: EdgeInsets.symmetric(horizontal: 15),
                              child: TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Password',
                                    hintText: 'Enter secure password'),
                              ),
                            ),
                            FlatButton(
                              color: Colors.blue,
                              onPressed: () async {
                                if (option == loginOptions.login) {
                                  Result result = await AuthenticationApi.login(
                                      emailController.text,
                                      passwordController.text);
                                  if (result.isSuccess) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => DashBoard()));
                                  }
                                } else {
                                  Result result = await AuthenticationApi.register_user({
                                    "username": userNameControler.text,
                                    "email": emailController.text,
                                    "password": passwordController.text
                                  });
                                  if (result.isSuccess) {
                                    setState(() {
                                      option = loginOptions.login;
                                    });
                                  }
                                }
                              },
                              child: Text(
                                'SUBMIT',
                              ),
                            ),
                            FlatButton(
                                onPressed: () {
                                  setState(() {
                                    if (option == loginOptions.login)
                                      option = loginOptions.register;
                                    else
                                      option = loginOptions.login;
                                  });
                                },
                                child: Text('New User? Create Account'))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.amber[200],
                      alignment: Alignment.center,
                      height: kIsWeb
                          ? MediaQuery.of(context).size.width * .4
                          : MediaQuery.of(context).size.width * .7,
                      child: Card(
                        color: Colors.amber[200],
                        elevation: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image.asset(
                              "assets/realtime_surveillance_system.png",
                              width: MediaQuery.of(context).size.width * .35,
                              alignment: Alignment.center,
                              fit: BoxFit.fitWidth,
                            ),
                            Text("Team",
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold)),
                            Text(
                              "17211a1287  Vijay Kumar",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Text("17211a1289  Chakradhar Reddy",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left),
                            Text("17211a1291  Puneeth",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left),
                            Text("17211a1297  Rakesh",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    userNameControler.clear();
    emailController.clear();
    passwordController.clear();
    super.dispose();
  }
}
