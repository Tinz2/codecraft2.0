import 'package:flutter/material.dart';

class CharactersPage extends StatelessWidget {
  static const String routeName = '/characters';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [Color(0xFF0033FF), Color(0xFF3399FF)],
              ).createShader(bounds);
            },
          child: Text(
            'แนะนำตัวละคร',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold , fontFamily: 'Kanit', ),
          ),
        ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGradientText('ตัวเอก'),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                           _buildCharacterCard(context, 'assets/gif/charecter+ring/w2.gif', 'โค้ด', 'อัศวินของอาณาจักรที่มีพลังที่ตนเองก็ยังไม่อาจรู้ได้รับคำสั่งจากราชาไกเซอร์จึงต้องออกตามล่าอาวุธโบราณทั้ง 4 และไปผนึกราชาปีศาจ'),
                    _buildCharacterCard(context, 'assets/gif/player/Charlotte.gif', 'ชาล็อต', 'นักเวทย์หญิงที่ โค้ด บังเอิญพบระหว่างเดินทางและเธอได้สูญเสียครอบครัวตั้งแต่ราชาปีศาจโจมตีเมื่อยังเด็ก จึงได้เข้าร่วมการเดินทางกับ โค้ด เพื่อผนึกราชาปีศาจ'),
                    _buildCharacterCard(context, 'assets/gif/charecter+ring/Alucard.png', 'อลูคาส', 'เด็กหนุ่มที่เกิดมาจากครอบครัวปริศนาในถ้ำจึงได้ใช้ชีวิตคนเดียวในถ้ำแร่มานาตั้งแต่เด็ก และวันนึงเขาได้บังเอิญพบดาบมุรามาสะที่เป็นอาวุธโบราณที่ใช้ผนึกราชาปีศาจ โค้ด จึงได้ชวนกันออกเดินทางเพื่อผนึกราชาปีศาจ'),
                    _buildCharacterCard(context, 'assets/gif/charecter+ring/poe.gif', 'ราชาไกเซอร์', 'ราชาของอาณาจักรที่คอยปกป้องประชาชนมาอย่างยาวนานและเป็นคนที่ผนึกราชาปีศาจรอบแรกก่อนที่ราชาจะถูกปลดผนึก'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _buildGradientText('ตัวร้าย'),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                   _buildCharacterCard(context, 'assets/gif/enamies/skale.gif', 'สเกล', 'ปีศาจเผ่ากระดูกเป็นเผ่าย่อยในดินแดนปีศาจที่ขึ้นตรงกับราชาปีศาจและอาศัยอยู่ในถ้ำแร่มานาคอยหาสมบัติให้ราชาปีศาจ'),
                    _buildCharacterCard(context, 'assets/gif/enamies/tesa.gif', 'เทซ่า', 'เป็นราชาเผ่ากระดูกเป็นเผ่าย่อยในดินแดนปีศาจที่ขึ้นตรงกับราชาปีศาจแต่จะมีความสามารถในการต่อสู้มากกว่า สเกล'),
                    _buildCharacterCard(context, 'assets/gif/enamies/ghiavolo.gif', 'เกียโวโล่', 'ปีศาจเผ่ายมฑูตจะมีความสามารถในการบินและพลังเวทที่สูงมากในดินแดนปีศาจและมีหัวหน้าเป็นซาลอช'),
                    _buildCharacterCard(context, 'assets/gif/enamies/lizzard.gif', 'ลิซซาร์ด', 'หัวหน้าของปีศาจสัตว์ป่าอาศัยอยู่ในป่าเคยอาศัยร่วมกับมนุษณ์แต่แม่การบุกของเผ่าปีศาจครั้งก่อนจึงทำให้ไปเข้าร่วมกับราชาปีศาจ'),
                    _buildCharacterCard(context, 'assets/gif/enamies/lastboss.gif', 'ซาลอช', 'ราชาของเผ่ายมฑูตที่อยู่ในดินแดนปีศาจที่คอยปกป้องราชาปีศาจ'),
                    _buildCharacterCard(context, 'assets/gif/enamies/semiboss.gif', 'ไรโน่', 'เผ่าพันธุ์ที่ไม่มีความคิดความรู้สึกมันจะยอมรับแค่คนที่แข็งแกร่งกว่าเท่านั้นและเป็นเผ่าพันธุ์มีความแข็งแกร่งจึงถูกนำมาเป็นทหารของราชาปีศาจ'),
                    _buildCharacterCard(context, 'assets/gif/enamies/preboss.gif', 'ราชาปีศาจ', 'ผู้ที่เกิดในดินแดนปีศาจและได้รับสืบทอดจากราชาปีศาจรุ่นก่อนและมีความคิดจะยึกครองที่ดินแดนปีศาจและดินแดนมนุษย์และเคยบุกมายังดินแดนมนุษย์ครั้งหนึ่ง ก่อนถูกราชาไกเซอร์ผนึกไป'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _buildGradientText('อาวุธโบราณ'),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                     _buildCharacterCard(context, 'assets/gif/weapon/2sword.gif', 'ครอส', 'เป็นอาวุธโบราณที่ถูกสร้างและปลุกพลังโดยเผ่าเทพ'),
                    _buildCharacterCard(context, 'assets/gif/weapon/muramasa.gif', 'มุรามาสะ', 'อาวุธที่สร้างขึ้นมาจากช่างตีดาบที่มีพลังเวทถึง 100 คน'),
                    _buildCharacterCard(context, 'assets/gif/weapon/thunderbolt.gif', 'ธันเดอร์โบลต์', 'ขวานที่ได้รับพลังเวทจากสายฟ้ามานกว่า 3000 ปี'),
                    _buildCharacterCard(context, 'assets/gif/weapon/targe.gif', 'ทาร์ก', 'โล่ศักดิ์สิทธิ์ที่ไม่สามารถโดนทำลายได้' ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: _buildGradientText('Developer', fontSize: 28),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                     _buildCharacterCard(context, 'assets/developer/tin.png', 'tinz2', 'ทินภัทร ต้นสกุล 116510505031-4'),
                    _buildCharacterCard(context, 'assets/developer/new.png', 'BabyCrystal2002', 'นายนฤชา โคมจันทร์ 116510505135-3'),
                    _buildCharacterCard(context, 'assets/developer/tar.png', 'Phakinkaewsopha', 'นายภาคิน แก้วโสภา 116510505096-7'),
                    _buildCharacterCard(context, 'assets/developer/oat.png', 'Teerachai', 'ธีรชัย ดีรัตน์ 116510505018-1'),
                    _buildCharacterCard(context, 'assets/developer/aom.png', 'sinchaweng', 'ภรัณยู สออนรัมย์ 116510505122-1'),
                    _buildCharacterCard(context, 'assets/developer/peem.png', 'peemkung6002', 'นายภีมวัจน์ ดับทุกข์ 116510505111-4'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  
  }

  Widget _buildGradientText(String text, {double fontSize = 20}) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [Color(0xFF0033FF), Color(0xFF3399FF)],
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCharacterCard(BuildContext context, String imagePath, String name, String details) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.black,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(imagePath, width: 100, height: 100),
                  SizedBox(height: 10),
                  Text(name, style: TextStyle(fontSize: 24, color: Colors.white)),
                  SizedBox(height: 10),
                  Text(details, style: TextStyle(fontSize: 16, color: Colors.white)),
                ],
              ),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Image.asset(imagePath, width: 80, height: 80),
            SizedBox(height: 5),
            Text(name, style: TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

