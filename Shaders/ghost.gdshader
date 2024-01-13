shader_type canvas_item;

uniform sampler2D gradient;
uniform float intensity: hint_range(0.0, 1.0, 0.1);

void fragment() {
	vec4 texture_text = texture(TEXTURE, UV);
	vec4 color_text = texture(gradient, UV);
	
	COLOR = vec4(texture_text.rgb + intensity, texture_text.a);
	
}

