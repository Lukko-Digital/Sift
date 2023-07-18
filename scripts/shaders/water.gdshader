shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap;

uniform sampler2D noise: repeat_enable;
uniform vec2 scroll = vec2(0.02, 0.00);
uniform float distortion_strength: hint_range(0, 0.02, 0.0001) = 0.01;

uniform mat4 view_to_local;

varying vec2 local;

void vertex()
{
    local = (view_to_local * MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment()
{
	vec2 uv = local / vec2(textureSize(noise, 0));
	vec4 noise_color = texture(noise, uv + scroll * TIME);
	
	vec2 distortion_uv = UV + distortion_strength * (noise_color.rr - 0.4);
	
	vec4 screen_color = texture(TEXTURE, distortion_uv);
	
	COLOR = screen_color;
}