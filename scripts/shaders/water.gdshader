shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap;

uniform sampler2D noise1: repeat_enable;
uniform sampler2D noise2: repeat_enable;
uniform vec2 scroll1 = vec2(0.02, 0.00);
uniform vec2 scroll2 = vec2(-0.05, 0.02);
uniform float distortion_strength: hint_range(0, 100, 1.0) = 4;

uniform float light_start : hint_range(0.0, 1.0) = 0.65;
uniform float light_end : hint_range(0.0, 1.0) = 0.75;
uniform vec4 top_color: source_color;

uniform mat4 view_to_local;

varying vec2 world_position;

uniform vec4 transparency: source_color;

uniform float tileset_size : hint_range(1.0, 1000.0, 1.0);

void vertex()
{
    world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0, 1.0)).xy / vec2(textureSize(noise1, 0));
}

void fragment()
{
	vec2 depth = texture(noise1, world_position + scroll1 * TIME).rg * texture(noise2, world_position + scroll2 * TIME).rg;
	
	vec2 distortion_uv = UV + distortion_strength * ((depth - vec2(0.25,0.5)) / vec2(textureSize(TEXTURE, 0)));
	
	vec2 lower_edge = floor(UV*tileset_size)/tileset_size;
	vec2 upper_edge = ceil(UV*tileset_size)/tileset_size;
	
	distortion_uv.x = min(upper_edge.x-0.001, max(lower_edge.x+0.001, distortion_uv.x));
	distortion_uv.y = min(upper_edge.y-0.001, max(lower_edge.y+0.001, distortion_uv.y));
	
	vec4 screen_color = texture(TEXTURE, distortion_uv);
	
	vec4 top_light = smoothstep(light_start, light_end, depth.r) * top_color;
	
	COLOR = screen_color * transparency;// + top_light; 
}