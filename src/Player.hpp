#ifndef PLAYER_HPP
#define PLAYER_HPP

#include <core/Godot.hpp>
#include <KinematicBody.hpp>
#include <Input.hpp>
#include <KinematicCollision.hpp>
#include <Viewport.hpp>
#include <Camera.hpp>
#include <algorithm>
#include <string>

namespace godot {

   class Player : public KinematicBody {
      GODOT_CLASS(Player, KinematicBody)
   private:
      Vector3 current_speed = Vector3();
      const float speed = 2;
      const float gravity = -9.8;
      const float acceleration = 3.0;
      NodePath camera;
      float cam_pitch_min;
      float cam_pitch_max;
   public:
      Player();
      ~Player();
      void _init();
      static void _register_methods();
      void _physics_process(float delta);
   };
}

#endif