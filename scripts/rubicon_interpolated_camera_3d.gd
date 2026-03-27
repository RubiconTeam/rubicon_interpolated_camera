@tool
class_name RubiconInterpolatedCamera3D extends Camera3D

@export_group("Position", "position_interpolate_")
@export var position_interpolate_enabled: bool = true
@export var position_interpolate_target: Vector3 = Vector3.ZERO
@export var position_interpolate_offset: Vector3 = Vector3.ZERO
@export var position_interpolate_speed: float = 2.4 ## How fast the camera's position will return to. 

@export_group("Basis", "basis_interpolate_")
@export var basis_interpolate_enabled: bool = true
@export var basis_interpolate_target: Basis = Basis.IDENTITY ## The camera's target basis.
@export var basis_interpolate_offset: Basis = Basis.IDENTITY
@export var basis_interpolate_speed: float = 2.4 ## How fast the camera's basis will return to.

@export_group("FOV", "fov_interpolate_")
@export var fov_interpolate_enabled: bool = true
@export var fov_interpolate_target: float = 75.0
@export var fov_interpolate_offset: float = 0.0
@export var fov_interpolate_speed: float = 3.125 ## How fast the camera's FOV will return to.

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_POSTINITIALIZE:
			set_process_internal(true)
		NOTIFICATION_READY:
			position_interpolate_target = global_position
			basis_interpolate_target = global_basis
			fov_interpolate_target = fov
		NOTIFICATION_PROCESS:
			var delta : float = get_process_delta_time()
			if position_interpolate_enabled:
				global_position = global_position.lerp(position_interpolate_target + position_interpolate_offset, position_interpolate_speed * delta)
			
			if basis_interpolate_enabled:
				global_basis = global_basis.slerp(basis_interpolate_target * basis_interpolate_offset, basis_interpolate_speed * delta)
			
			if fov_interpolate_enabled:
				fov = lerpf(fov, fov_interpolate_target + fov_interpolate_offset, fov_interpolate_speed * delta)