shader_type canvas_item;

// Noise texture with repeat and nearest filtering
uniform sampler2D noise_texture: repeat_enable, filter_nearest;

// Fog parameters
uniform float density: hint_range(0.0, 1.0) = 0.25;
uniform vec2 speed = vec2(0.02, 0.01);

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1., 2./3., 1./3., 3.);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6. - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0., 1.), c.y);
}

void fragment() {
    // Base gradient color - horizontal rainbow using UV.x
    float hue = UV.x; // from 0 to 1 across the sprite horizontally
    vec3 base_color = hsv2rgb(vec3(hue, 1.0, 1.0));
    
    // Calculate moving UV for noise sampling
    vec2 noise_uv = UV + speed * TIME;
    
    // Sample noise texture's red channel
    float noise_val = texture(noise_texture, noise_uv).r;
    
    // Convert noise from [0,1] to [-1,1] and clamp to [0,1]
    float fog = clamp(noise_val * 2.0 - 1.0, 0.0, 1.0);
    
    // Apply noise-based fog density to alpha
    float alpha = fog * density;

    // Set final color with noise-modulated alpha
    COLOR = vec4(base_color, alpha);
}
