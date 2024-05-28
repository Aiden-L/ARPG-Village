extends CharacterBody2D

# 引入动画/动画树节点
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var swordHitbox = $HitboxPivot/SwordHitBox
@onready var hurtbox = $HurtBox

# 移动速度
const MAX_SPEED = 80.0
# 移动加速度（运动开始和结束时逐渐加速和减速）
const ACCELERATION = 500.0
# 状态机变量
enum {MOVE, ROLL, ATTACK}  # enum自动将其中的量设置为 0, 1, 2 ...
var state = MOVE
# 翻滚所需变量
var roll_vector = Vector2.DOWN
const ROLL_SPEED = 125

# 初始化调用
func _ready():
	# 启动动画树
	animationTree.active = true
	# 将攻击方向和翻滚方向保持一致，后续帧持续更新
	swordHitbox.knockback_vector = roll_vector
	# 设置角色血量（这里使用设置的全局变量PlayerStats）
	PlayerStats.health = 10
	# 角色死亡判断（这里使用设置的全局变量PlayerStats）
	PlayerStats.connect("no_health", queue_free)
	# print("Player is Ready")

# 状态机
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.y = Input.get_axis("ui_up", "ui_down")
	
	if input_vector != Vector2.ZERO:
		# 确定翻滚方向，攻击方向让其保持更新
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		# 根据动画树确定方向
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		# 动画切换到Run
		animationState.travel("Run")
		# 将向量标准化，限制在一个圆中而不是方形，速度逐渐提升到MAX_SPEED
		velocity = velocity.move_toward(
			input_vector.normalized() * MAX_SPEED, 
			ACCELERATION * delta
		)
	else:
		# 动画切换到Idle
		animationState.travel("Idle")
		# 速度逐渐降为0
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)
	move_and_slide()
	
	# 检测按键事件
	if Input.is_action_pressed("roll"):
		state = ROLL
	if Input.is_action_pressed("attack"):
		state = ATTACK

func roll_state(_delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move_and_slide()
	
func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

# 翻滚动画播放完成后调用的方法
func roll_animation_finished():
	state = MOVE

# 攻击动画播放完成后调用的方法
func attack_animation_finished():
	state = MOVE

# 角色受伤
func _on_hurt_box_area_entered(_area):
	PlayerStats.health -= 1
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
