extends CharacterBody2D

# 引入动画/动画树节点
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

# 移动速度
const MAX_SPEED = 50.0
# 移动加速度（运动开始和结束时逐渐加速和减速）
const ACCELERATION = 500.0
# 状态机变量
enum {MOVE, ROLL, ATTACK}  # enum自动将其中的量设置为 0, 1, 2 ...
var state = MOVE

# 初始化调用
func _ready():
	animationTree.active = true
	print("Player is Ready")

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
		# 根据动画树确定方向
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
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
	
	if Input.is_action_pressed("attack"):
		state = ATTACK

func roll_state(delta):
	pass
	
func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func attack_animation_finished():
	state = MOVE
