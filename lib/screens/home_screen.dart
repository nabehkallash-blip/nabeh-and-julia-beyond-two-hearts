import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../music/music_controller.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(children:[
      const Positioned.fill(child: DecoratedBox(decoration:BoxDecoration(
        gradient:LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,
          colors:[Color(0xFF332044),Color(0xFF100D20),Color(0xFF102B3A)])))),
      Positioned(top:-90,right:-65,child:_GlowOrb(color:AppTheme.pink.withOpacity(.20),size:240)),
      Positioned(bottom:80,left:-100,child:_GlowOrb(color:AppTheme.violet.withOpacity(.16),size:260)),
      SafeArea(child:SingleChildScrollView(
        padding:const EdgeInsets.fromLTRB(20,16,20,30),
        child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
          Row(children:[
            Container(padding:const EdgeInsets.symmetric(horizontal:13,vertical:8),
              decoration:BoxDecoration(color:Colors.white.withOpacity(.08),borderRadius:BorderRadius.circular(30),
                border:Border.all(color:Colors.white.withOpacity(.14))),
              child:const Row(children:[Icon(Icons.auto_awesome,color:AppTheme.gold,size:15),SizedBox(width:7),
                Text('A STORY MADE FOR TWO',style:TextStyle(fontSize:9,letterSpacing:1.3,fontWeight:FontWeight.w800))])),
            const Spacer(),
            ValueListenableBuilder<bool>(valueListenable:MusicController.enabled,builder:(context,on,_)=>IconButton(
              tooltip:on?'Mute music':'Play music',onPressed:MusicController.toggle,
              icon:Icon(on?Icons.volume_up_rounded:Icons.volume_off_rounded,color:AppTheme.gold,size:21))),
            const Icon(Icons.favorite,color:AppTheme.pink,size:20),
          ]),
          const SizedBox(height:20),
          Container(height:280,clipBehavior:Clip.antiAlias,
            decoration:BoxDecoration(borderRadius:BorderRadius.circular(30),
              border:Border.all(color:Colors.white.withOpacity(.18)),
              boxShadow:[BoxShadow(color:AppTheme.pink.withOpacity(.13),blurRadius:35)]),
            child:Stack(fit:StackFit.expand,children:[
              Image.asset('assets/images/together.jpg',fit:BoxFit.cover,
                errorBuilder:(_,__,___)=>const DecoratedBox(decoration:BoxDecoration(
                  gradient:LinearGradient(colors:[Color(0xFF59406D),Color(0xFF203A4C)])),
                  child:Center(child:Icon(Icons.favorite,color:AppTheme.pink,size:90)))),
              const DecoratedBox(decoration:BoxDecoration(gradient:LinearGradient(
                begin:Alignment.topCenter,end:Alignment.bottomCenter,
                colors:[Colors.transparent,Color(0xEE100D20)],stops:[.25,1]))),
              const Positioned(top:15,left:15,child:_GlassPill(icon:Icons.auto_awesome,text:'YOUR ADVENTURE BEGINS')),
              const Positioned(left:20,right:20,bottom:22,child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                Text('NABEH  &  JULIA',style:TextStyle(fontSize:27,letterSpacing:2.2,fontWeight:FontWeight.w900,
                  shadows:[Shadow(color:Colors.black54,blurRadius:14)])),
                SizedBox(height:5),Text('BEYOND TWO HEARTS',style:TextStyle(color:AppTheme.gold,fontSize:11,letterSpacing:3.1,fontWeight:FontWeight.w800)),
                SizedBox(height:9),Text('Two benches. A thousand messages. One story worth every step.',
                  style:TextStyle(color:Colors.white70,fontSize:12,height:1.4)),
              ])),
            ])),
          const SizedBox(height:20),
          const _ConstellationCard(),
          const SizedBox(height:18),
          Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(
            color:Colors.white.withOpacity(.055),borderRadius:BorderRadius.circular(22),
            border:Border.all(color:Colors.white.withOpacity(.10))),
            child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Row(children:[const Expanded(child:Text('THE JOURNEY',style:TextStyle(fontWeight:FontWeight.w900,letterSpacing:1.5,fontSize:11))),
                Text('6 CHAPTERS',style:TextStyle(color:AppTheme.gold,fontSize:10,fontWeight:FontWeight.w800))]),
              const SizedBox(height:13),
              Row(children:List.generate(6,(i)=>Expanded(child:Container(height:7,
                margin:EdgeInsets.only(right:i==5?0:6),decoration:BoxDecoration(borderRadius:BorderRadius.circular(9),
                  gradient:LinearGradient(colors:i==0?[AppTheme.pink,AppTheme.gold]:
                    [Colors.white.withOpacity(.18),Colors.white.withOpacity(.08)])))))),
              const SizedBox(height:12),
              const Text('Explore the university, follow the messages, solve the memories, paint your names, and find your way to the final hug.',
                style:TextStyle(color:Colors.white60,fontSize:12,height:1.55)),
            ])),
          const SizedBox(height:20),
          SizedBox(height:58,child:FilledButton(
            style:FilledButton.styleFrom(backgroundColor:AppTheme.pink,foregroundColor:const Color(0xFF291326),
              elevation:8,shadowColor:AppTheme.pink.withOpacity(.35),
              shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(19))),
            onPressed:()=>Navigator.of(context).push(MaterialPageRoute<void>(builder:(_)=>const GameScreen())),
            child:const Row(mainAxisAlignment:MainAxisAlignment.center,children:[
              Icon(Icons.play_arrow_rounded,size:25),SizedBox(width:8),
              Text('BEGIN WHERE WE BEGAN',style:TextStyle(fontWeight:FontWeight.w900,letterSpacing:1.1)),
              SizedBox(width:7),Icon(Icons.favorite,size:15),
            ]))),
          const SizedBox(height:14),
          const Center(child:Text('Made of memories. Built for two.  ♥',
            style:TextStyle(color:Colors.white38,fontSize:11,letterSpacing:.5))),
        ]),
      )),
    ]),
  );
}

