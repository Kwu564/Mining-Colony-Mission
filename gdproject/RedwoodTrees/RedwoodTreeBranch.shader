shader_type spatial;
render_mode depth_draw_alpha_prepass, cull_disabled, specular_schlick_ggx, skip_vertex_transform;
uniform sampler2D texture_albedo : hint_albedo;
uniform sampler2D texture_gradient : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float sway_freq = 1.0;
uniform float sway_amp = 0.05;
uniform float sway_phase_len = 8.0;
uniform float bend_freq = 1.0;
uniform float bend_amp = 0.1;
uniform vec4 transmission : hint_color;

void vertex() {
	vec4 gradient_tex = texture(texture_gradient,UV);
	vec3 local_vert = VERTEX;
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
    VERTEX.x += sin(VERTEX.x * sway_phase_len * 1.123 + TIME * sway_freq) * sway_amp * gradient_tex.r;
    VERTEX.y += sin(VERTEX.y * sway_phase_len + TIME * sway_freq * 1.12412) * sway_amp * gradient_tex.r;
    VERTEX.z += sin(VERTEX.z * sway_phase_len * 0.9123 + TIME * sway_freq * 1.3123) * sway_amp * gradient_tex.r;
	
	VERTEX.x += sin(TIME * bend_freq) * local_vert.y * bend_amp;
	VERTEX.z += sin(TIME * bend_freq) * local_vert.y * bend_amp;
}

void fragment() {
	vec4 albedo_tex = texture(texture_albedo,UV);
	ALBEDO = albedo_tex.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	ALPHA = albedo_tex.a;
	TRANSMISSION = transmission.rgb;
}
