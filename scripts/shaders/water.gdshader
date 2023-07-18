shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap;

uniform sampler2D noise: repeat_enable;
uniform vec2 scroll = vec2(0.05, 0.0);
uniform float distortion_strength: hint_range(-1, 1) = 0.02;

uniform vec4 tone_color: source_color;

void fragment()
{
	vec4 noise_color = texture(noise, UV + scroll * TIME);

	vec2 distortion_uv = UV + distortion_strength * noise_color.rr;
	
	vec4 screen_color = texture(TEXTURE, distortion_uv);
	
	COLOR = screen_color * tone_color;
}