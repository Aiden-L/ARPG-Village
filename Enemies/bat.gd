extends CharacterBody2D

@onready var stats = $Stats
const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")
@onready var player_detection_zone = $PlayerDetectionZone
@onready var hurt_box = $HurtBox
@onready var animated_sprite = $AnimatedSprite
# 设置软碰撞
@onready var soft_collision = $SoftCollision

@export var ACCELERATION = 300
@export var MAX_SPEED = 50
@export var FRICTION = 200

# 状态机
enum {IDLE, WANDER, CHASE}

var state = IDLE

func _physics_process(delta):
	# 设置击退效果，（摩擦力）
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	# 状态转换
	match state:
		IDLE: 
			seek_player()
		WANDER: pass
		CHASE: 
			# 朝向玩家
			animated_sprite.flip_h = velocity.x < 0
			# 追逐玩家
			var player = player_detection_zone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	# 设置软碰撞
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 400
	move_and_slide()

# 发现player追逐player
func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE

func _on_hurt_box_area_entered(area):
	# 获取进入区域中的变量（在剑脚本中设定了朝向）
	velocity = area.knockback_vector * 120
	# 收到伤害，扣血
	stats.health -= area.damage
	hurt_box.create_hit_effect()
	print(stats.health)

# 当接收到信号 "no_health"
func _on_stats_no_health():
	queue_free()
	# 这里用其父节点来添加新动画节点
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
