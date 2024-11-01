class_name SpeedPushZone
extends CameraControllerBase

@export var push_ratio:float = 0.7
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
	print(target.global_position)
	var cpos = Vector3(global_position.x, 0, global_position.z)					#store camera position without y-axis
	var tpos = Vector3(target.global_position.x, 0, target.global_position.z)	#store target position without y-axis
	
	var push_left = tpos.x < (cpos.x + pushbox_top_left.x)
	var push_right = tpos.x > (cpos.x + pushbox_bottom_right.x)
	var push_top = tpos.z < (cpos.z + pushbox_top_left.y)
	var push_bottom = tpos.z > (cpos.z + pushbox_bottom_right.y)
	var in_pushbox = push_left or push_right or push_top or push_bottom
	var direction = (tpos - cpos).normalized()
	
	#var in_pushbox = tpos.x < (global_position.x + pushbox_top_left.x) \
				#or tpos.x > (global_position.x + pushbox_bottom_right.x) \
				#or tpos.z < (global_position.z + pushbox_top_left.y) \
				#or tpos.z > (global_position.z + pushbox_bottom_right.y)
	#print("position: ", tpos)
	#print("left: ", global_position.x + pushbox_top_left.x, "; right: ", global_position.x + pushbox_bottom_right.x)
	#print("top: ", global_position.z + pushbox_top_left.y, "; bottom: ", global_position.z + pushbox_bottom_right.y)
	#
	#print(in_pushbox)
	
	if not in_pushbox:
		return
	
	# Calculate camera movement based on player's position relative to pushbox
	var camera_velocity = Vector3()
	
	# Check if the player is touching the edges of the outer pushbox
	var touching_left = tpos.x < (cpos.x + speedup_zone_top_left.x)
	var touching_right = tpos.x > (cpos.x + speedup_zone_bottom_right.x)
	var touching_top = tpos.z < (cpos.z + speedup_zone_top_left.y)
	var touching_bottom = tpos.z > (cpos.z + speedup_zone_bottom_right.y)
	
	if touching_left or touching_right:
		print("touchLeft: ", touching_left)
		print("touchRight: ", touching_right)
		camera_velocity.x = target.BASE_SPEED * direction.x
	if touching_top or touching_bottom:
		print("touchTop: ", touching_top)
		print("touchBottom: ", touching_bottom)
		camera_velocity.z = target.BASE_SPEED * direction.z
	if not (touching_left or touching_right or touching_top or touching_bottom) \
			or (target.velocity == Vector3(0.0, 0.0, 0.0)):
	# Move at push_ratio in the y-direction if within the push zone vertically
		print("direction: ", direction)
		camera_velocity = direction * target.BASE_SPEED * push_ratio

	# Move camera based on the calculated camera velocity
	print("cvelocity: ", camera_velocity)
	global_position += camera_velocity * delta
	
	#var tpos = target.global_position
	#var cpos = global_position
	#
	##boundary checks based on given top_left and bottom_right variables
	#var left_bound = global_position.x + speedup_zone_top_left.x
	#var right_bound = global_position.x + speedup_zone_bottom_right.x
	#var top_bound = global_position.z + speedup_zone_top_left.y
	#var bottom_bound = global_position.z + speedup_zone_bottom_right.y
	#
	#
	#var diff_between_left_edges = (tpos.x - (cpos.x + speedup_zone_top_left.x))
	#if diff_between_left_edges < 0:
		#global_position.x += diff_between_left_edges
	##right
	#var diff_between_right_edges = (tpos.x - (cpos.x + speedup_zone_bottom_right.x))
	#if diff_between_right_edges > 0:
		#global_position.x += diff_between_right_edges
	##top
	#var diff_between_top_edges = (tpos.z - (cpos.z + speedup_zone_top_left.y))
	#if diff_between_top_edges < 0:
		#global_position.z += diff_between_top_edges
	##bottom
	#var diff_between_bottom_edges = (tpos.z - (cpos.z + speedup_zone_bottom_right.y))
	#if diff_between_bottom_edges > 0:
		#global_position.z += diff_between_bottom_edges
		
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
