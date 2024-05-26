extends CharacterBody2D

@onready var stats = $Stats

func _physics_process(delta):
	# 设置击退效果
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	move_and_slide()

func _on_hurt_box_area_entered(area):
	# 获取进入区域中的变量（在剑脚本中设定了朝向）
	velocity = area.knockback_vector * 120
	# 收到伤害，扣血
	stats.health -= area.damage
	print(stats.health)

# 当接收到信号 "no_health"
func _on_stats_no_health():
	queue_free()
