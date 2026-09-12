# Sky Islands — แผนงานแบบฝึกหัดที่ 5 (First 3D Game)

## ข้อตกลงการออกแบบ
| หัวข้อ | ตัดสินใจแล้ว |
|---|---|
| ธีม | เกาะลอยฟ้า (Sky Islands) |
| ตัวละคร | Quaternius – Animated Platformer Character (CC0) |
| ฉาก | Quaternius – Ultimate Platformer Pack + Stylized Nature MegaKit (CC0) |
| ไอเท็ม | ผลไม้ — ด่าน 1 = 8 ชิ้น, ด่าน 2 = 12 ชิ้น |
| โดนกับดัก | กลับ checkpoint ล่าสุด ไอเท็มที่เก็บแล้วไม่หาย (ไม่มีระบบชีวิต) |
| ประตู | ล็อก (แดง) จนกว่าจะเก็บครบ → เปิด (เขียว) แล้วเดินเข้าเพื่อไปต่อ |
| ลำดับหน้าจอ | Title → Level 1 → Level 2 → You Win |
| ของเสริม | จับเวลา / นับจำนวนตาย / เพลงแยกด่าน — ทำหลังระบบหลักเสร็จ |

## ผังด่าน (ทิศเดินหน้า = แกน -Z)
**Level 1 – Sunny Meadow (กลางวัน):** เกาะเริ่ม → เกาะหนาม → เกาะ checkpoint → แพลตฟอร์มเลื่อน → เกาะหนามสลับแถว → เกาะประตู

**Level 2 – Sunset Clouds (พระอาทิตย์ตก):** เกาะเริ่ม → แพลตฟอร์มเลื่อน → เกาะใบเลื่อย 2 ใบ (checkpoint 1) → หินกระโดด 3 ก้อน → เกาะลูกตุ้มหนาม 2 ลูก (checkpoint 2) → ลิฟต์ขึ้น → เกาะคานหมุน → เกาะประตู

---

## เฟส 0 — เตรียมโปรเจกต์ ✅
- [x] `git init` + `.gitignore` (ignore `*.tmp`, `*.blend1`, `build/`)
- [ ] สร้าง repo บน GitHub แล้ว push
- [ ] (แนะนำ) ติดตั้ง Godot **4.7.2** ตามโจทย์ — เครื่องตอนนี้เป็น 4.7 stable

## เฟส 1 — ระบบเกม ✅ (greybox, ผ่าน smoke test อัตโนมัติ 33/33)
- [x] `GameManager` — นับไอเท็ม/รีเซ็ตต่อด่าน, checkpoint, respawn, ข้อความ, เปลี่ยนฉาก
- [x] `Level.gd` — นับไอเท็มในด่านอัตโนมัติ (group `Coin`)
- [x] ประตู `Door.tscn`, Checkpoint, HUD `x / total` + ข้อความแจ้งเตือน
- [x] กับดัก: Spikes, SawBlade, SpikyBall (ลูกตุ้ม), RotatingBar, MovingPlatform, DeadZone
- [x] Level1 / Level2 แบบกล่อง (CSG) + Title Screen + Win Screen
- [ ] **ทดลองเล่นจริงใน editor (F5)** แล้วปรับความยาก/ระยะกระโดด

## เฟส 2 — เปลี่ยนตัวละคร ✅
- [x] ดาวน์โหลด Animated Platformer Character (CC0) → `Assets/Models/SkyIslands/Character.glb`
- [x] ท่าที่ใช้: `CharacterArmature|Idle / Run / Jump / Jump_Idle` (ตั้ง loop ให้ใน `player.gd`)
- [x] แทน node `gobot` ใน `Scenes/player.tscn` (เก็บ Gimbal, ParticleTrail, Footsteps ไว้)
- [x] ไม่มีท่า Flip → หมุนโมเดล 1 รอบด้วย Tween แทนตอนกระโดดสองชั้น
- [x] ย้ายการเคลื่อนที่ไป `_physics_process` เพื่อให้ยืนบนแพลตฟอร์มเลื่อนได้นิ่ง

## เฟส 3 — ตกแต่งฉาก ✅
- [x] ดาวน์โหลดโมเดล 20 ชิ้น (Ultimate Platformer Pack, Nature MegaKit, Tree Collection)
- [x] เปลี่ยนเหรียญ → ผลไม้ + เรนเดอร์ไอคอน HUD ใหม่ (`Assets/Textures/fruit_icon.png`)
- [x] เกาะลอยสร้างจาก `Island.gd` (หญ้า+ดิน+หินแหลมใต้เกาะ), กับดักใช้โมเดลจริงทั้งหมด
- [x] ต้นไม้/พุ่มไม้/หญ้า/รั้ว/ป้าย/ก้อนเมฆลอย + แสงและท้องฟ้าต่างกันสองด่าน
- [x] ย้ายไฟล์เก่าที่ไม่ใช้ออก (demo_scene, Platform*.tscn, gobot, Platforms.blend) → Assets เหลือ 2.2 MB

## เฟส 4 — Export & ส่งงาน
- [x] ตั้ง renderer เป็น Compatibility ทั้งโปรเจกต์ (ตรงกับที่เว็บใช้จริง)
- [x] เพิ่ม export preset "Web" (ปิด Thread Support) → export ลง `docs/` เรียบร้อย (index.pck ~0.99 MB)
- [x] ทดสอบไฟล์ที่ export บนเบราว์เซอร์ผ่าน local server — หน้า Title โหลดและกด Start เข้าเกมได้ ไม่มี error ใน console
- [x] เตรียมเนื้อหา Google Doc ([SUBMISSION.md](SUBMISSION.md)) + เครดิต ([CREDITS.md](CREDITS.md)) + ภาพหน้าจอใน `screenshots/`
- [ ] push ขึ้น GitHub แล้วเปิด GitHub Pages (Settings → Pages → Branch: main, Folder: /docs)
- [ ] เติมลิงก์เล่นเกมและลิงก์ source ลงใน Google Document

---

## ข้อควรระวัง
- **ฟอนต์ภาษาไทยบน Web:** ฟอนต์เริ่มต้นของ Godot ไม่มีตัวอักษรไทย บนเว็บจะเป็นกล่องสี่เหลี่ยม → UI ใช้ภาษาอังกฤษ หรือต้องฝังฟอนต์ไทย (เช่น Noto Sans Thai) เอง
- ฟอนต์ "Star Choco" ใน demo เดิมเป็น SystemFont จะไม่มีบนเว็บเช่นกัน
- `player.gd` เรียก `move_and_slide()` ใน `_process` (ของเดิมจาก kit) — ถ้าเล่นบนแพลตฟอร์มเลื่อนแล้วสั่น ให้ย้ายไป `_physics_process` ตอนทำเฟส 2
- `window/size/always_on_top=true` ใน project.godot ทำให้หน้าต่างเกมค้างบนสุดตอนทดสอบ
