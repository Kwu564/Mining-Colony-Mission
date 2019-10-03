shader_type spatial;
render_mode specular_schlick_ggx;
uniform sampler2D tex_albedo1 : hint_albedo;
uniform sampler2D tex_albedo2 : hint_albedo;
uniform sampler2D tex_albedo3 : hint_albedo;
uniform sampler2D tex_albedo4 : hint_albedo;
uniform sampler2D tex_mask1 : hint_black;
uniform sampler2D tex_mask2 : hint_black;
uniform sampler2D tex_mask3 : hint_black;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);

varying vec3 uv1_triplanar_pos;
uniform float uv1_blend_sharpness;
varying vec3 uv1_power_normal;
uniform vec3 uv1_scale;

varying vec3 uv2_triplanar_pos;
uniform float uv2_blend_sharpness;
varying vec3 uv2_power_normal;
uniform vec3 uv2_scale;

varying vec3 uv3_triplanar_pos;
uniform float uv3_blend_sharpness;
varying vec3 uv3_power_normal;
uniform vec3 uv3_scale;

varying vec3 uv4_triplanar_pos;
uniform float uv4_blend_sharpness;
varying vec3 uv4_power_normal;
uniform vec3 uv4_scale;

// Places one texture on top of another using a texture mask
vec4 layer(vec4 tex_base, vec4 tex_layer, vec4 tex_mask) {
	vec4 base = tex_base * (vec4(1,1,1,1) - tex_mask);
	vec4 layer = tex_layer * tex_mask;
	return base + layer;
}

void vertex() {
	uv1_power_normal=pow(abs(NORMAL),vec3(uv1_blend_sharpness));
	uv1_power_normal/=dot(uv1_power_normal,vec3(1.0));
	uv1_triplanar_pos = VERTEX * uv1_scale;
	uv1_triplanar_pos *= vec3(1.0,-1.0, 1.0);
	
	uv2_power_normal=pow(abs(NORMAL),vec3(uv2_blend_sharpness));
	uv2_power_normal/=dot(uv2_power_normal,vec3(1.0));
	uv2_triplanar_pos = VERTEX * uv2_scale;
	uv2_triplanar_pos *= vec3(1.0,-1.0, 1.0);
	
	uv3_power_normal=pow(abs(NORMAL),vec3(uv3_blend_sharpness));
	uv3_power_normal/=dot(uv3_power_normal,vec3(1.0));
	uv3_triplanar_pos = VERTEX * uv3_scale;
	uv3_triplanar_pos *= vec3(1.0,-1.0, 1.0);
	
	uv4_power_normal=pow(abs(NORMAL),vec3(uv4_blend_sharpness));
	uv4_power_normal/=dot(uv4_power_normal,vec3(1.0));
	uv4_triplanar_pos = VERTEX * uv4_scale;
	uv4_triplanar_pos *= vec3(1.0,-1.0, 1.0);
}

vec4 triplanar_texture(sampler2D p_sampler,vec3 p_weights,vec3 p_triplanar_pos) {
	vec4 samp=vec4(0.0);
	samp+= texture(p_sampler,p_triplanar_pos.xy) * p_weights.z;
	samp+= texture(p_sampler,p_triplanar_pos.xz) * p_weights.y;
	samp+= texture(p_sampler,p_triplanar_pos.zy * vec2(-1.0,1.0)) * p_weights.x;
	return samp;
}

void fragment() {
	vec4 albedo1 = triplanar_texture(tex_albedo1, uv1_power_normal, uv1_triplanar_pos);
	vec4 albedo2 = triplanar_texture(tex_albedo2, uv2_power_normal, uv2_triplanar_pos);
	vec4 albedo3 = triplanar_texture(tex_albedo3, uv3_power_normal, uv3_triplanar_pos);
	vec4 albedo4 = triplanar_texture(tex_albedo4, uv4_power_normal, uv4_triplanar_pos);
	vec4 layer_result1 = layer(albedo1, albedo2, texture(tex_mask1, UV));
	vec4 layer_result2 = layer(layer_result1, albedo3, texture(tex_mask2, UV));
	vec4 layer_result3 = layer(layer_result2, albedo4, texture(tex_mask3, UV));
	ALBEDO = layer_result3.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
}
