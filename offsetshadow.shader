shader_type canvas_item;
render_mode blend_mix;

uniform vec2 offset = vec2(8.0, 8.0);
uniform vec4 modulate : hint_color;
uniform sampler2D shadow : hint_white;


void light() {
	vec2 ps = TEXTURE_PIXEL_SIZE;
	LIGHT.rgb = vec3(1.0);
	LIGHT.a = 1.0;
	LIGHT_COLOR = vec4(1.0);
//	if (texture(TEXTURE, UV).a == 0.0 && texture(TEXTURE, UV - offset*ps).a > 0.1) {
//		LIGHT.rgb = vec3(1.0);
//		LIGHT.a = 1.0;
//		LIGHT_COLOR = vec4(1.0, 0.3, 0.3, 1.0);
//		SHADOW_COLOR = vec4(0.0, 1.0, 0.0, 1.0);
//	}
}
