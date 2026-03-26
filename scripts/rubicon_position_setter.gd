@tool
class_name RubiconPositionSetter extends Node

@export var set_position : bool = true
@export var set_rotation : bool = true

@export var point_map : Dictionary[StringName, Node] = {&"Opponent": null, &"Player": null}:
	set(value):
		point_map = value
		notify_property_list_changed()

@export_storage var current_point : StringName:
	set(value):
		if value == current_point or not point_map.has(value) or point_map[value] == null:
			return

		current_point = value
		notify_property_list_changed()

		var target : Node = point_map[current_point]
		if is_attached_to_2d_camera():
			if set_position:
				_camera_2d.position_interpolate_target = _get_2d_global_position(target)
			
			if set_rotation:
				_camera_2d.rotation_interpolate_target = target.global_rotation
		elif is_attached_to_3d_camera():
			if set_position:
				_camera_3d.position_interpolate_target = target.global_position
			
			if set_rotation:
				_camera_3d.basis_interpolate_target = target.global_basis

func _get_property_list() -> Array[Dictionary]:
	var properties : Array[Dictionary] = []
	
	var points : PackedStringArray = []
	for point:StringName in point_map.keys():
		if point_map[point] == null:
			continue
		
		points.append(point)
	
	if points.is_empty():
		return []
	
	properties.append({
		name = &"current_point",
		hint = PROPERTY_HINT_ENUM,
		type = TYPE_STRING_NAME,
		usage = PROPERTY_USAGE_EDITOR,
		hint_string = ",".join(points),
	})
	
	return properties

var _camera_2d : RubiconInterpolatedCamera2D
var _camera_3d : RubiconInterpolatedCamera3D

func _init() -> void:
	set_process_internal(true)

func is_attached_to_2d_camera() -> bool:
	return _camera_2d != null

func is_attached_to_3d_camera() -> bool:
	return _camera_3d != null

func _notification(what : int) -> void:
	match what:
		NOTIFICATION_PARENTED:
			var parent : Node = get_parent()
			if parent is RubiconInterpolatedCamera2D:
				_camera_2d = parent
			elif parent is RubiconInterpolatedCamera3D:
				_camera_3d = parent
		NOTIFICATION_UNPARENTED:
			_camera_2d = null
			_camera_3d = null
		NOTIFICATION_INTERNAL_PROCESS:
			if not point_map.has(current_point) or point_map[current_point] == null:
				return

			var target : Node = point_map[current_point]
			if set_position:
				if is_attached_to_2d_camera():
					_camera_2d.position_interpolate_target = _get_2d_global_position(target)
				elif is_attached_to_3d_camera():
					_camera_3d.position_interpolate_target = target.global_position
			
			if set_rotation:
				if is_attached_to_2d_camera():
					_camera_2d.rotation_interpolate_target = target.global_rotation
				elif is_attached_to_3d_camera():
					_camera_3d.basis_interpolate_target = target.global_basis

## This normally isn't needed, but [Parallax2D] does geniunely change the global position of nodes.
func _get_2d_global_position(node : Node) -> Vector2:
	if not ("position" in node) or node.position is not Vector2:
		return Vector2.ZERO
	
	var global_pos : Vector2 = node.position
	var parent : Node = get_parent()
	while parent != null:
		global_pos += _get_node_2d_position(parent)
		parent = parent.get_parent()
	
	return global_pos
	
func _get_node_2d_position(node : Node) -> Vector2:    
	if node is Parallax2D or ParallaxBackground or ParallaxLayer:
		return Vector2.ZERO
	
	if not ("position" in node) or node.position is not Vector2:
		return Vector2.ZERO
	
	return node.position
