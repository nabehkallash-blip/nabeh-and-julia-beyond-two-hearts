import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const titles = ['THE FIRST MEETING','ANONYMOUS MESSAGES','SEVEN MONTHS LATER','TWO HEARTS, ONE JOURNEY','BEYOND TWO HEARTS'];
  static const descriptions = [
    'Damascus University. Two different benches, in two different corners of campus. Explore the places between them.',
    'Before you knew each other’s names, little messages crossed the distance. Find every lost fragment.',
    'Seven months of anonymous conversations. Move carefully, avoid the rush, and reveal the truth.',
    'A relationship is built together. Solve the four-switch memory puzzle in the right order.',
    'The final challenge. Read the danger, dodge at the right moment, and strike when the way is clear.',
  ];
  int level = 0;
  bool won = false, lost = false;
  Timer? timer;

  // Level 1: longer free-drag exploration with eight memories.
  static const memorySpots = [
    Offset(.17,.72), Offset(.31,.54), Offset(.46,.35), Offset(.62,.52),
    Offset(.77,.34), Offset(.27,.25), Offset(.54,.78), Offset(.74,.70),
  ];
  Offset nabeh = const Offset(.08,.88);
  final Set<int> memories = {};

  // Level 2: navigable maze.
  static const walls = {8,10,12,15,22,23,24,26,31,36};
  static const fragments = {3,16,32,46};
  int mazeCell = 0;
  final Set<int> foundFragments = {};

  // Level 3: ten-step timed lane challenge.
  static const hazards = [1,0,2,1,2,0,1,2,0,1];
  static const tokens = [0,2,1,0,1,2,0,1,2,1];
  int runnerStep = 0, runnerTokens = 0, runnerLives = 3, seconds = 45, runnerLane = 1;

  // Level 4: switch sequence.
  static const switchOrder = [0,2,3,1];
  int switchProgress = 0, switchMistakes = 0;

  // Level 5: dodge incoming attacks and strike during openings.
  int bossTurn = 0, bossLives = 3;

  @override
  void dispose() { timer?.cancel(); super.dispose(); }

  void startTimer() {
    timer?.cancel();
    seconds = 45;
    timer = Timer.periodic(const Duration(seconds:1), (t) {
      if (!mounted || won || lost || level != 2) { t.cancel(); return; }
      if (seconds <= 1) {
        setState(() { seconds = 0; lost = true; });
        t.cancel();
      } else { setState(() => seconds--); }
    });
  }

  void resetLevel() {
    nabeh = const Offset(.08,.88); memories.clear();
    mazeCell = 0; foundFragments.clear();
    runnerStep = 0; runnerTokens = 0; runnerLives = 3; runnerLane = 1; seconds = 45;
    switchProgress = 0; switchMistakes = 0; bossTurn = 0; bossLives = 3;
  }

  void advance() {
    if (level == 4) { Navigator.pop(context); return; }
    timer?.cancel();
    setState(() { level++; won = false; lost = false; resetLevel(); });
    if (level == 2) startTimer();
  }

  void retry() {
    timer?.cancel();
    setState(() { won = false; lost = false; resetLevel(); });
    if (level == 2) startTimer();
  }

  void complete() {
    if (won || lost) return;
    timer?.cancel();
    setState(() => won = true);
  }

  void moveUniversity(DragUpdateDetails d, Size size) {
    if (won || lost) return;
    setState(() {
      nabeh = Offset(
        (nabeh.dx + d.delta.dx / size.width).clamp(.04,.94).toDouble(),
        (nabeh.dy + d.delta.dy / size.height).clamp(.10,.94).toDouble(),
      );
      for (var i=0; i<memorySpots.length; i++) {
        if ((nabeh-memorySpots[i]).distance < .075) memories.add(i);
      }
      if (memories.length == 8 && (nabeh-const Offset(.88,.15)).distance < .12) won = true;
    });
  }

  void moveMaze(int dx, int dy) {
    if (won || lost) return;
    final x = mazeCell % 7, y = mazeCell ~/ 7;
    final nx = x+dx, ny = y+dy;
    if (nx<0 || nx>6 || ny<0 || ny>6) return;
    final next = ny*7+nx;
    if (walls.contains(next)) return;
    setState(() {
      mazeCell = next;
      if (fragments.contains(next)) foundFragments.add(next);
      if (mazeCell==48 && foundFragments.length==4) won = true;
    });
  }

  void runnerMove(int lane) {
    if (won || lost || runnerStep>=10) return;
    setState(() {
      runnerLane = lane;
      if (lane == hazards[runnerStep]) {
        runnerLives--;
        if (runnerLives<=0) lost = true;
      } else if (lane == tokens[runnerStep]) { runnerTokens++; }
      runnerStep++;
      if (!lost && runnerStep>=10) {
        if (runnerTokens>=4) won = true; else lost = true;
      }
    });
  }

  void pressSwitch(int symbol) {
    if (won || lost) return;
    setState(() {
      if (symbol == switchOrder[switchProgress]) {
        switchProgress++;
        if (switchProgress==4) won = true;
      } else {
        switchProgress = 0;
        switchMistakes++;
        if (switchMistakes>=3) lost = true;
      }
    });
  }

  void bossAction(bool dodge) {
    if (won || lost || bossTurn>=9) return;
    final needsDodge = bossTurn.isEven;
    setState(() {
      if (dodge != needsDodge) {
        bossLives--;
        if (bossLives<=0) lost = true;
      }
      bossTurn++;
      if (!lost && bossTurn>=9) won = true;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('CHAPTER 0${level+1} · ${titles[level]}',
        style: const TextStyle(fontSize:9,letterSpacing:.6)),
      centerTitle:true,
    ),
    body: SafeArea(child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15,7,15,22),
      child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
        Row(children:[
          Expanded(child:Text(titles[level],style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight:FontWeight.w900))),
          Text('${level+1} / 5',style:const TextStyle(color:AppTheme.gold,fontWeight:FontWeight.bold)),
        ]),
        const SizedBox(height:7),
        Text(descriptions[level],style:const TextStyle(color:Colors.white70,height:1.45,fontSize:13)),
        const SizedBox(height:13),
        buildStatus(),
        const SizedBox(height:12),
        buildLevel(),
        if (won || lost) buildResult(),
      ]),
    )),
  );

  Widget buildStatus() {
    switch(level) {
      case 0: return StatusLine(label:'UNIVERSITY MEMORIES',value:'${memories.length} / 8',
        child:ProgressDots(total:8,done:memories.length));
      case 1: return StatusLine(label:'MESSAGE FRAGMENTS',value:'${foundFragments.length} / 4',
        child:ProgressDots(total:4,done:foundFragments.length));
      case 2: return Row(children:[
        MiniStat(icon:Icons.timer_outlined,label:'${seconds} sec'),
        const SizedBox(width:7), MiniStat(icon:Icons.favorite,label:'${runnerLives} lives'),
        const SizedBox(width:7), MiniStat(icon:Icons.mail_outline,label:'${runnerTokens} / 4'),
      ]);
      case 3: return StatusLine(label:'SWITCHES ACTIVATED',value:'${switchProgress} / 4',
        child:ProgressDots(total:4,done:switchProgress));
      default: return Row(children:[
        MiniStat(icon:Icons.favorite,label:'${bossLives} hearts'),
        const SizedBox(width:7), MiniStat(icon:Icons.flash_on,label:'${bossTurn} / 9 moves'),
      ]);
    }
  }

  Widget buildLevel() {
    switch(level) {
      case 0: return buildUniversity();
      case 1: return buildMaze();
      case 2: return buildRunner();
      case 3: return buildPuzzle();
      default: return buildBoss();
    }
  }

  Widget buildUniversity() => Column(children:[
    Container(
      height:420, width:double.infinity, clipBehavior:Clip.antiAlias,
      decoration:BoxDecoration(borderRadius:BorderRadius.circular(23),
        gradient:const LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,
          colors:[Color(0xFF526B62),Color(0xFF263F49),Color(0xFF172D37)])),
      child:LayoutBuilder(builder:(context,c) {
        final size=Size(c.maxWidth,c.maxHeight);
        return GestureDetector(
          behavior:HitTestBehavior.opaque,
          onPanUpdate:(d)=>moveUniversity(d,size),
          child:Stack(children:[
            Positioned(top:15,left:14,child:const MapLabel('NORTH COURTYARD')),
            Positioned(bottom:14,left:14,child:const MapLabel('THE OLD WALKWAY')),
            Positioned(top:50,right:12,child:Icon(Icons.account_balance,size:76,color:Colors.white.withOpacity(.13))),
            Positioned(left:size.width*.06,top:size.height*.36,child:Icon(Icons.park,size:80,color:Colors.black.withOpacity(.17))),
            Positioned(right:size.width*.05,bottom:size.height*.08,child:Icon(Icons.park,size:105,color:Colors.black.withOpacity(.18))),
            Positioned(left:size.width*.34,top:size.height*.16,child:const Bench(label:'NABEH’S BENCH')),
            Positioned(left:size.width*.57,top:size.height*.68,child:const Bench(label:'JULIA’S BENCH')),
            Positioned(left:size.width*.12,top:size.height*.49,child:const MapLabel('LIBRARY GARDEN')),
            for(var i=0;i<8;i++)
              Positioned(left:memorySpots[i].dx*size.width-15,top:memorySpots[i].dy*size.height-15,
                child:AnimatedScale(scale:memories.contains(i)?.2:1,duration:const Duration(milliseconds:180),
                  child:Icon(memories.contains(i)?Icons.check_circle:Icons.auto_awesome,
                    color:memories.contains(i)?AppTheme.gold:AppTheme.pink,size:30))),
            Positioned(left:size.width*.88-30,top:size.height*.15-31,
              child:const Avatar(image:'assets/images/julia.jpg',label:'JULIA',size:62)),
            Positioned(left:nabeh.dx*size.width-30,top:nabeh.dy*size.height-31,
              child:const Avatar(image:'assets/images/nabeh.jpg',label:'NABEH',size:60,gold:true)),
          ]),
        );
      }),
    ),
    const SizedBox(height:9),
    const Text('DRAG ANYWHERE ON THE MAP TO MOVE NABEH. Explore three campus areas, collect all 8 memories, then find Julia.',
      textAlign:TextAlign.center,style:TextStyle(color:Colors.white60,fontSize:11,height:1.5)),
  ]);

  Widget buildMaze() => Column(children:[
    Container(padding:const EdgeInsets.all(10),
      decoration:BoxDecoration(color:AppTheme.surface,borderRadius:BorderRadius.circular(22),
        border:Border.all(color:AppTheme.pink.withOpacity(.25))),
      child:AspectRatio(aspectRatio:1,child:GridView.builder(
        physics:const NeverScrollableScrollPhysics(),itemCount:49,
        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:7,crossAxisSpacing:4,mainAxisSpacing:4),
        itemBuilder:(context,index) {
          final wall=walls.contains(index), fragment=fragments.contains(index)&&!foundFragments.contains(index);
          final player=index==mazeCell, exit=index==48;
          return Container(
            decoration:BoxDecoration(
              color:wall?const Color(0xFF111827):player?AppTheme.pink.withOpacity(.28):
                exit?AppTheme.gold.withOpacity(.22):const Color(0xFF34465A),
              borderRadius:BorderRadius.circular(7)),
            child:Center(child:wall?const Icon(Icons.lock,size:14,color:Colors.white24):
              player?const Icon(Icons.person,color:AppTheme.gold,size:23):
              fragment?const Icon(Icons.mail,color:AppTheme.pink,size:20):
              exit?const Icon(Icons.flag,color:AppTheme.gold,size:21):null),
          );
        },
      )),
    ),
    const SizedBox(height:12),
    const Text('Find all four message pieces, then reach the golden exit.',
      style:TextStyle(color:Colors.white70,fontSize:12)),
    const SizedBox(height:12),
    DirectionPad(onMove:moveMaze),
  ]);

  Widget buildRunner() {
    final step=runnerStep.clamp(0,9);
    return Column(children:[
      Container(height:270,padding:const EdgeInsets.all(16),
        decoration:BoxDecoration(borderRadius:BorderRadius.circular(22),
          gradient:const LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,
            colors:[Color(0xFF48304D),Color(0xFF202944),Color(0xFF13182C)])),
        child:Column(children:[
          const Text('THE NIGHT OF THE REVEAL',style:TextStyle(color:AppTheme.gold,letterSpacing:1.4,fontWeight:FontWeight.w800,fontSize:11)),
          const SizedBox(height:15),
          Expanded(child:Row(children:List.generate(3,(lane) {
            final danger=runnerStep<10&&hazards[step]==lane;
            final token=runnerStep<10&&tokens[step]==lane;
            return Expanded(child:Container(margin:const EdgeInsets.symmetric(horizontal:5),
              decoration:BoxDecoration(color:lane==runnerLane?AppTheme.pink.withOpacity(.16):Colors.white.withOpacity(.035),
                borderRadius:BorderRadius.circular(15),border:Border.all(color:lane==runnerLane?AppTheme.pink:Colors.white12)),
              child:Column(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[
                Text(['LEFT','CENTER','RIGHT'][lane],style:const TextStyle(fontSize:9,color:Colors.white54,letterSpacing:1)),
                if(danger) const Icon(Icons.warning_amber_rounded,color:Colors.orangeAccent,size:31)
                else if(token) const Icon(Icons.mail,color:AppTheme.gold,size:29)
                else const Icon(Icons.more_horiz,color:Colors.white24,size:26),
                if(lane==runnerLane) const CircleAvatar(radius:22,backgroundImage:AssetImage('assets/images/nabeh.jpg'))
                else const Icon(Icons.route,color:Colors.white24,size:25),
              ]),
            ));
          }))),
          const SizedBox(height:8),
          Text('STEP ${math.min(runnerStep+1,10)} OF 10',style:const TextStyle(color:Colors.white60,fontSize:10,letterSpacing:1)),
        ]),
      ),
      const SizedBox(height:12),
      const Text('Choose a lane each turn. Avoid the warning symbol and collect at least four message tokens before time runs out.',
        textAlign:TextAlign.center,style:TextStyle(color:Colors.white70,fontSize:12,height:1.5)),
      const SizedBox(height:12),
      Row(children:List.generate(3,(lane)=>Expanded(child:Padding(
        padding:const EdgeInsets.symmetric(horizontal:4),
        child:FilledButton(onPressed:won||lost?null:()=>runnerMove(lane),
          style:FilledButton.styleFrom(backgroundColor:lane==runnerLane?AppTheme.pink:AppTheme.surface,padding:const EdgeInsets.symmetric(vertical:15)),
          child:Text(['LEFT','CENTER','RIGHT'][lane],style:const TextStyle(fontSize:10,fontWeight:FontWeight.bold))),
      )))),
    ]);
  }

  Widget buildPuzzle() {
    const icons=[Icons.local_florist,Icons.favorite,Icons.nightlight_round,Icons.star];
    const names=['ROSE','HEART','MOON','STAR'];
    return Column(children:[
      Container(width:double.infinity,padding:const EdgeInsets.all(20),
        decoration:BoxDecoration(borderRadius:BorderRadius.circular(22),
          gradient:const LinearGradient(colors:[Color(0xFF34485A),Color(0xFF332744)])),
        child:const Column(children:[
          Icon(Icons.lock_open_rounded,color:AppTheme.gold,size:52),SizedBox(height:12),
          Text('THE FOUR PROMISES',style:TextStyle(color:AppTheme.gold,fontWeight:FontWeight.w900,letterSpacing:1.5)),
          SizedBox(height:10),
          Text('A note is carved into the door:\n“First the rose, then the moon.\nThe star will shine before the heart.”',
            textAlign:TextAlign.center,style:TextStyle(color:Colors.white,height:1.7,fontSize:14)),
        ]),
      ),
      const SizedBox(height:18),
      GridView.count(crossAxisCount:2,shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),
        crossAxisSpacing:12,mainAxisSpacing:12,childAspectRatio:1.65,
        children:List.generate(4,(i)=>FilledButton(
          onPressed:won||lost?null:()=>pressSwitch(i),
          style:FilledButton.styleFrom(
            backgroundColor:switchProgress>0&&switchOrder.take(switchProgress).contains(i)?AppTheme.gold.withOpacity(.35):AppTheme.surface,
            shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(17))),
          child:Row(mainAxisAlignment:MainAxisAlignment.center,children:[
            Icon(icons[i],color:AppTheme.pink),const SizedBox(width:8),
            Text(names[i],style:const TextStyle(fontWeight:FontWeight.w900)),
          ]),
        )),
      ),
      const SizedBox(height:12),
      Text('Three mistakes reset the puzzle. Mistakes used: ${switchMistakes} / 3',
        style:const TextStyle(color:Colors.white60,fontSize:11)),
    ]);
  }

  Widget buildBoss() {
    final needsDodge=bossTurn.isEven;
    return Column(children:[
      Container(height:285,width:double.infinity,
        decoration:BoxDecoration(borderRadius:BorderRadius.circular(23),
          gradient:const LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,
            colors:[Color(0xFF552E58),Color(0xFF282341),Color(0xFF13172B)])),
        child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
          const Icon(Icons.auto_awesome,color:AppTheme.gold,size:24),const SizedBox(height:9),
          const Text('THE DISTANCE',style:TextStyle(color:Colors.white70,letterSpacing:2,fontSize:11)),
          const SizedBox(height:13),
          Icon(needsDodge?Icons.flash_on_rounded:Icons.favorite,
            color:needsDodge?Colors.orangeAccent:AppTheme.pink,size:78),
          const SizedBox(height:12),
          Text(needsDodge?'INCOMING ATTACK!':'THE WAY IS OPEN!',
            style:TextStyle(color:needsDodge?Colors.orangeAccent:AppTheme.gold,fontWeight:FontWeight.w900,fontSize:19,letterSpacing:1)),
          const SizedBox(height:8),
          Text(needsDodge?'DODGE NOW':'STRIKE NOW',
            style:const TextStyle(color:Colors.white70,letterSpacing:2,fontSize:11)),
        ]),
      ),
      const SizedBox(height:13),
      const Text('Nine decisions stand between you and the final reunion. Three mistakes and the challenge is lost.',
        textAlign:TextAlign.center,style:TextStyle(color:Colors.white70,fontSize:12,height:1.5)),
      const SizedBox(height:14),
      Row(children:[
        Expanded(child:FilledButton.icon(onPressed:won||lost?null:()=>bossAction(true),
          icon:const Icon(Icons.shield),label:const Text('DODGE'),
          style:FilledButton.styleFrom(backgroundColor:const Color(0xFF35566A),padding:const EdgeInsets.symmetric(vertical:16)))),
        const SizedBox(width:10),
        Expanded(child:FilledButton.icon(onPressed:won||lost?null:()=>bossAction(false),
          icon:const Icon(Icons.flash_on),label:const Text('STRIKE'),
          style:FilledButton.styleFrom(backgroundColor:AppTheme.pink,padding:const EdgeInsets.symmetric(vertical:16)))),
      ]),
    ]);
  }

  Widget buildResult() {
    final finalLevel=level==4;
    return Container(margin:const EdgeInsets.only(top:16),padding:const EdgeInsets.all(18),width:double.infinity,
      decoration:BoxDecoration(color:AppTheme.surface,borderRadius:BorderRadius.circular(22),
        border:Border.all(color:won?AppTheme.gold:AppTheme.pink)),
      child:Column(children:[
        if(won&&finalLevel)
          ClipRRect(borderRadius:BorderRadius.circular(17),
            child:Image.asset('assets/images/together.jpg',height:180,width:double.infinity,fit:BoxFit.cover))
        else Icon(won?Icons.favorite:Icons.refresh,color:won?AppTheme.gold:AppTheme.pink,size:48),
        const SizedBox(height:12),
        Text(won?(finalLevel?'BEYOND TWO HEARTS':'CHAPTER COMPLETE!'):'NOT YET, BUT KEEP GOING',
          textAlign:TextAlign.center,style:const TextStyle(color:AppTheme.gold,fontSize:20,fontWeight:FontWeight.w900)),
        const SizedBox(height:8),
        Text(won?(finalLevel
          ?'After every maze, every challenge, and every distance — you found your way back to each other. The biggest hug is waiting.'
          :'One more part of your story unlocked. Keep moving forward, together.')
          :'Take a breath, try a different route, and give it another go.',
          textAlign:TextAlign.center,style:const TextStyle(color:Colors.white70,height:1.5,fontSize:13)),
        const SizedBox(height:15),
        SizedBox(width:double.infinity,child:FilledButton(onPressed:won?advance:retry,
          child:Text(won?(finalLevel?'BACK TO OUR STORY':'NEXT CHAPTER'):'TRY AGAIN'))),
      ]),
    );
  }
}

