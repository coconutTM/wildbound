class_name Player
extends CharacterBody2D

signal died  # game_manager.gd ฟัง signal นี้เพื่อรู้ว่า player ตายเมื่อไหร่ ไม่ต้องเข้ามายุ่งกับ player logic ตรงๆ
signal weapon_changed  # hud.gd ฟังไว้ อัปเดตชื่ออาวุธตอน equip ใหม่
signal components_changed  # hud.gd / crafting_ui.gd ฟังไว้ อัปเดตจำนวน component
 
@export var stats: Character_Stats
@export var weapon_orbit_radius: float = 10

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var weapon_sprite: Sprite2D = $Weapon/Pivot2D/Sprite2D
@onready var attack_animation: AnimationPlayer = $Weapon/AnimationPlayer
#@onready var attack_hitbox: Hitbox = $Attack_hitbox
@onready var attack_hitbox: Hitbox = $Weapon/Pivot2D/Sprite2D/Hitbox
@onready var attack_cooldown: Timer = $Attack_cooldown
@onready var weapon: Node2D = $Weapon
@onready var weapon_pivot: Node2D = $Weapon/Pivot2D

var knockback_velocity: Vector2 = Vector2.ZERO
const KNOCKBACK_FRICTION: float = 600.0  # ยิ่งมาก ยิ่งหยุดผลักเร็ว ปรับได้ตามฟีล

var input_direction := Vector2.ZERO
var can_attack :bool = true

var components: Dictionary = {
	"wood": 0,
	"stone": 0,
	"bone": 0,
	"fiber": 0,
}


func _ready() -> void:
	#weapon_sprite.visible = false
	
	attack_hitbox.setup(stats)
	attack_hitbox.deactivate()
	
	attack_cooldown.one_shot = true
	attack_cooldown.timeout.connect(_on_attack_cooldown_timeout)
	
	stats.health_depleted.connect(die)
	

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_attack()
	update_animation()
	update_weapon_direction()

# regular function
func handle_movement(delta: float) -> void:
	input_direction = Input.get_vector(
		"move_left",	
		"move_right",
		"move_up",
		"move_down"
	)
	input_direction = input_direction.normalized()
	velocity = input_direction * stats.speed + knockback_velocity
	move_and_slide()
	
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)

func apply_knockback(force: Vector2) -> void:
	knockback_velocity = force

func handle_attack() -> void:
	if Input.is_action_just_pressed("attack") and can_attack:
		attack()

func take_damage(amount: int) -> void:
	stats.take_damage(amount)

func die() -> void:
	print("U died noob")
	set_physics_process(false)
	died.emit()

func equip_weapon(new_weapon: Weapon_Stats):
	stats.weapon = new_weapon
	stats.damage = new_weapon.damage
	
func add_component(type: String, amount: int) -> void:
	type = type.to_lower()
	if not components.has(type):
		components[type] = 0	
	components[type] += amount
	components_changed.emit()

func remove_component(type: String, amount: int) -> void:
	type = type.to_lower()
	if not components.has(type):
		return
	components[type] = max(0, components[type] - amount)
	components_changed.emit()
 
func has_enough_components(type: String, amount: int) -> bool:
	return components.get(type.to_lower(), 0) >= amount

func update_animation() -> void:
	var mouse_position = get_global_mouse_position()
	sprite.flip_h = mouse_position.x < global_position.x

	var is_moving : bool = input_direction != Vector2.ZERO

	if is_moving:
		sprite.play("run")
	else:
		sprite.play("idle")
		



func update_weapon_direction() -> void:
	var mouse_position := get_global_mouse_position()
	var direction := (mouse_position - global_position).normalized()
	var facing_left := mouse_position.x < global_position.x

	weapon.position = direction * weapon_orbit_radius
	weapon_pivot.rotation = direction.angle() + (-PI / 4 if facing_left else PI / 4)
	weapon_pivot.scale.y = -1 if facing_left else 1

func attack() -> void:
	can_attack = false
	weapon_sprite.visible = true
	attack_hitbox.activate()
	attack_animation.play("attack")
	
	# ระยะเวลาที่ hitbox เปิดอยู่ ตั้งตาม animation "attack" ยาวประมาณ 1 วินาที
	# ถ้าปรับความเร็ว/ความยาว animation ทีหลัง ต้องมาปรับเลขนี้ให้ตรงกันด้วย
	await get_tree().create_timer(0.2).timeout
	
	attack_hitbox.deactivate()
	#weapon_sprite.visible = false
	
	attack_cooldown.wait_time = stats.weapon.attack_cooldown
	attack_cooldown.start()
	attack_animation.play("RESET")
	
func _on_attack_cooldown_timeout() -> void:
	can_attack = true
