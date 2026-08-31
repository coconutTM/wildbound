class_name Hurtbox extends Area2D

@onready var owner_stats: Character_Stats = owner.stats

func _ready() -> void:
	monitoring = false

	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)

	# ผัง layer: 5=Player Hurtbox, 6=Enemy Hurtbox (ตรงข้ามกับ hitbox.gd)
	match owner_stats.faction:  # ระวัง: ต้องเป็น faction (f เล็ก) ไม่ใช่ Faction (F ใหญ่)
		Character_Stats.Faction.PLAYER:
			set_collision_layer_value(5, true)
		Character_Stats.Faction.ENEMY:
			set_collision_layer_value(6, true)

# แก้: เดิมเรียก owner_stats.take_damage(damage) ตรงๆ (ไปแก้ที่ Resource เลย)
# เปลี่ยนเป็นเรียก owner.take_damage(damage) ตาม flow ที่ spec กำหนดไว้
# ("Hitbox -> Hurtbox -> owner.take_damage(damage)") เพื่อให้ player.gd/enemy.gd
# มีจุดเดียวที่คุมว่าโดนดาเมจแล้วจะทำอะไรต่อ (เช่น hit animation, invincibility
# frame ในอนาคต) โดยไม่ต้องแก้ hurtbox.gd ซึ่งควรใช้ร่วมกันได้ทั้งสองฝั่ง
func receive_hit(damage: int) -> void:
	owner.take_damage(damage)
	print(owner_stats.faction, owner_stats.current_health)  # debug เช็ค HP ตอนโดนตี ลบทิ้งได้เมื่อไม่ต้องใช้แล้
