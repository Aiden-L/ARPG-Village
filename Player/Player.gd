extends CharacterBody2D

@onready var animationPlayer = $AnimationPlayer

# 初始化调用
func _ready():
	print("Player is Ready")

# 移动速度
const MAX_SPEED = 80.0
# 移动加速度（运动开始和结束时逐渐加速和减速）
const ACCELERATION = 500.0

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.y = Input.get_axis("ui_up", "ui_down")
	if input_vector != Vector2.ZERO:
		# 将向量标准化，限制在一个圆中而不是方形
		velocity = velocity.move_toward(
			input_vector.normalized() * MAX_SPEED, 
			ACCELERATION * delta
		)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)
	move_and_slide()
