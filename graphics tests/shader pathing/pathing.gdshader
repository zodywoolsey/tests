shader_type spatial;

uniform sampler2D pathmap;

void fragment() {
	ALBEDO = texture(pathmap, FRAGCOORD.xy).xyz;
}
