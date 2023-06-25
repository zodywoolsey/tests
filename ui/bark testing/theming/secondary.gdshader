shader_type canvas_item;

uniform vec4 color;
varying vec4 curcolor;
uniform bool press;
uniform bool hover;
uniform float alpha = 1.0;

void fragment() {
	curcolor = color;
	if(hover){
		curcolor *= .75; 
	}
	curcolor.a *= alpha;
	COLOR = curcolor;
}