class _ConstellationCard extends StatefulWidget {
  const _ConstellationCard();
  @override
  State<_ConstellationCard> createState()=>_ConstellationCardState();
}

class _ConstellationCardState extends State<_ConstellationCard> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse=AnimationController(vsync:this,duration:const Duration(milliseconds:2200))..repeat(reverse:true);
  static const memories=[
    ('THE BENCHES',.12,.30),('THE FIRST WORDS',.48,.13),('THE SECRET',.86,.32),
    ('THE REVEAL',.82,.76),('THE PROMISES',.48,.88),('THE REUNION',.13,.72),
  ];
  @override
  void dispose(){_pulse.dispose();super.dispose();}
  @override
  Widget build(BuildContext context)=>AnimatedBuilder(animation:_pulse,builder:(context,_) {
    final p=_pulse.value;
    return Container(height:260,padding:const EdgeInsets.all(16),
      decoration:BoxDecoration(borderRadius:BorderRadius.circular(24),
        color:const Color(0xFF17152A).withOpacity(.88),
        border:Border.all(color:AppTheme.gold.withOpacity(.22)),
        boxShadow:[BoxShadow(color:AppTheme.violet.withOpacity(.10),blurRadius:28)]),
      child:Stack(children:[
        const Positioned(left:0,top:0,child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text('THE THREAD BETWEEN US',style:TextStyle(color:AppTheme.gold,fontSize:11,fontWeight:FontWeight.w900,letterSpacing:1.5)),
          SizedBox(height:4),Text('Six moments. One continuous story.',style:TextStyle(color:Colors.white54,fontSize:10)),
        ])),
        Positioned.fill(top:45,child:CustomPaint(painter:_ConstellationPainter(p)),
        ),
        for(var i=0;i<memories.length;i++)
          Positioned(
            left:memories[i].$2* (MediaQuery.of(context).size.width-72)-24,
            top:54+memories[i].$3*145-8,
            child:Column(mainAxisSize:MainAxisSize.min,children:[
              Icon(i==5?Icons.favorite:Icons.auto_awesome,
                size:i==5?19:15,color:i==5?AppTheme.pink:AppTheme.gold.withOpacity(.75+.25*p)),
              const SizedBox(height:3),
              Text(memories[i].$1,style:const TextStyle(fontSize:7,color:Colors.white70,fontWeight:FontWeight.w800,letterSpacing:.35)),
            ]),
          ),
        Positioned(left:0,right:0,top:112,child:Center(
          child:Transform.scale(scale:1+p*.18,child:Container(
            width:43,height:43,decoration:BoxDecoration(shape:BoxShape.circle,
              color:AppTheme.pink.withOpacity(.13),border:Border.all(color:AppTheme.pink.withOpacity(.6)),
              boxShadow:[BoxShadow(color:AppTheme.pink.withOpacity(.18+.16*p),blurRadius:20+10*p)]),
            child:const Icon(Icons.favorite,color:AppTheme.pink,size:22))),
        )),
        const Positioned(bottom:0,left:0,right:0,child:Text('A little universe made from the moments that brought two hearts together.',
          textAlign:TextAlign.center,style:TextStyle(color:Colors.white38,fontSize:9,height:1.4))),
      ]),
    );
  });
}

