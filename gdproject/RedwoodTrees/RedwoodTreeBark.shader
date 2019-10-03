shader_type spatial;
render_mode depth_draw_opaque, cull_back, specular_schlick_ggx, skip_vertex_transform;
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float bend_freq = 1.0;
uniform float bend_amp = 0.1;
uniform vec2 uv_scale = vec2(1.0,1.0);

void vertex() {
	vec3 local_vert = VERTEX;
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	VERTEX.x += sin(TIME * bend_freq) * local_vert.y * bend_amp;
	VERTEX.z += sin(TIME * bend_freq) * local_vert.y * bend_amp;
}

void fragment() {
	vec2 base_uv = UV * uv_scale;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo_tex.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	ALPHA = albedo_tex.a;
}
