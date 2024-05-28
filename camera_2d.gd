extends Camera2D

@onready var marker_2d_top_left = $Limits/Marker2DTopLeft
@onready var marker_2d_bottom_right = $Limits/Marker2DBottomRight

# Called when the node enters the scene tree for the first time.
func _ready():
	limit_top = marker_2d_top_left.position.y
	limit_left = marker_2d_top_left.position.x
	limit_bottom = marker_2d_bottom_right.position.y
	limit_right = marker_2d_bottom_right.position.x
