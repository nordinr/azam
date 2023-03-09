import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jkpsb2/util/function.dart';
import 'package:jkpsb2/util/colors.dart';
import 'package:jkpsb2/screens/signup.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Signin extends StatefulWidget {

  Signin({Key key}) : super(key: key);
  //MenuOption(this.title,this.imageUrl,this.discount);

  @override
  _SigninState createState() => _SigninState();
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}


class _SigninState extends State<Signin> {
  bool _visible = true;
  var phonenoTextController =  TextEditingController();
  var passwordTextController =  TextEditingController();

  var emailresetController = new TextEditingController();

  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;



  @override
  void initState() {
    super.initState();
    // phonenoTextController.text="jkpsb@gmail.com";
    //passwordTextController.text="0000000000";
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
          ? _SupportState.supported
          : _SupportState.unsupported),
    );
  }

  /*Start function biometric*/

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

/*  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason: 'Let OS determine authentication method',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
            () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }*/

  Future<void> _authenticateWithBiometrics(paramphoneno) async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate ${paramphoneno}',
        options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
            biometricOnly: true
        ),

      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  /*End function biometric*/

  Future bottomAttachment(){
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 30,),
              Center(
                child: Text("Sila masukkan emel."),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                child:

                TextField(

                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Emel',
                    labelText: 'Emel',
                  ),
                  controller:  emailresetController,
                ),
              ),
              SizedBox(height: 30,),
              MaterialButton(
                minWidth: MediaQuery.of(context).size.width * 0.90,
                onPressed: (){
                  if(emailresetController.text!="")
                  {

                    _resetPasword(emailresetController.text);

                  }
                  else{
                    Alert(
                        context: context,
                        title:
                        "Sila masukkan email.",
                        buttons: [

                          DialogButton(
                            color:maincolor,
                            onPressed: (){
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: const Text(
                              "OK",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )

                        ]).show();
                  }
                },
                textColor: Colors.white,
                color:maincolor,
                padding: const EdgeInsets.all(2.0),
                child: const Text(
                  "Reset Kata laluan",
                ),
              ),
              SizedBox(height: 30,),

            ],
          );
        });
  }


  _submitlogin(paramphone,parampass) async {
    print("xxxxxxx");
    var data = {
      "action": "login",
      "user_phone":paramphone,
      "user_password":parampass
    };
    var returnData = await dioHttpPostRequest(context,data,"login.php",1,"Please wait..","brewing data..");
    print(returnData);
    //print(returnData['data'][1]['username'].toString());



    if(returnData!="errorException"){
      Navigator.pop(context);
      if(returnData['status']==true){
        String username=returnData['data'][0]['username'].toString();
        String user_id=returnData['data'][0]['user_id'].toString();
        String user_email=returnData['data'][0]['user_email'].toString();
        String user_type=returnData['data'][0]['user_type'].toString();
        String device_token=returnData['data'][0]['device_token'].toString();

        await setlocalMemoryData("string","username",username);
        await setlocalMemoryData("string","user_id",user_id);
        await setlocalMemoryData("string","user_email",user_email);
        await setlocalMemoryData("string","user_type",user_type);
        await setlocalMemoryData("string","device_token",device_token);

        Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);

        // screenLoadingx(context,"",returnData['mesejayat'].toString(),true,true,false);
        //Navigator.of(context).pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);

        // _myorder();

/*
        Map<String, dynamic> map = returnData;
        List<dynamic> data = map["data"];
        List<Jadual> Jaduals = [];
        for (int i = 0; i < returnData['count_result']; i++) {
          Jadual user = Jadual(data[i]['codecategori'],data[i]['categoryname']);

          Jaduals.add(user);
        }

        return Jaduals;*/
      }else{
        screenLoadingx(context,"",returnData['msgtxt'].toString(),true,true,false);
        /*if(returnData['count_result']=="0"){
          setState(() {
            statusrekod="false";
          });

        }else{

          Navigator.of(context).pushNamedAndRemoveUntil('/Menu', (Route<dynamic> route) => false);
          screenLoadingx(context,"",returnData['mesejayat'].toString(),true,true,false);

        }*/

      }


    }/*else{
      screenLoadingx(context,"",returnData.toString(),true,true,false);
    }*/



  }

  _resetPasword(emailreset) async {
    print("xxxxxxx");
    var data = {
      "action": "resetpassword",
      "user_email":emailreset
    };
    var returnData = await dioHttpPostRequest(context,data,"resetpassword.php",1,"Please wait..","Checking data..");
    print(returnData);
    //print(returnData['data'][1]['username'].toString());



    if(returnData!="errorException"){
      Navigator.pop(context);
      if(returnData['status']==true){
        screenLoadingx(context,"",returnData['mesejayat'].toString(),true,true,false);
      }else{
        screenLoadingx(context,"",returnData['msgtxt'].toString(),true,true,false);


      }


    }/*else{
      screenLoadingx(context,"",returnData.toString(),true,true,false);
    }*/



  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xffeeeee4),
          child: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height ,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Color(0xffeeeee4),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 150,),
                  Center(
                    child:  Image.asset("assets/truelogo2.png",width: 170,),
                  ),
                  SizedBox(height: 15,),


                  Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 1,
                            color: Colors.white
                        ),

                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: TextField(
                          controller: phonenoTextController ,
                          cursorColor: cofeehight,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(color: Colors.black),
                            icon: Icon(Icons.mail,color: cofeehight,),
                            hintText: "Email",
                            labelText: "Emel",
                            focusColor: cofeehight,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            filled: false,
                            border: InputBorder.none,
                            //border: OutlineInputBorder(),
                          ),
                        ),
                      )

                    /* Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextField(
                        controller: phonenoTextController ,
                        cursorColor: cofeehight,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(color: Colors.black),
                          icon: Icon(Icons.phone,color: cofeehight,),
                          hintText: "Phone number without (-)",
                          labelText: "Phone Number",
                          focusColor: cofeehight,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          filled: false,
                          border: InputBorder.none,
                          //border: OutlineInputBorder(),
                        ),
                      ),
                    )*/
                    //IntrinsicHeight

                  ),



                  const SizedBox(
                    height: 10,
                  ),
                  // InputField(
                  //   headerText: "Email",
                  //   hintTexti: "dion@example.com",
                  //   visible: false,
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),

                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 1,
                          color: Colors.white
                      ),

                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextField(
                        controller: passwordTextController,
                        cursorColor: cofeehight,
                        style: const TextStyle(color: Colors.black),
                        obscureText: _visible,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(
                                color: Colors.black
                            ),
                            isCollapsed: false,
                            hintText: "At least 8 Charecter",
                            labelText: "Katalaluan",
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            filled: false,
                            border: InputBorder.none,
                            icon: const Icon(Icons.lock,color: cofeehight),
                            suffixIcon: IconButton(
                                color: cofeehight,
                                padding: const EdgeInsets.all(0),
                                icon: Icon(
                                    _visible ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _visible = !_visible;
                                  });
                                })
                        ),
                      ),
                    ),
                  ),

                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisAlignment: MainAxisAlignment.end,

                    children: [
                      //const CheckerBox(),
                      Container(
                        margin: EdgeInsets.only(right: 20,top:15,bottom: 15),
                        child: InkWell(
                          onTap: () {
                            bottomAttachment();
                          },
                          child: const Text(
                            "Lupa Katalaluan?",
                            style: TextStyle(
                                color: cofeehight,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),



                  Container(
                      height: 50,
                      child: Row(
                          children : <Widget>[
                            Expanded(
                              child:SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: InkWell(
                                  onTap: () {
                                    _submitlogin(phonenoTextController.text,passwordTextController.text);

                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    //height: 200,//MediaQuery.of(context).size.height * 0.07,
                                    margin: const EdgeInsets.only(left: 20,right: 20),
                                    decoration: const BoxDecoration(
                                      color: maincolor,//Color(0xFFFFCB3F),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)
                                      ),

                                    ),
                                    /*decoration: BoxDecoration(
                                            color: Color(0xFFFFCB3F),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),*/
                                    child: const Center(
                                      child: Text(
                                        "Daftar Masuk",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,//cofeehight,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            /*   Container(
                              //width: MediaQuery.of(context).size.width * 0.2,
                              //height: double.infinity,
                              //width: double.infinity,
                              margin: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: maincolor,//cofeelow,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              *//*child: InkWell(
                                onTap: () {

                                },*//*
                              child: IconButton(
                                  icon: const Icon(Icons.fingerprint),
                                  color: Colors.white,
                                  iconSize: 35.0,
                                  onPressed: () {
                                    print("zzzzz");
                                    _authenticateWithBiometrics("0123232333");
                                  }
                              ),
                              // ),
                            ),
*/
                          ])
                  ),
                  const SizedBox(height: 15,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                            text: "",
                            style: TextStyle(
                                color: cofeehight.withOpacity(0.8), fontSize: 16),
                            children: [
                              TextSpan(
                                  text: "Daftar Akaun",
                                  style: const TextStyle(color: cofeehight, fontSize: 16,fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SignUp()));
                                      print("Sign Up click");
                                    }),
                            ]),
                      ),
                    ],
                  ),


                  /* Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 30),
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (_supportState == _SupportState.unknown)
                            const CircularProgressIndicator()
                          else if (_supportState == _SupportState.supported)
                            const Text('This device is supported')
                          else
                            const Text('This device is not supported'),
                          const Divider(height: 100),
                          Text('Can check biometrics: $_canCheckBiometrics\n'),
                          ElevatedButton(
                            child: const Text('Check biometrics'),
                            onPressed: _checkBiometrics,
                          ),
                          const Divider(height: 100),
                          Text('Available biometrics: $_availableBiometrics\n'),
                          ElevatedButton(
                            child: const Text('Get available biometrics'),
                            onPressed: _getAvailableBiometrics,
                          ),
                          const Divider(height: 100),
                          Text('Current State: $_authorized\n'),
                          if (_isAuthenticating)
                            ElevatedButton(
                              onPressed: _cancelAuthentication,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const <Widget>[
                                  Text('Cancel Authentication'),
                                  Icon(Icons.cancel),
                                ],
                              ),
                            )
                          else
                            Column(
                              children: <Widget>[
                                ElevatedButton(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const <Widget>[
                                      Text('Authenticate'),
                                      Icon(Icons.perm_device_information),
                                    ],
                                  ),
                                  onPressed: _authenticate,
                                ),
                                ElevatedButton(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(_isAuthenticating
                                            ? 'Cancel'
                                            : 'Authenticate: biometrics only'),
                                        const Icon(Icons.fingerprint),
                                      ],
                                    ),
                                    onPressed:(){
                                      _authenticateWithBiometrics("232332122");
                                    }
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CheckerBox extends StatefulWidget {
  const CheckerBox({
    Key key,
  }) : super(key: key);

  @override
  State<CheckerBox> createState() => _CheckerBoxState();
}

class _CheckerBoxState extends State<CheckerBox> {
  bool isCheck;
  @override
  void initState() {
    // TODO: implement initState
    isCheck = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
              value: isCheck,
              checkColor: whiteshade, // color of tick Mark
              activeColor: cofeehight,
              onChanged: (val) {
                setState(() {
                  isCheck = val;
                  print(isCheck);
                });
              }),
          Text.rich(
            TextSpan(
              text: "Remember me",
              style: TextStyle(color: cofeehight.withOpacity(0.8), fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}




