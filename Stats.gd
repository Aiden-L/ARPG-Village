extends Node

# 血量相关属性
signal no_health
signal health_changed(value)
signal max_health_changed(value)
@export var max_health = 10 :set = set_max_health
var health = max_health :set = set_health

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

# 重写health的setter方法
func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
