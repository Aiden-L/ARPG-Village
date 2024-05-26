extends Area2D

@export var show_hit:bool = true

# 预加载打击特效
const HitEffect = preload("res://Effects/hit_effect.tscn")

func _on_area_entered(area):
	if show_hit:
		var effect = HitEffect.instantiate()
		var main = get_tree().current_scene
		main.add_child(effect)
		effect.global_position = global_position - Vector2(0, 8)