class StatusLine extends StatelessWidget {
  const StatusLine({required this.label,required this.value,required this.child,super.key});
  final String label,value; final Widget child;
  @override Widget build(BuildContext context)=>Container(padding:const EdgeInsets.all(12),
    decoration:BoxDecoration(color:AppTheme.surface,borderRadius:BorderRadius.circular(14)),
    child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Row(children:[Expanded(child:Text(label,style:const TextStyle(color:Colors.white60,fontSize:9,letterSpacing:1))),
        Text(value,style:const TextStyle(color:AppTheme.gold,fontWeight:FontWeight.bold,fontSize:12))]),
      const SizedBox(height:9),child,
    ]));
}

class ProgressDots extends StatelessWidget {
  const ProgressDots({required this.total,required this.done,super.key});
  final int total,done;
  @override Widget build(BuildContext context)=>Row(children:List.generate(total,(i)=>Expanded(
    child:Container(height:6,margin:const EdgeInsets.only(right:4),
      decoration:BoxDecoration(color:i<done?AppTheme.gold:Colors.white12,borderRadius:BorderRadius.circular(8))))));
}

class MiniStat extends StatelessWidget {
  const MiniStat({required this.icon,required this.label,super.key});
  final IconData icon; final String label;
  @override Widget build(BuildContext context)=>Expanded(child:Container(
    padding:const EdgeInsets.symmetric(horizontal:7,vertical:10),
    decoration:BoxDecoration(color:AppTheme.surface,borderRadius:BorderRadius.circular(13)),
    child:Row(mainAxisAlignment:MainAxisAlignment.center,children:[
      Icon(icon,color:AppTheme.gold,size:15),const SizedBox(width:5),
      Flexible(child:Text(label,style:const TextStyle(fontSize:10,fontWeight:FontWeight.bold))),
    ])));
}

