#include "Player.hpp"
#include <algorithm>

using namespace godot;

void Player::_register_methods() {
   register_method("_physics_process", &Player::_physics_process);
   register_property<Player, NodePath>("camera pivot", &Player::camera, NodePath());
   register_property<Player, float>("camera pitch min", &Player::cam_pitch_min, -90.0);
   register_property<Player, float>("camera pitch max", &Player::cam_pitch_max, 90.0);
}

Player::Player() {

}

Player::~Player() {

}

void Player::_init() {

}

void Player::_physics_process(float delta) {
   Input* i = Input::get_singleton();

   Vector3 dir = Vector3();
   if (i->is_action_pressed("ui_up")) {
      dir += Vector3(1,0,0);
   }
   if (i->is_action_pressed("ui_down")) {
      dir += Vector3(-1,0,0);
   }
   if (i->is_action_pressed("ui_left")) {
      dir += Vector3(0,0,-1);
   }
   if (i->is_action_pressed("ui_right")) {
      dir += Vector3(0,0,1);
   }

   Vector3 old = current_speed;
   old.y = 0;
   current_speed = dir.normalized() * speed;

   old = old.linear_interpolate(current_speed, acceleration * delta);
   current_speed = old;
   Vector3 velocity = Vector3();
   velocity.x = old.x;
   velocity.z = old.z;

   Vector2 rotate = Vector2(velocity.z, velocity.x);
   rotate = rotate.rotated(get_rotation().y);   
   velocity = Vector3(rotate.y, 0, rotate.x);

   if (!is_on_floor()) {
      current_speed.y += gravity;
      velocity.y = current_speed.y;
   }

   move_and_slide(velocity, Vector3(0,1,0), 0.05, 4, 1.0472);
   
   float screen_center_x = get_viewport()->get_size().x / 2;
   float screen_center_y = get_viewport()->get_size().y / 2;
   i->warp_mouse_position(Vector2(screen_center_x, screen_center_y));

   float multiplier = 0.001;
   float mouse_velocity_x = -(get_viewport()->get_mouse_position().x - screen_center_x) * multiplier;
   float mouse_velocity_y = (get_viewport()->get_mouse_position().y - screen_center_y) * multiplier;
   
   rotate_y(mouse_velocity_x);

   Spatial* cam_pivot = Node::cast_to<Spatial>(get_node(camera));
   if (cam_pivot->get_rotation_degrees().z >= cam_pitch_min && cam_pivot->get_rotation_degrees().z <= cam_pitch_max) {
      cam_pivot->rotate_z(mouse_velocity_y);
   }
   if (cam_pivot->get_rotation_degrees().z < cam_pitch_min) {
      cam_pivot->set_rotation_degrees(Vector3(cam_pivot->get_rotation_degrees().x, cam_pivot->get_rotation_degrees().y, cam_pitch_min));
   }
   if (cam_pivot->get_rotation_degrees().z > cam_pitch_max) {
      cam_pivot->set_rotation_degrees(Vector3(cam_pivot->get_rotation_degrees().x, cam_pivot->get_rotation_degrees().y, cam_pitch_max));;
   }
}