import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        decoration:const BoxDecoration(gradient:LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,
          colors:[Color(0xFF263E49),AppTheme.background,Color(0xFF17132D)])),
        child:SafeArea(child:SingleChildScrollView(child:Padding(
          padding:const EdgeInsets.fromLTRB(22,28,22,26),
          child:Column(children:[
            ClipRRect(borderRadius:BorderRadius.circular(25),child:Image.asset('assets/images/together.jpg',
              height:220,width:double.infinity,fit:BoxFit.cover,
              errorBuilder:(_,__,___)=>Container(height:220,color:AppTheme.surface,
                child:const Icon(Icons.favorite,size:60,color:AppTheme.pink)))),
            const SizedBox(height:20),
            const Row(mainAxisAlignment:MainAxisAlignment.center,children:[
              _HomeFace(image:'assets/images/nabeh.jpg',label:'Nabeh'),
              Padding(padding:EdgeInsets.symmetric(horizontal:15),child:Icon(Icons.favorite,color:AppTheme.pink,size:22)),
              _HomeFace(image:'assets/images/julia.jpg',label:'Julia'),
            ]),
            const SizedBox(height:20),
            const Text('NABEH & JULIA',textAlign:TextAlign.center,
              style:TextStyle(fontSize:27,letterSpacing:2.5,fontWeight:FontWeight.w900)),
            const SizedBox(height:7),
            const Text('BEYOND TWO HEARTS',style:TextStyle(color:AppTheme.gold,fontSize:11,letterSpacing:3.5,fontWeight:FontWeight.w700)),
            const SizedBox(height:17),
            const Text('It began on two university benches.\nTwo shy hearts. One conversation.\nA story that was about to begin.',
              textAlign:TextAlign.center,style:TextStyle(color:Colors.white70,height:1.6,fontSize:14)),
            const SizedBox(height:22),
            const Row(mainAxisAlignment:MainAxisAlignment.center,children:[
              _ChapterDot(number:'1'),_ChapterDot(number:'2'),_ChapterDot(number:'3'),
              _ChapterDot(number:'4'),_ChapterDot(number:'★'),
            ]),
            const SizedBox(height:8),
            const Text('5 CHAPTERS • 5 MEETINGS • ONE BIG HUG',textAlign:TextAlign.center,
              style:TextStyle(color:Colors.white54,fontSize:9,letterSpacing:1.1)),
            const SizedBox(height:24),
            SizedBox(width:double.infinity,height:55,child:FilledButton(
              style:FilledButton.styleFrom(backgroundColor:AppTheme.pink,foregroundColor:const Color(0xFF291326),
                shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(18))),
              onPressed:()=>Navigator.of(context).push(MaterialPageRoute<void>(builder:(_)=>const GameScreen())),
              child:const Text('BEGIN WHERE WE BEGAN',style:TextStyle(fontWeight:FontWeight.w900,letterSpacing:1)))),
            const SizedBox(height:13),
            const Text('A little world made for two ♥',style:TextStyle(color:Colors.white38,fontSize:12)),
          ]),
        ))),
      ),
    );
  }
}

class _HomeFace extends StatelessWidget {
  const _HomeFace({required this.image,required this.label});
  final String image,label;
  @override
  Widget build(BuildContext context)=>Column(children:[
    CircleAvatar(radius:31,backgroundColor:AppTheme.surface,backgroundImage:AssetImage(image)),
    const SizedBox(height:5),
    Text(label,style:const TextStyle(color:Colors.white70,fontSize:11)),
  ]);
}

class _ChapterDot extends StatelessWidget {
  const _ChapterDot({required this.number});
  final String number;
  @override
  Widget build(BuildContext context)=>Container(
    margin:const EdgeInsets.symmetric(horizontal:5),width:31,height:31,
    decoration:BoxDecoration(shape:BoxShape.circle,color:AppTheme.surface,border:Border.all(color:AppTheme.pink.withOpacity(.65))),
    child:Center(child:Text(number,style:const TextStyle(color:AppTheme.gold,fontWeight:FontWeight.bold))),
  );
}
