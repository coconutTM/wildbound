class_name Weapon extends Node2D

@export var stats: Weapon_Stats

@onready var sprite: Sprite2D = $Pivot2D/Sprite2D
@onready var hitbox: Hitbox = $Pivot2D/Sprite2D/Hitbox
@onready var animation: AnimationPlayer = $AnimationPlayer
