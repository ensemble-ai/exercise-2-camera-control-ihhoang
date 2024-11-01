class_name PositionLerp
extends CameraControllerBase


@export var follow_speed:float = 0.05
@export var catchup_speed:float = 0.1
@export var leash_distance:float = 5.0

func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var speed_mode = follow_speed
	if target.velocity:
		speed_mode = catchup_speed
	
	var cpos = Vector3(global_position.x, 0, global_position.z)
	var tpos = Vector3(target.global_position.x, 0, target.global_position.z)
	
	var distance = cpos.distance_to(tpos)	
	var direction = (tpos - cpos).normalized()
	#print("cpos: ", cpos, "; camera: ", global_position)
	#print("tpos: ", tpos, "; target: ", target.global_position)
	#print("distance: ", distance)
	
	if distance > leash_distance:
		global_position += direction * (distance - leash_distance)
	else:
		var new_position = lerp(cpos, tpos, speed_mode)
		global_position = Vector3(new_position.x, global_position.y, new_position.z)
		
	super(delta)


func draw_logic() -> void:
	var cross_length = 5
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(0, 0, cross_length))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -cross_length))
	
	immediate_mesh.surface_add_vertex(Vector3(cross_length, 0, 0))
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
