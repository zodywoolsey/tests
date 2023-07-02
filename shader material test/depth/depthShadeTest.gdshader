shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D screen : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform sampler2D depth : hint_depth_texture, repeat_disable, filter_nearest_mipmap;

void fragment() {
//	ALBEDO = textureLod(screen, SCREEN_UV, 1.0).xyz;
	float d = texture(depth, SCREEN_UV).r;
	float a = 1.0;
	d = PROJECTION_MATRIX[3][2] / (d + PROJECTION_MATRIX[2][2]);
//	d = d + VERTEX.z;
	if (d < FRAGCOORD.w){
		a = 0.0;
	}
	ALBEDO = textureLod(screen, SCREEN_UV, 5.0).xyz*a;
}
