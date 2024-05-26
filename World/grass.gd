extends Node2D

const GrassEffect = preload("res://Effects/grass_effect.tscn")

func create_grass_effect():
	# 实例化特效场景为一个节点
	var grassEffectInstance = GrassEffect.instantiate()
	## 获取到本场景的场景树，并为本草在场景中添加一个特效
	#var world_scene_tree = get_tree().current_scene
	#world_scene_tree.add_child(grassEffectInstance)
	# 这里修正为用其父节点生成子节点，修复草特效出现在角色上层的问题
	get_parent().add_child(grassEffectInstance)
	# 将特效的位置放在本草的位置上
	grassEffectInstance.global_position = global_position	

func _on_hurt_box_area_entered(_area):
	create_grass_effect()
	# 当帧结束时释放资源，非立即释放，立即释放的函数 free()
	queue_free()
