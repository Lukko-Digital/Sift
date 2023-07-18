shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap;

uniform sampler2D noise: repeat_enable;
uniform vec2 scroll = vec2(0.02, 0.00);
uniform float distortion_strength: hint_range(0, 0.02, 0.0001) = 0.01;

void fragment()
{
	vec4 noise_color = texture(noise, UV + scroll * TIME);

	vec2 distortion_uv = UV + distortion_strength * (noise_color.rr - 0.5);
	
	vec4 screen_color = texture(TEXTURE, distortion_uv);
	
	COLOR = screen_color;
}