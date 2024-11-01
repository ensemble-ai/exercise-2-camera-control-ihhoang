class_name AutoScroll
extends CameraControllerBase


#@export var box_width:float = 10.0
#@export var box_height:float = 10.0

@export var top_left:Vector2 = Vector2(-13, -7)
@export var bottom_right:Vector2 = Vector2(13, 7)
@export var autoscroll_speed:Vector2 = Vector2(10, 0)

func _ready() -> void:
	super()
	position = target.position

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var scroll_speed_X = autoscroll_speed[0]
	var scroll_speed_Z = autoscroll_speed[1]
	global_position.x += scroll_speed_X * delta
	global_position.z += scroll_speed_Z * delta
		
	#boundary checks
	var left_bound = global_position.x + top_left.x
	var right_bound = global_position.x + bottom_right.x
	var top_bound = global_position.z + top_left.y
	var bottom_bound = global_position.z + bottom_right.y
	
		
	if target.global_position.x < left_bound:
		target.global_position.x = left_bound
	if target.global_position.x > right_bound:
		target.global_position.x = right_bound
		
	if target.global_position.z < top_bound:
		target.global_position.z = top_bound
	if target.global_position.z > bottom_bound:
		target.global_position.z = bottom_bound	
		
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left = top_left.x
	var right = bottom_right.x
	var top = top_left.y
	var bottom = bottom_right.y
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
