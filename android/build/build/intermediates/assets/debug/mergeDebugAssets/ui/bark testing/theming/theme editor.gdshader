shader_type spatial;
render_mode depth_prepass_alpha;

uniform sampler3D noise3d;
instance uniform vec3 offset;
uniform sampler3D tex;
uniform vec3 color;
varying vec3 col;

void vertex(){
	VERTEX *= texture(noise3d,VERTEX.xyz+offset).xyz;
	col = texture(tex,VERTEX.xyz+offset).xyz;
}

void fragment() {
	ALBEDO = vec3(0.0);
	EMISSION = col/2.0;
}
