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
      "title": "Stage 1",
      "description": "บทที่1",
      "screen": Stage1()
    },
    {
      "image": "assets/bgstage/bg2.png",
      "title": "Stage 2",
      "description": "บทที่2",
      "screen": Stage2()
    },
    {
      "image": "assets/bgstage/bg3.png",
      "title": "Stage 3",
      "description": "บทที่3",
      "screen": Stage3()
    },
    {
      "image": "assets/bgstage/bg4.png",
      "title": "Stage 4",
      "description": "บทที่4",
      "screen": Stage4()
    },
    {
      "image": "assets/bgstage/bg5.png",
      "title": "Stage 5",
      "description": "บทที่5",
      "screen": Stage5()
    },
    {
      "image": "assets/bgstage/bg6.png",
      "title": "Stage 6",
      "description": "บทที่6",
      "screen": Stage6()
    },
    {
      "image": "assets/bgstage/bg7.png",
      "title": "Stage 7",
      "description": "บทที่7",
      "screen": Stage7()
    },
    {
      "image": "assets/bgstage/bg8.png",
      "title": "Stage 8",
      "description": "บทที่8",
      "screen": Stage8()
    },
    {
      "image": "assets/bgstage/bg9.png",
      "title": "Stage 9",
      "description": "บทที่9",
      "screen": Stage9()
    },
    {
      "image": "assets/bgstage/bg10.png",
      "title": "Stage 10",
      "description": "บทที่10",
      "screen": Stage10()
    },
    {
      "image": "assets/bgstage/bg11.png",
      "title": "Stage 11",
      "description": "บทที่11",
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
