@tool
extends MeshInstance3D
@onready var mat : StandardMaterial3D = get_active_material(0)
@onready var sub_viewport = $SubViewport

# There were some weird issues getting the viewport to render to the mesh
# so I manually set the material albedo texture to the viewport texture
# to fix it
func _ready():
	mat.albedo_texture = sub_viewport.get_texture()
	
