shader_type canvas_item;

uniform sampler2D noise1: repeat_enable;
uniform sampler2D noise2: repeat_enable;
uniform sampler2D gradient;
uniform vec2 offset_scroll = vec2(0.5,0.5);
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

#include "functions.gdshaderinc"

void fragment() {
	
	vec4 screen_text = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 noise1_text = texture(noise1, UV + offset_scroll * TIME/25.0);
	vec4 noise2_text = texture(noise2, UV - offset_scroll * TIME/20.0);
	
	vec2 uv = UV - 0.5;
	vec3 color = vec3(0.0);
	color += draw_circle(uv, 1.0);
	COLOR = vec4(color, 1.0);
}