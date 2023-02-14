extends AudioStreamPlayer3D

var cap : AudioEffectCapture
var spc : AudioEffectSpectrumAnalyzerInstance
var abus

var bassTimer = true

@onready var omni_light_3d = $"../OmniLight3D"
@onready var omni_light_3d_2 = $"../OmniLight3D2"
@onready var mesh_instance_3d = $"../MeshInstance3D"
@onready var v_slider = $"../Control/VSlider"

func _ready():
	abus = AudioServer.get_bus_index("mic")
	cap = AudioServer.get_bus_effect(abus,1)
	spc = AudioServer.get_bus_effect_instance(abus,0)
	v_slider.value_changed.connect(func (val):
		print(val)
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mat : StandardMaterial3D = mesh_instance_3d.get_active_material(0)
	var tmp = (spc.get_magnitude_for_frequency_range(0,100)[0]*100)+.1
	var tmph = (spc.get_magnitude_for_frequency_range(1000,10000)[0]*100)+1.0
	omni_light_3d_2.light_energy = lerpf(omni_light_3d_2.light_energy,tmp,.5)
	mat.emission_energy_multiplier = lerpf(mat.emission_energy_multiplier,tmp,.5)
	omni_light_3d.light_energy = lerpf(omni_light_3d.light_energy,tmph,.5)
	
	if Input.is_action_just_pressed("jump"):
		for body in get_tree().get_nodes_in_group("musicBody"):
			body.apply_central_force(Vector3(0,100,0))
	
	if tmp > 6 and bassTimer:
		print('bass')
		bassTimer = false
		for body in get_tree().get_nodes_in_group("musicBody"):
			var tmpsize = body.get_child(0).shape.size
			var tmpx = tmpsize.x/2
			var tmpy = tmpsize.y/2
			var tmpz = tmpsize.z/2
			body.apply_impulse(Vector3(0,1,0),Vector3(randf_range(-tmpx,tmpx),randf_range(-tmpy,tmpy),randf_range(-tmpz,tmpz)))
	elif tmp < v_slider.value:
		bassTimer = true
