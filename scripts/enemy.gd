class_name Enemy
extends CharacterBody2D

signal died

@export var stats: Character_Stats

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var attack_hitbox: Hitbox = $AttackHitbox
@onready var attack_cooldown: Timer = $AttackCooldown

var player: CharacterBody2D = null
var can_attack: bool = true

var knockback_velocity: Vector2 = Vector2.ZERO
const KNOCKBACK_FRICTION: float = 600.

func _ready() -> void:
	stats = stats.duplicate(true)
	attack_hitbox.setup(stats)
	attack_hitbox.deactivate()

	attack_cooldown.one_shot = true
	attack_cooldown.timeout.connect(_on_attack_cooldown_timeout)

	stats.health_depleted.connect(die)

func _physics_process(delta: float) -> void:
	find_player()
	handle_movement(delta)
	handle_attack()
	update_animation()

# หา player ครั้งเดียวแล้วเก็บ reference ไว้ เกมนี้มี player คนเดียว
# เลยไม่ต้อง query ใหม่ทุกเฟรม (ถ้ายังไม่เจอ เช่น enemy _ready() ก่อน
# player เข้า group ทัน จะลองหาใหม่เรื่อยๆ จนกว่าจะเจอ)
func find_player() -> void:
	if player:
		return
	player = get_tree().get_first_node_in_group("player")


func handle_movement(delta: float) -> void:
	var move_velocity := Vector2.ZERO

	if player:
		var distance := global_position.distance_to(player.global_position)
		if distance > stats.weapon.attack_range:
			var direction := (player.global_position - global_position).normalized()
			move_velocity = direction * stats.speed

	velocity = move_velocity + knockback_velocity
	move_and_slide()

	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)

func apply_knockback(force: Vector2) -> void:
	knockback_velocity = force

func handle_attack() -> void:
	if not player or not can_attack:
		return

	var distance := global_position.distance_to(player.global_position)
	#print("enemy distance=", distance, " range=", stats.weapon.attack_range, " can_attack=", can_attack)
	if distance <= stats.weapon.attack_range:
		attack()

func attack() -> void:
	can_attack = false
	attack_hitbox.activate()
	SFX.play("attack_swing", -6.0)

	await get_tree().create_timer(0.15).timeout  # ระยะเวลาที่ hitbox เปิดอยู่ ปรับได้ตามฟีล

	attack_hitbox.deactivate()

	attack_cooldown.wait_time = stats.weapon.attack_cooldown
	attack_cooldown.start()

func _on_attack_cooldown_timeout() -> void:
	can_attack = true

func take_damage(amount: int) -> void:
	stats.take_damage(amount)
	SFX.play("hit_impact")

# Milestone 1 แค่ต้องการให้ enemy หายไปเมื่อ HP หมด ("Enemy ตายได้")
# ระบบ drop loot จะเพิ่มใน Milestone 3 (loot.gd) ไม่ต้องทำตอนนี้
func die() -> void:
	SFX.play("enemy_death")
	died.emit()
	queue_free()

func update_animation() -> void:
	if not player:
		sprite.play("default")
		return

	# หันตามตำแหน่ง player แทนทิศทางเดิน (สอดคล้องกับพฤติกรรม chase)
	sprite.flip_h = player.global_position.x < global_position.x

	# ตอนนี้มี animation แค่ "default" ตัวเดียว เลยเล่นเหมือนกันทั้ง idle/walk
	# ถ้ามี animation แยก idle/walk แล้ว ค่อยกลับมาเช็ค is_moving แล้วสลับชื่อ animation ตรงนี้
	sprite.play("default")
