shader_type canvas_item;

uniform float time;

vec3 hsv2rgb(vec3 c) {
    vec3 rgb = clamp(abs(mod(c.x*6.0 + vec3(0.0,4.0,2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);
    return c.z * mix(vec3(1.0), rgb, c.y);
}

void fragment() {
    vec2 uv = UV;
    float hue = mod(uv.x + uv.y + time, 1.0); // rainbow cycling
    vec3 color = hsv2rgb(vec3(hue, 1.0, 1.0));
    COLOR = vec4(color, 0.5); // alpha for glow
}
