shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap;

uniform sampler2D noise1: repeat_enable;
uniform sampler2D noise2: repeat_enable;
uniform vec2 scroll1 = vec2(0.02, 0.00);
uniform vec2 scroll2 = vec2(-0.05, 0.02);
uniform float distortion_strength: hint_range(0, 0.1, 0.0001) = 0.01;

uniform float light_start : hint_range(0.0, 1.0) = 0.65;
uniform float light_end : hint_range(0.0, 1.0) = 0.75;
uniform vec4 top_color: source_color;

uniform mat4 view_to_local;

varying vec2 local;

uniform vec4 transparency: source_color;

void vertex()
{
    local = (view_to_local * MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment()
{
	vec2 uv = local / vec2(textureSize(noise1, 0));
	float depth = texture(noise1, uv + scroll1 * TIME).r * texture(noise2, uv + scroll2 * TIME).r;
	
	vec2 distortion_uv = UV + distortion_strength * (depth - 0.35);
	
	vec4 screen_color = texture(TEXTURE, distortion_uv);
	
	vec4 top_light = smoothstep(light_start, light_end, depth) * top_color;
	
	COLOR = screen_color * transparency;// + top_light; 
}