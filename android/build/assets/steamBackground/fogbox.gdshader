shader_type fog;

void fog() {
	vec3 pos = (WORLD_POSITION-vec3(0.0,0.0,0.0))/10.0;
	DENSITY = abs((pos.x+pos.y+pos.z)/3.0);
}
