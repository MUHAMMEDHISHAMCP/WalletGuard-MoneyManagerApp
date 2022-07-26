import 'package:flutter/material.dart';
import 'package:money_manager/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {


   final pagecontroller = PageController(initialPage: 0);
 bool currentPosition = true;
@override
  void dispose() {
    pagecontroller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    
     return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: pagecontroller,
        onPageChanged: (index){
          setState(() {
            currentPosition = index ==2;
          });
        },
        children: [
          pages(
              tittle: 'ALL YOUR FINANCE IN ONE APPLICATION',
              subtittle:
                  'Take control of your money and save them control of your expenses',
              img: Image.asset(
                'assets/onboardng1.png',
                height: 200,
                width: double.infinity,
              )),
          pages(
              tittle: 'TRACK YOUR EXPENSES EVERYWHERE',
              subtittle: 'You can easily track your  expense'
                  'from literally everywhere',
              img: Image.asset(
                'assets/onboarding2.png',
                height: 200,
              )),
          namefield(),
        ],
      ),
    
      
     );
  }

  pages({
    required String tittle,
    required Image img,
    String? subtittle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            img,
            const SizedBox(
              height: 20,
            ),
            Text(
              tittle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              subtittle!,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                pagecontroller.nextPage(
                    duration: const Duration(microseconds: 300),
                    curve: Curves.linear);
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(300, 40),
                primary: Colors.teal.shade400,
              ),
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  namefield() {
      final nameEditController = TextEditingController();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'WHAT IS YOUR \n NAME?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30, fontWeight: FontWeight.w800),
              ),
         
              Image.asset('assets/myprjct3.0.png'),
             
              Form(
                child: TextFormField(
                  controller: nameEditController,
                  decoration: const InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                          ),
                      label: Text('Enter Your Name')),
                     maxLength: 15,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    final _name = nameEditController.text;
                   if(_name.isEmpty){
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      elevation: 0,
        content: Text(
          'Enter Your Name',style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ));
                   }else{

                      final pref = await SharedPreferences.getInstance();
                      await pref.setString('savedValue', _name);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) =>  HomeScreen())));
                    
                   }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 30),
                    primary: Colors.teal.shade400,
                  ),
                  child: const Text('Start Now'))
            ],
          ),
        ),
      ),
    );
  }
}

