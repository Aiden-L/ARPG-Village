extends "res://Hitboxes and Hurtboxes/hit_box.gd"

# 用于判断击退的方向
var knockback_vector = Vector2.ZERO

func _ready():
	# 继承自hit_box的值，self省略
	damage = 0.4
