@tool
class_name RubiconInterpolatedCamera2D extends Camera2D

@export_group("Position", "position_interpolate_")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var position_interpolate_enabled: bool = true
@export var position_interpolate_target: Vector2 = Vector2.ZERO
@export var position_interpolate_offset: Vector2 = Vector2.ZERO
@export var position_interpolate_speed: float = 2.4 ## How fast the camera's position will return to, in px/s.

@export_group("Rotation", "rotation_interpolate_")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var rotation_interpolate_enabled: bool = true
@export var rotation_interpolate_target: float = 0.0 ## The camera's target rotation, in radians.
@export var rotation_interpolate_offset: float = 0.0
@export var rotation_interpolate_speed: float = 2.4 ## How fast the camera's rotation will return to, in px/s.

@export_group("Zoom", "zoom_interpolate_")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var zoom_interpolate_enabled: bool = true
@export_custom(PROPERTY_HINT_LINK, "") var zoom_interpolate_target : Vector2 = Vector2.ONE
@export_custom(PROPERTY_HINT_LINK, "") var zoom_interpolate_offset : Vector2 = Vector2.ZERO
@export var zoom_interpolate_speed: float = 3.125 ## How fast the camera's zoom will return to, in px/s.

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_READY:
			position_interpolate_target = global_position
			rotation_interpolate_target = global_rotation
			zoom_interpolate_target = zoom
			set_process_internal(true)
		NOTIFICATION_INTERNAL_PROCESS:
			var delta : float = get_process_delta_time()
			if position_interpolate_enabled:
				global_position = global_position.lerp(position_interpolate_target + position_interpolate_offset, position_interpolate_speed * delta)
	
			if rotation_interpolate_enabled:
				global_rotation = lerpf(global_rotation, rotation_interpolate_target + rotation_interpolate_offset, rotation_interpolate_speed * delta)
			
			if zoom_interpolate_enabled:
				zoom = zoom.lerp(zoom_interpolate_target + zoom_interpolate_offset, zoom_interpolate_speed * delta)
