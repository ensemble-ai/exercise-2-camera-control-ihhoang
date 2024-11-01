class_name SpeedPushZone
extends CameraControllerBase

@export var push_ratio:float = 0.3
@export var pushbox_top_left:Vector2 = Vector2(-5, -3)
@export var pushbox_bottom_right:Vector2 = Vector2(5, 3)
@export var speedup_zone_top_left:Vector2 = Vector2(-10, -7)
@export var speedup_zone_bottom_right:Vector2 = Vector2(10, 7)

func _ready() -> void:
	super()
	global_position = target.global_position
	
func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var cpos = Vector3(global_position.x, 0, global_position.z)					#store camera position without y-axis
	var tpos = Vector3(target.global_position.x, 0, target.global_position.z)	#store target position without y-axis
	
	#check if in inner box
	var in_pushbox = tpos.x < (cpos.x + pushbox_top_left.x) \
					or tpos.x > (cpos.x + pushbox_bottom_right.x) \
					or tpos.z < (cpos.z + pushbox_top_left.y) \
					or tpos.z > (cpos.z + pushbox_bottom_right.y)
	var direction = (tpos - cpos).normalized()
	
	#if in inner box, don't move
	if not in_pushbox:
		return
	
	var camera_velocity = Vector3() 		#store next camera velocity
	
	#check if passed speedup zone
	var touching_left = tpos.x < (cpos.x + speedup_zone_top_left.x)
	var touching_right = tpos.x > (cpos.x + speedup_zone_bottom_right.x)
	var touching_top = tpos.z < (cpos.z + speedup_zone_top_left.y)
	var touching_bottom = tpos.z > (cpos.z + speedup_zone_bottom_right.y)
	
	#if it's max boundary, move camera at max speed in camera direction
	if touching_left or touching_right or touching_top or touching_bottom:
		camera_velocity = target.BASE_SPEED * direction
	else:				#if in push boundary, go at partial speed based on push_ratio
		camera_velocity = direction * target.BASE_SPEED * push_ratio

	#update camera position based on given speed direction
	global_position += camera_velocity * delta
	
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	#set boundary bounds
	var out_left = speedup_zone_top_left.x
	var out_right = speedup_zone_bottom_right.x
	var out_top = speedup_zone_top_left.y
	var out_bottom = speedup_zone_bottom_right.y
	
	var in_left = pushbox_top_left.x
	var in_right = pushbox_bottom_right.x
	var in_top = pushbox_top_left.y
	var in_bottom = pushbox_bottom_right.y
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(out_right, 0, out_top))
	immediate_mesh.surface_add_vertex(Vector3(out_right, 0, out_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(out_right, 0, out_bottom))
	immediate_mesh.surface_add_vertex(Vector3(out_left, 0, out_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(out_left, 0, out_bottom))
	immediate_mesh.surface_add_vertex(Vector3(out_left, 0, out_top))
	
	immediate_mesh.surface_add_vertex(Vector3(out_left, 0, out_top))
	immediate_mesh.surface_add_vertex(Vector3(out_right, 0, out_top))
	immediate_mesh.surface_end()

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(in_right, 0, in_top))
	immediate_mesh.surface_add_vertex(Vector3(in_right, 0, in_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(in_right, 0, in_bottom))
	immediate_mesh.surface_add_vertex(Vector3(in_left, 0, in_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(in_left, 0, in_bottom))
	immediate_mesh.surface_add_vertex(Vector3(in_left, 0, in_top))
	
	immediate_mesh.surface_add_vertex(Vector3(in_left, 0, in_top))
	immediate_mesh.surface_add_vertex(Vector3(in_right, 0, in_top))
	immediate_mesh.surface_end()


	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
