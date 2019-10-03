#ifndef LEVEL_INIT_HPP
#define LEVEL_INIT_HPP

#include <core/Godot.hpp>
#include <Node.hpp>
#include <PackedScene.hpp>
#include <ResourceLoader.hpp>
#include <SceneTree.hpp>
#include <Viewport.hpp>
#include <Spatial.hpp>
#include <EditorScript.hpp>
#include <Input.hpp>
#include <File.hpp>
#include <fstream>
#include <String>
#include <sstream>
#include <vector>

namespace godot {

   class Level_Init : public Node {
	   GODOT_CLASS(Level_Init, Node)
   private:
      String tree_scene_path = "res://RedwoodTrees/RedwoodTree1.tscn";
      String tree_transforms_path = "./TransformData/tree_transforms";
      String grass_scene_path = "res://GrassStrand/GrassStrand.tscn";
      String grass_transforms_path = "./TransformData/grass_transforms";
   public:
      Level_Init();
      ~Level_Init();
      void _init();
      static void _register_methods();
      String spawn_scenes(String scene_path, String scene_transforms_path);
	   void _ready();
   };
}

#endif