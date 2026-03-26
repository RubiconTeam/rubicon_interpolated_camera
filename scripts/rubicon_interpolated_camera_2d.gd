@tool
class_name RubiconInterpolatedCamera2D extends Camera2D

@export var position_interpolate : bool = true
@export var position_interpolate_target : Vector2 = Vector2.ZERO
@export var position_interpolate_speed : float = 2.4 ## How fast the camera's position will return to, in px/s.

@export var rotation_interpolate : bool = true
@export var rotation_interpolate_target : float = 0.0 ## The camera's target rotation, in radians.
@export var rotation_interpolate_speed : float = 2.4 ## How fast the camera's rotation will return to, in px/s.

@export var zoom_interpolate : bool = true
@export var zoom_interpolate_target : Vector2 = Vector2.ONE
@export var zoom_interpolate_speed : float = 3.125 ## How fast the camera's zoom will return to, in px/s.

func _ready() -> void:
	position_interpolate_target = global_position
	rotation_interpolate_target = global_rotation
	zoom_interpolate_target = zoom

func _process(_delta : float) -> void:
	if position_interpolate:
		global_position = global_position.lerp(position_interpolate_target, position_interpolate_speed)
	
	if rotation_interpolate:
		global_rotation = lerpf(global_rotation, rotation_interpolate_target, rotation_interpolate_speed)
	
	if zoom_interpolate:
		zoom = zoom.lerp(zoom_interpolate_target, zoom_interpolate_speed)