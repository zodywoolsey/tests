extends Node3D

@onready var camera_3d = $Camera3D
@onready var rigid_body_3d = $RigidBody3D
@onready var label = $Label
@onready var serializer_test = $"."

func _ready():
	var tmps = node_to_vars(serializer_test)
	var tmpb = node_to_varb(serializer_test)
#	add_child(str_to_var('Object(RigidBody3D,"_import_path":NodePath(""),"unique_name_in_owner":false,"process_mode":0,"process_priority":0,"process_physics_priority":0,"process_thread_group":0,"editor_description":"","transform":Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0),"rotation_edit_mode":0,"rotation_order":2,"top_level":false,"visible":true,"visibility_parent":NodePath(""),"disable_mode":0,"collision_layer":1,"collision_mask":1,"collision_priority":1.0,"input_ray_pickable":true,"input_capture_on_drag":false,"axis_lock_linear_x":false,"axis_lock_linear_y":false,"axis_lock_linear_z":false,"axis_lock_angular_x":false,"axis_lock_angular_y":false,"axis_lock_angular_z":false,"mass":1.0,"inertia":Vector3(0, 0, 0),"center_of_mass_mode":0,"center_of_mass":Vector3(0, 0, 0),"physics_material_override":null,"gravity_scale":1.0,"custom_integrator":false,"continuous_cd":false,"max_contacts_reported":0,"contact_monitor":false,"sleeping":false,"can_sleep":true,"lock_rotation":false,"freeze":false,"freeze_mode":0,"linear_velocity":Vector3(0, 0, 0),"linear_damp_mode":0,"linear_damp":0.0,"angular_velocity":Vector3(0, 0, 0),"angular_damp_mode":0,"angular_damp":0.0,"constant_force":Vector3(0, 0, 0),"constant_torque":Vector3(0, 0, 0),"script":Resource("res://networking/serializer/RigidBody3D.gd"))'))
	print('string byte: '+str(var_to_bytes(tmps).size())+'\nbytes size: '+str(var_to_bytes(tmpb).size()) )

func _process(delta):
	camera_3d.look_at(rigid_body_3d.global_position)
	label.text = var_to_str(rigid_body_3d)

func node_to_vars(node:Node, type:String='', cust_name:String=''):
	var dict:Dictionary = {}
	if type:
		dict['asset_type'] = type
	if cust_name:
		dict['name'] = cust_name
	else:
		dict['name'] = node.name
	dict['node'] = var_to_str(node)
	dict['groups'] = PackedStringArray()
	for group in node.get_groups():
		if !group.begins_with("_"):
			dict.groups.append(group)
	if node.get_child_count() > 0:
		var children : Array = []
		for i in node.get_children():
			children.append(node_to_vars(i))
		dict['children']=children
	return dict

func var_to_nodes(item:String='', dict:Dictionary={}):
	var j = JSON.new()
	if dict.is_empty() and !item.is_empty():
#		print(item)
		var err = j.parse(item)
		if err == OK:
			dict = j.data
		else:
			print(err)
	if !dict.is_empty():
		var node :Node = str_to_var(dict.node)
		if dict.has('groups') and dict['groups'].size()>0:
			for group in dict.groups:
				node.add_to_group(group)
		if dict.has('children'):
			for child in dict.children:
				node.add_child(var_to_nodes('',child))
		if dict.has('name'):
			node.name = dict.name
		return node

func node_to_varb(node:Node, type:String='', cust_name:String=''):
	var dict:Dictionary = {}
	if type:
		dict['asset_type'] = type
	if cust_name:
		dict['name'] = cust_name
	else:
		dict['name'] = node.name
	dict['node'] = var_to_bytes_with_objects(node)
	dict['groups'] = PackedStringArray()
	for group in node.get_groups():
		if !group.begins_with("_"):
			dict.groups.append(group)
	if node.get_child_count() > 0:
		var children : Array = []
		for i in node.get_children():
			children.append(node_to_varb(i))
		dict['children']=children
	return dict

func var_to_nodeb(item:String='', dict:Dictionary={}):
	var j = JSON.new()
	if dict.is_empty() and !item.is_empty():
#		print(item)
		var err = j.parse(item)
		if err == OK:
			dict = j.data
		else:
			print(err)
	if !dict.is_empty():
		var node :Node = bytes_to_var_with_objects(dict.node)
		if dict.has('groups') and dict['groups'].size()>0:
			for group in dict.groups:
				node.add_to_group(group)
		if dict.has('children'):
			for child in dict.children:
				node.add_child(var_to_nodeb('',child))
		if dict.has('name'):
			node.name = dict.name
		return node
