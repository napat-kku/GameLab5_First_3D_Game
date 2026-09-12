# Sky Islands — แบบฝึกหัดที่ 5: First 3D Game

เกม 3D platformer 2 ด่าน สร้างด้วย **Godot 4.7** ต่อยอดจาก [3D Platformer Starter Kit](https://store.godotengine.org/asset/the-silver-demons/platformer-3d-starter-kit/) ของ SD Studios

## วิธีเล่น
| ปุ่ม | การทำงาน |
|---|---|
| W A S D | เดิน |
| Space | กระโดด (กดอีกครั้งขณะเคลื่อนที่ = กระโดดสองชั้น + ตีลังกา) |
| เมาส์ | หมุนกล้อง |
| Esc | ปล่อยเมาส์ออกจากเกม |

เก็บผลไม้ในด่านให้ครบ (ด่าน 1 = 8 ลูก, ด่าน 2 = 12 ลูก) ประตูทางออกจะเปลี่ยนจากสีแดงเป็นสีเขียว แล้วเดินเข้าประตูเพื่อไปด่านถัดไป
ถ้าโดนกับดักหรือตกจากเกาะ จะกลับไปเกิดที่ธง checkpoint ล่าสุด โดยผลไม้ที่เก็บแล้วไม่หาย

## ด่าน
- **Level 1 – Sunny Meadow**: หนามและแพลตฟอร์มเลื่อน
- **Level 2 – Sunset Clouds**: ใบเลื่อยวิ่ง, ลูกตุ้มหนาม, คานหมุน, ลิฟต์ และหินกระโดด

## โครงสร้างโปรเจกต์
```
Scenes/Levels/     ด่าน 1-2
Scenes/Objects/    ประตู, checkpoint, กับดัก, แพลตฟอร์มเลื่อน
Scenes/Props/      เกาะลอย, ต้นไม้, หิน, รั้ว, เมฆ
Scenes/UI/         หน้าเริ่มเกม, หน้าจบเกม, HUD
Scripts/           สคริปต์ทั้งหมด (GameManager เป็น autoload)
docs/              ไฟล์เกมเวอร์ชันเว็บสำหรับ GitHub Pages
```

## รันในเครื่อง
เปิดโปรเจกต์ด้วย Godot 4.7 แล้วกด F5

## เอกสารอื่น
- [PLAN.md](PLAN.md) — แผนงานและสิ่งที่ทำไปแล้ว
- [CREDITS.md](CREDITS.md) — เครดิตโมเดลและเสียงทั้งหมด
- [SUBMISSION.md](SUBMISSION.md) — เนื้อหาสำหรับ Google Document ที่ต้องส่ง
