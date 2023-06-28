shader_type canvas_item;

uniform vec2 destination;
uniform vec4 portal; // x1, y1, x2, y2  (x - x1/x - x2 = y - y1/y - y2)


vec2 get_scale(vec2 px_size) {
	vec2 scale;
	vec2 sign_;
	sign_ = sign(destination);
	scale = sign_*vec2(1.0) + destination*px_size;
	scale = abs(scale);
	if (!bool(sign_.x))
		scale.x = 1.0;
	if (!bool(sign_.y))
		scale.y = 1.0;
	return scale;
}

void vertex() {
	VERTEX *= get_scale(TEXTURE_PIXEL_SIZE);
	VERTEX.x += destination.x/2.0;
	VERTEX.y += destination.y/2.0;
}

void fragment() {
	vec2 px_size = TEXTURE_PIXEL_SIZE;
	bool teleported;
	vec2 nUV;
	nUV = UV*get_scale(px_size) + clamp(destination*px_size, -get_scale(px_size), vec2(0, 0));

	/*COLOR.rgb = vec3(0.0);
	COLOR.g = nUV.x;
	COLOR.b = nUV.y;
	COLOR.a = 1.0;
	COLOR.r = 0.0;*/
	COLOR.a = 0.0;
	if (nUV.x >= 0.0 && nUV.y >= 0.0 && nUV.x <= 1.0 && nUV.y <= 1.0) {
		
		if (texture(TEXTURE, nUV).a > 0.0) {
			COLOR = texture(TEXTURE, nUV);
		}
	}
	if (nUV.x >= (destination*px_size).x &&
		nUV.y >= (destination*px_size).y &&
		nUV.x <= (destination*px_size).x + 1.0 &&
		nUV.y <= (destination*px_size).y + 1.0)
		{
		if (texture(TEXTURE, nUV - destination*px_size).a > 0.0) {
			COLOR = texture(TEXTURE, nUV - destination*px_size);
		}
	}
}