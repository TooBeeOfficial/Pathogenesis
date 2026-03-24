shader_type canvas_item;

uniform bool active = false;
uniform vec3 Tint = vec3(1.0,0.0,0.0);
void fragment() {
	// Replaces all but alpha to white if active = true
	COLOR = texture(TEXTURE, UV);
	if (active == true)
		COLOR.rgb = Tint;
}