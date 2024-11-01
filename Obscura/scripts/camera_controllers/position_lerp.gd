class_name PositionLerp
extends CameraControllerBase

@export var follow_speed:float = 0.05
@export var catchup_speed:float = 0.1
@export var leash_distance:float = 5.0

func _ready() -> void:
	super()
	global_position = target.global_position		#initialize camera position to target position

func _process(delta: float) -> void:
	if !current:						#if not current camera, return
		return
	
	if draw_camera_logic:				#visualize camera bounds
		draw_logic()
	
	#determine if follow_speed or catchup_speed based on target idle
	var speed_mode = follow_speed
	if target.velocity:						#if target not moving -> set to catchup_speed
		speed_mode = catchup_speed
	
	#store positions on xz-plane to calculate distance/direction
	var cpos = Vector3(global_position.x, 0, global_position.z)					#store camera position without y-axis
	var tpos = Vector3(target.global_position.x, 0, target.global_position.z)	#store target position without y-axis
	
	var distance = cpos.distance_to(tpos)						#calculate distance from target on xz-plane
	var temp_direction = (tpos - cpos).normalized()					#calculate direction on xz-plane, note: integer -> need float
	var direction = Vector3(float(temp_direction.x), float(temp_direction.y), float(temp_direction.z))		#transfer new vector of floats
	
	#leash constraints or lerp to target
	if distance > leash_distance:			#if pulling leash, move camera toward target within leash bounds
		global_position += direction * (distance - leash_distance)
	else:
		global_position = lerp(cpos, tpos, speed_mode)			#if not pulling, return to target using lerp smoothing
		
	super(delta)


func draw_logic() -> void:
	var cross_length = 5							#length of visual cross, default 5 units
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(0, 0, cross_length))			#visualize vertical line
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -cross_length))
	
	immediate_mesh.surface_add_vertex(Vector3(cross_length, 0, 0))			#visualize horizontal line
	immediate_mesh.surface_add_vertex(Vector3(-cross_length, 0, 0))
	
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