class _ConstellationPainter extends CustomPainter {
  _ConstellationPainter(this.pulse);
  final double pulse;
  @override
  void paint(Canvas canvas,Size size) {
    final points=[Offset(size.width*.12,size.height*.30),Offset(size.width*.48,size.height*.13),
      Offset(size.width*.86,size.height*.32),Offset(size.width*.82,size.height*.76),
      Offset(size.width*.48,size.height*.88),Offset(size.width*.13,size.height*.72)];
    final line=Paint()..style=PaintingStyle.stroke..strokeWidth=1.5
      ..shader=const LinearGradient(colors:[AppTheme.violet,AppTheme.pink,AppTheme.gold]).createShader(Offset.zero&size);
    final path=Path()..moveTo(points.first.dx,points.first.dy);
    for(var i=1;i<points.length;i++) {
      final mid=Offset((points[i-1].dx+points[i].dx)/2,(points[i-1].dy+points[i].dy)/2-10);
      path.quadraticBezierTo(mid.dx,mid.dy,points[i].dx,points[i].dy);
    }
    path.quadraticBezierTo(size.width*.5,size.height*.52,points.first.dx,points.first.dy);
    canvas.drawPath(path,line);
    for(var i=0;i<points.length;i++) {
      final glow=Paint()..color=(i==5?AppTheme.pink:AppTheme.gold).withOpacity(.10+.10*pulse)
        ..maskFilter=const MaskFilter.blur(BlurStyle.normal,7);
      canvas.drawCircle(points[i],7+2*pulse,glow);
      final dot=Paint()..color=i==5?AppTheme.pink:AppTheme.gold;
      canvas.drawCircle(points[i],2.8,dot);
    }
    final orbit=Paint()..color=Colors.white.withOpacity(.045)..style=PaintingStyle.stroke..strokeWidth=1;
    canvas.drawCircle(Offset(size.width*.5,size.height*.51),math.min(size.width,size.height)*.34,orbit);
  }
  @override
  bool shouldRepaint(covariant _ConstellationPainter old)=>old.pulse!=pulse;
}

class _GlassPill extends StatelessWidget {
  const _GlassPill({required this.icon,required this.text});
  final IconData icon; final String text;
  @override
  Widget build(BuildContext context)=>Container(
    padding:const EdgeInsets.symmetric(horizontal:11,vertical:8),
    decoration:BoxDecoration(color:Colors.black.withOpacity(.30),borderRadius:BorderRadius.circular(20),
      border:Border.all(color:Colors.white24)),
    child:Row(children:[Icon(icon,color:AppTheme.gold,size:13),const SizedBox(width:6),
      Text(text,style:const TextStyle(fontSize:8,letterSpacing:1,fontWeight:FontWeight.w800))]),
  );
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color,required this.size});
  final Color color; final double size;
  @override
  Widget build(BuildContext context)=>IgnorePointer(child:Container(width:size,height:size,
    decoration:BoxDecoration(shape:BoxShape.circle,boxShadow:[BoxShadow(color:color,blurRadius:90,spreadRadius:25)])));
}
