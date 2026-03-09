shader_type canvas_item;

uniform vec2 centre;
uniform float radius = 80.;

void fragment() {
	vec2 viewport_size = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 pixel_pos = SCREEN_UV * viewport_size;

	float dist = distance(pixel_pos, centre);
	if (dist < radius) {
		COLOR.a = 0.;
	}
	//else if (dist < radius + shadow) {
		//COLOR.a = 0.5;
	//}
}