shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;

void fragment() {
	vec4 color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 1.0);
	COLOR = color;
}