class DirectionPad extends StatelessWidget {
  const DirectionPad({required this.onMove,super.key});
  final void Function(int,int) onMove;
  @override Widget build(BuildContext context)=>Column(children:[
    PadButton(icon:Icons.keyboard_arrow_up,onTap:()=>onMove(0,-1)),
    Row(mainAxisAlignment:MainAxisAlignment.center,children:[
      PadButton(icon:Icons.keyboard_arrow_left,onTap:()=>onMove(-1,0)),
      const SizedBox(width:52),
      PadButton(icon:Icons.keyboard_arrow_right,onTap:()=>onMove(1,0)),
    ]),
    PadButton(icon:Icons.keyboard_arrow_down,onTap:()=>onMove(0,1)),
  ]);
}

class PadButton extends StatelessWidget {
  const PadButton({required this.icon,required this.onTap,super.key});
  final IconData icon; final VoidCallback onTap;
  @override Widget build(BuildContext context)=>IconButton.filledTonal(onPressed:onTap,
    icon:Icon(icon,size:29),style:IconButton.styleFrom(backgroundColor:AppTheme.surface,foregroundColor:AppTheme.gold));
}

class MapLabel extends StatelessWidget {
  const MapLabel(this.text,{super.key});
  final String text;
  @override Widget build(BuildContext context)=>Container(
    padding:const EdgeInsets.symmetric(horizontal:8,vertical:5),
    decoration:BoxDecoration(color:Colors.black.withOpacity(.32),borderRadius:BorderRadius.circular(9)),
    child:Text(text,style:const TextStyle(color:Colors.white70,fontSize:8,letterSpacing:.8,fontWeight:FontWeight.bold)));
}

class Bench extends StatelessWidget {
  const Bench({required this.label,super.key});
  final String label;
  @override Widget build(BuildContext context)=>Column(children:[
    const Icon(Icons.chair_alt,color:Color(0xFFD6B68A),size:33),MapLabel(label),
  ]);
}

class Avatar extends StatelessWidget {
  const Avatar({required this.image,required this.label,required this.size,this.gold=false,super.key});
  final String image,label; final double size; final bool gold;
  @override Widget build(BuildContext context)=>Column(mainAxisSize:MainAxisSize.min,children:[
    Container(padding:const EdgeInsets.all(3),
      decoration:BoxDecoration(shape:BoxShape.circle,
        border:Border.all(color:gold?AppTheme.gold:AppTheme.pink,width:2),
        boxShadow:[BoxShadow(color:(gold?AppTheme.gold:AppTheme.pink).withOpacity(.4),blurRadius:17)]),
      child:CircleAvatar(radius:size/2,backgroundImage:AssetImage(image))),
    const SizedBox(height:3),
    Text(label,style:const TextStyle(fontSize:9,fontWeight:FontWeight.bold,shadows:[Shadow(color:Colors.black,blurRadius:5)])),
  ]);
}
