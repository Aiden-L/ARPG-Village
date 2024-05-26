extends "res://Hitboxes and Hurtboxes/hit_box.gd"

# 用于判断击退的方向
var knockback_vector = Vector2.ZERO

func _ready():
	self.damage = 0.2
