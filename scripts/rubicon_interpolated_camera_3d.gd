@tool
class_name RubiconInterpolatedCamera3D extends Camera3D

@export var position_interpolate : bool = true
@export var position_interpolate_target : Vector3 = Vector3.ZERO
@export var position_interpolate_offset : Vector3 = Vector3.ZERO
@export var position_interpolate_speed : float = 2.4 ## How fast the camera's position will return to, in px/s.

@export var rotation_interpolate : bool = true
@export var rotation_interpolate_target : Vector3 = Vector3.ZERO ## The camera's target rotation, in radians.
@export var rotation_interpolate_offset : Vector3 = Vector3.ZERO
@export var rotation_interpolate_speed : float = 2.4 ## How fast the camera's rotation will return to, in px/s.

@export var fov_interpolate : bool = true
@export var fov_interpolate_target : float = 45.0
@export var fov_interpolate_offset : float = 45.0
@export var fov_interpolate_speed : float = 3.125 ## How fast the camera's FOV will return to, in px/s.

func _ready() -> void:
	position_interpolate_target = global_position
	rotation_interpolate_target = global_rotation
	fov_interpolate_target = fov

func _process(delta : float) -> void:
	if position_interpolate:
		global_position = global_position.lerp(position_interpolate_target + position_interpolate_offset, position_interpolate_speed * delta)
	
	if rotation_interpolate:
		global_rotation = global_rotation.lerp(rotation_interpolate_target + rotation_interpolate_offset, rotation_interpolate_speed * delta)
	
	if fov_interpolate:
		fov = lerpf(fov, fov_interpolate_target + fov_interpolate_offset, fov_interpolate_speed * delta)