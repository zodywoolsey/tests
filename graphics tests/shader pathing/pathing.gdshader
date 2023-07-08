shader_type spatial;

uniform sampler2D pathmap: repeat_enable;
uniform float target = .5;
uniform float dist = .1;

float remap(float value, float minin, float maxin, float minout, float maxout) {
	return minout + (value - minin) * (maxout - minout) / (maxin - minin);
}

void fragment() {
	ALBEDO = vec3(0.0);
	EMISSION = vec3(0.0);
	if(texture(pathmap, UV).g>(target-dist) && texture(pathmap, UV).g<(target+dist)){
		EMISSION.r = remap(texture(pathmap, UV).r, target-dist, target+dist, 0.0, 1.0);
	}
}

//void vertex() {
//	VERTEX *= clamp(texture(pathmap, UV).xyz,target-.1,target+.1);
//}
