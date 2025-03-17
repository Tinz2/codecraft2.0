import 'package:codecraft2/stage10.dart';
import 'package:codecraft2/stage11.dart';
import 'package:codecraft2/stage2.dart';
import 'package:codecraft2/stage3.dart';
import 'package:codecraft2/stage4.dart';
import 'package:codecraft2/stage5.dart';
import 'package:codecraft2/stage6.dart';
import 'package:codecraft2/stage7.dart';
import 'package:codecraft2/stage8.dart';
import 'package:codecraft2/stage9.dart';
import 'package:flutter/material.dart';
import 'stage1.dart';

class Stage extends StatelessWidget {
  final List<Map<String, dynamic>> stages = [
    {
      "image": "assets/bgstage/bg1.png",
      "title": "อาณาจักรที่สงบสุข",
      "description": "เรื่องราวของอาณาจักรที่สงบสุข",
      "screen": Stage1()
    },
    {
      "image": "assets/bgstage/bg2.png",
      "title": "เวทย์มนต์",
      "description": "โค้ดได้พบกับนักเวทย์หญิง",
      "screen": Stage2()
    },
    {
      "image": "assets/bgstage/bg3.png",
      "title": "ถ้ำแร่มานา",
      "description": "โค้ด และ ชาล็อต ได้ออกตามหาอาวุธโบราณในถ้ำแร่มานา",
      "screen": Stage3()
    },
    {
      "image": "assets/bgstage/bg4.png",
      "title": "หนี",
      "description": "โค้ด และ ชาล็อต หาทางออกจากถ้ำแร่มานาหลังจากต่อสู้กับปีศาจ",
      "screen": Stage4()
    },
    {
      "image": "assets/bgstage/bg5.png",
      "title": "ชายผมขาว",
      "description": "ขณะกำลังออกจากถ้ำ โค้ด และ ชาล็อต ได้พบกับชายปริศนาผมขาว",
      "screen": Stage5()
    },
    {
      "image": "assets/bgstage/bg6.png",
      "title": "สมบัติ",
      "description": "เมื่อทั้งสามได้ออกเดินทางต่อ พวกเขาได้พบกับสมบัติที่ซ่อนอยู่",
      "screen": Stage6()
    },
    {
      "image": "assets/bgstage/bg7.png",
      "title": "กิ้งก่า",
      "description": "ทั้งสามคนพบกิ้งก่ายักษ์",
      "screen": Stage7()
    },
    {
      "image": "assets/bgstage/bg8.png",
      "title": "ก้าวสู่ป่านรก",
      "description": "ทั้งสามคนเริ่มเข้าสู่ป่านรกเพื่อตามหาอาวุธโบราณชิ้นต่อไป",
      "screen": Stage8()
    },
    {
      "image": "assets/bgstage/bg9.png",
      "title": "กองเงินกองทอง",
      "description": "เมื่อทั้งสามได้เข้าสู่ป่านรก พวกเขาได้พบกับกองเงินกองทอง",
      "screen": Stage9()
    },
    {
      "image": "assets/bgstage/bg10.png",
      "title": "จบสงคราม",
      "description": "ทั้งสามคนได้มาเจอกับราชาปีศาจแล้วจึงเกิดการต่อสู้ครั้งสุดท้าย",
      "screen": Stage10()
    },
    {
      "image": "assets/bgstage/bg11.png",
      "title": "วิวาห์",
      "description": "หลังจากปราบปีศาจแล้ว โค้ดได้ขอชาล็อตแต่งงาน โดยใช้แหวนที่เขาพบในตอนแรก",
      "screen": Stage11()
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ ไล่สีข้อความ "Stage"
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Color(0xFF0033FF), Color(0xFF3399FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                'Stage',
                style: TextStyle(
                  color:
                      Colors.white, // สีนี้ไม่สำคัญ เพราะ ShaderMask จะทำงานแทน
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: stages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(0, 33, 33, 33),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            stages[index]["image"]!,
                            height: 80,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stages[index]["title"]!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                stages[index]["description"]!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 180, // กำหนดความกว้างของปุ่มให้เล็กลง
                                height: 35, // กำหนดความสูงของปุ่มให้เล็กลง
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF0033FF),
                                        Color(0xFF3399FF)
                                      ], // ไล่เฉดจากน้ำเงินเข้ม -> น้ำเงินอ่อน
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        8), // ปรับขอบมนเล็กน้อย
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .transparent, // ทำให้พื้นหลังของปุ่มโปร่งใส
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets
                                          .zero, // ลบ padding ที่เกินออกไป
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              stages[index]["screen"],
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Play',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14, // ลดขนาดตัวอักษรให้เล็กลง
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
