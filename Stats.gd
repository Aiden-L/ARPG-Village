extends Node

# 血量相关属性
signal no_health
@export var max_health:float = 1
@onready var health = max_health :set = set_health

# 重写health的setter方法
func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
