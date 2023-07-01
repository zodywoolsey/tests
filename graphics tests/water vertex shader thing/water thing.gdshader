shader_type spatial;
//render_mode unshaded;
uniform float res;
uniform vec4 albedo;
uniform sampler2D noise;

void vertex() {
	VERTEX = (MODEL_MATRIX * vec4(VERTEX, 1.0f)).xyz;
	VERTEX = floor(vec3(VERTEX.x*res,VERTEX.y*res,VERTEX.z*res));
	VERTEX /= res;
	VERTEX = (MODEL_MATRIX * vec4(VERTEX, -1.0f)).xyz;
}

void fragment() {
	ALBEDO = albedo.rgb;
}

//void light(){
//
//}