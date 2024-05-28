extends CharacterBody2D

@onready var stats = $Stats
const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")
@onready var player_detection_zone = $PlayerDetectionZone
@onready var hurt_box = $HurtBox
@onready var animated_sprite = $AnimatedSprite
# 设置软碰撞
@onready var soft_collision = $SoftCollision
# wander controller
@onready var wander_controller = $WanderController

@export var ACCELERATION = 300
@export var MAX_SPEED = 50
@export var FRICTION = 200

# 由于目标无法精确到达指定点，因此会在目标点附近徘徊，设置此值，当距离处于此值内时，判定已经到达目标点
@export var WANDER_TARGET_RANGE = 4

# 状态机
enum {IDLE, WANDER, CHASE}

var state = IDLE
func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	# 设置击退效果，（摩擦力）
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	# 状态转换
	match state:
		IDLE: 
			seek_player()
			if wander_controller.get_time_left() == 0:
				update_wander()
		WANDER:
			seek_player()
			if wander_controller.get_time_left() == 0:
				update_wander()
			var direction = global_position.direction_to(wander_controller.target_position)
			# 朝向启动方向，移动
			animated_sprite.flip_h = velocity.x < 0
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			
			# 到新地点之后重新选择状态，避免来回移动
			if global_position.distance_to(wander_controller.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
		CHASE: 
			# 朝向玩家
			animated_sprite.flip_h = velocity.x < 0
			# 追逐玩家
			var player = player_detection_zone.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	# 设置软碰撞
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 400
	move_and_slide()

# 此封装方法暂不使用
#func accelerate_towards_point(point, delta):
	#var direction = global_position.direction_to(point)
	#velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	#animated_sprite.flip_h = velocity.x < 0

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wander_controller.start_wander_timer(randf_range(1, 3))

# 发现player追逐player
func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	return state_list.pick_random()

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
