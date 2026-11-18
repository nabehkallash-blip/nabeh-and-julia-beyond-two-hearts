import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const chapters = [
    _Chapter('TWO BENCHES, ONE BEGINNING', 'Damascus University. Two different benches. One conversation on two phones.', 1, 'The first little step toward hello.'),
    _Chapter('A LITTLE MORE COURAGE', 'The distance feels smaller. Follow the little lights and find each other.', 2, 'A little braver, a little closer.'),
    _Chapter('MOMENTS THAT CONNECT US', 'Every glowing heart is a reminder that small moments bring two people closer.', 3, 'Another meeting. Another high-five.'),
    _Chapter('STRONGER TOGETHER', 'The path is longer now. Collect the hearts and make your way across.', 4, 'Whatever the path looks like, keep choosing each other.'),
    _Chapter('BEYOND TWO HEARTS', 'The final challenge. Gather every heart and reach Julia for the most important reunion.', 5, 'This time, it is not a high-five. It is a hug.'),
  ];
  static const heartSpots = [
    Offset(.31, .68), Offset(.48, .49), Offset(.64, .35),
    Offset(.39, .29), Offset(.72, .68),
  ];

  int chapterIndex = 0;
  Offset player = const Offset(.12, .80);
  final Set<int> collected = {};
  bool reunited = false;
  _Chapter get chapter => chapters[chapterIndex];
  bool get isFinal => chapterIndex == chapters.length - 1;

  void _movePlayer(DragUpdateDetails details, Size size) {
    if (reunited) return;
    setState(() {
      player = Offset(
        (player.dx + details.delta.dx / size.width).clamp(.07, .93).toDouble(),
        (player.dy + details.delta.dy / size.height).clamp(.09, .91).toDouble(),
      );
      for (var i = 0; i < chapter.hearts; i++) {
        final p = heartSpots[i];
        final d = math.sqrt(math.pow(player.dx-p.dx, 2).toDouble() + math.pow(player.dy-p.dy, 2).toDouble());
        if (d < .085) collected.add(i);
      }
      final d = math.sqrt(math.pow(player.dx-.84, 2).toDouble() + math.pow(player.dy-.20, 2).toDouble());
      if (d < .115 && collected.length >= chapter.hearts) reunited = true;
    });
  }

  void _next() {
    if (isFinal) { Navigator.pop(context); return; }
    setState(() {
      chapterIndex++;
      player = const Offset(.12, .80);
      collected.clear();
      reunited = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CHAPTER 0${chapterIndex+1} · ${chapter.title}',
        style: const TextStyle(fontSize: 9, letterSpacing: .6)), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 2, 14, 14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text('A little closer…', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800))),
              Text('${chapterIndex+1} / ${chapters.length}', style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 4),
            Text(chapter.description, style: const TextStyle(color: Colors.white70, height: 1.35, fontSize: 12)),
            const SizedBox(height: 9),
            Row(children: List.generate(chapter.hearts, (i) => Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(collected.contains(i) ? Icons.favorite : Icons.favorite_border, color: AppTheme.pink, size: 19),
            ))),
            const SizedBox(height: 8),
            Expanded(child: LayoutBuilder(builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);
              return ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(children: [
                  _Backdrop(index: chapterIndex),
                  Positioned(top: 12, left: 14, child: _Tag(text: chapterIndex == 0 ? 'NABEH · HIS BENCH' : 'NABEH')),
                  const Positioned(top: 12, right: 14, child: _Tag(text: 'JULIA')),
                  Positioned.fill(child: CustomPaint(painter: _PathPainter())),
                  for (var i=0; i<chapter.hearts; i++)
                    Positioned(
                      left: heartSpots[i].dx*size.width-14,
                      top: heartSpots[i].dy*size.height-14,
                      child: AnimatedScale(
                        scale: collected.contains(i) ? .25 : 1,
                        duration: const Duration(milliseconds: 220),
                        child: Icon(collected.contains(i) ? Icons.check_circle : Icons.auto_awesome,
                          color: collected.contains(i) ? AppTheme.gold : AppTheme.pink, size: 29),
                      ),
                    ),
                  Positioned(left: size.width*.84-32, top: size.height*.20-32,
                    child: const _Face(image:'assets/images/julia.jpg', name:'Julia', size:64)),
                  Positioned(left: player.dx*size.width-31, top: player.dy*size.height-31,
                    child: GestureDetector(
                      onPanUpdate: (d) => _movePlayer(d, size),
                      child: const _Face(image:'assets/images/nabeh.jpg', name:'Nabeh', size:62, glowing:true),
                    )),
                  if (reunited)
                    Positioned.fill(child: Container(
                      color: const Color(0xE6100D20),
                      padding: const EdgeInsets.all(18),
                      child: Center(child: SingleChildScrollView(child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isFinal)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset('assets/images/together.jpg', height:170, width:230, fit:BoxFit.cover,
                                errorBuilder: (_,__,___) => const Icon(Icons.favorite, color:AppTheme.pink, size:70)),
                            )
                          else
                            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              _Face(image:'assets/images/nabeh.jpg', name:'Nabeh', size:76),
                              Padding(padding: EdgeInsets.symmetric(horizontal:12), child: Text('🙌', style:TextStyle(fontSize:42))),
                              _Face(image:'assets/images/julia.jpg', name:'Julia', size:76),
                            ]),
                          const SizedBox(height:16),
                          Text(isFinal ? 'THE BIGGEST HUG!' : 'HIGH FIVE!',
                            textAlign:TextAlign.center,
                            style:const TextStyle(fontSize:25, fontWeight:FontWeight.w900, color:AppTheme.gold)),
                          const SizedBox(height:8),
                          Text(chapter.ending, textAlign:TextAlign.center,
                            style:const TextStyle(color:Colors.white, height:1.45, fontSize:14)),
                          const SizedBox(height:18),
                          FilledButton(onPressed:_next, child:Text(isFinal ? 'BACK TO OUR STORY' : 'NEXT CHAPTER')),
                        ],
                      ))),
                    )),
                ]),
              );
            })),
            const SizedBox(height:9),
            const Row(children: [
              Icon(Icons.touch_app, color:AppTheme.gold, size:19),
              SizedBox(width:7),
              Expanded(child: Text('DRAG NABEH • COLLECT EVERY GLOWING HEART • REACH JULIA',
                style:TextStyle(color:Colors.white60, fontSize:9, letterSpacing:.5))),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _Chapter {
  const _Chapter(this.title, this.description, this.hearts, this.ending);
  final String title, description, ending;
  final int hearts;
}

class _Face extends StatelessWidget {
  const _Face({required this.image, required this.name, required this.size, this.glowing=false});
  final String image, name;
  final double size;
  final bool glowing;
  @override
  Widget build(BuildContext context) => Column(mainAxisSize:MainAxisSize.min, children:[
    Container(
      padding:const EdgeInsets.all(3),
      decoration:BoxDecoration(
        shape:BoxShape.circle,
        border:Border.all(color:glowing ? AppTheme.gold : AppTheme.pink, width:2),
        boxShadow:[BoxShadow(color:(glowing ? AppTheme.gold : AppTheme.pink).withOpacity(.35), blurRadius:glowing ? 22 : 12)],
      ),
      child:CircleAvatar(radius:size/2, backgroundColor:AppTheme.surface, backgroundImage:AssetImage(image)),
    ),
    const SizedBox(height:3),
    Text(name, style:const TextStyle(fontSize:10, fontWeight:FontWeight.bold, shadows:[Shadow(color:Colors.black, blurRadius:5)])),
  ]);
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding:const EdgeInsets.symmetric(horizontal:9, vertical:6),
    decoration:BoxDecoration(color:Colors.black.withOpacity(.35), borderRadius:BorderRadius.circular(20),
      border:Border.all(color:Colors.white.withOpacity(.14))),
    child:Text(text, style:const TextStyle(fontSize:8, letterSpacing:1, color:Colors.white70, fontWeight:FontWeight.bold)),
  );
}

class _Backdrop extends StatelessWidget {
  const _Backdrop({required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    const palettes = [
      [Color(0xFF263E49),Color(0xFF315044),Color(0xFF172F35)],
      [Color(0xFF40314F),Color(0xFF263D59),Color(0xFF17132D)],
      [Color(0xFF56384D),Color(0xFF34405B),Color(0xFF17132D)],
      [Color(0xFF334B55),Color(0xFF49395B),Color(0xFF17132D)],
      [Color(0xFF6A3E62),Color(0xFF343B65),Color(0xFF17132D)],
    ];
    return DecoratedBox(
      decoration:BoxDecoration(gradient:LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:palettes[index])),
      child:Stack(children:[
        Positioned(top:70,left:-25,child:Icon(Icons.park_rounded,size:130,color:Colors.black.withOpacity(.18))),
        Positioned(bottom:10,right:-25,child:Icon(Icons.park_rounded,size:150,color:Colors.black.withOpacity(.18))),
        if(index==0) const Positioned(top:48,right:12,child:Text('DAMASCUS UNIVERSITY',
          style:TextStyle(color:Colors.white38,fontSize:8,letterSpacing:1.4))),
      ]),
    );
  }
}

class _PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint=Paint()..color=const Color(0xFFFFD58A).withOpacity(.22)
      ..style=PaintingStyle.stroke..strokeWidth=28..strokeCap=StrokeCap.round;
    final path=Path()..moveTo(size.width*.12,size.height*.80)
      ..cubicTo(size.width*.38,size.height*.70,size.width*.55,size.height*.38,size.width*.84,size.height*.20);
    canvas.drawPath(path,paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}
