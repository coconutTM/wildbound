class_name Wave_Data extends Resource
 
## enemy scene ที่จะ spawn ใน wave นี้ 1 ช่อง = enemy 1 ตัว
## เช่น อยากได้ wave ที่มี Fast 2 ตัว + Tank 1 ตัว ก็ลาก scene ใส่ 3 ช่องตามนั้น
## (boss ก็คือ enemy scene ธรรมดาที่ stats แรงกว่า ใส่เป็น wave สุดท้ายของ stage ได้เลย
## ไม่ต้องทำระบบ boss แยก)
@export var enemies: Array[PackedScene] = []
 
## หน่วงเวลาระหว่าง spawn enemy แต่ละตัว (วินาที) กัน enemy ทับซ้อนกันตอน spawn
@export var spawn_delay: float = 0.5
