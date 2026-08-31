class_name Weapon_Recipe extends Resource
 
## อาวุธที่จะได้เมื่อ craft สำเร็จ (weapon_name มาจากใน Weapon_Stats เอง ไม่ต้องซ้ำที่นี่)
@export var weapon_stats: Weapon_Stats
 
## ราคาที่ต้องใช้ key ต้องตรงกับ key ใน player.components เช่น
## {"wood": 3} หรือ {"wood": 2, "stone": 3}
@export var cost: Dictionary = {}
 
