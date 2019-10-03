#include "level_init.hpp"

using namespace godot;

void Level_Init::_register_methods() {
   register_method("spawn_scenes", &Level_Init::spawn_scenes);
	register_method("_ready", &Level_Init::_ready);

   //register_property<Level_Init, Node>("Node", &Level_Init::set_data, &Level_Init::get_data, NULL);
}

Level_Init::Level_Init() {
    // initialize any variables here
}

Level_Init::~Level_Init() {
    // add your cleanup here
}

void Level_Init::_init() {

}

String Level_Init::spawn_scenes(String scene_path, String scene_transforms_path) {
   ResourceLoader * reLo = ResourceLoader::get_singleton();
   Ref<PackedScene> scene = reLo->load(scene_path);

   std::ifstream ifs;
   std::string line;
   char * path = scene_transforms_path.alloc_c_string();
   ifs.open(path);
   // instantiate trees based off a transforms file
   while (std::getline(ifs, line)) {
      std::string intermediate;
      std::istringstream iss(line);
      std::vector<std::string> tokens;
      while (std::getline(iss, intermediate, ' ')) {
         tokens.push_back(intermediate);
      }
      std::string id = "id";
      if (id.compare(tokens[0]) == 0) {
         int i = 0;
         std::vector<float> tok;
         while (i < 3) {
            i++;
            std::getline(ifs, line);
            std::string inter;
            std::istringstream is(line);
            while (std::getline(is, inter, ' ')) {
               float num = std::atof(inter.c_str());
               tok.push_back(num);
            }
         }
         Node* CurrentScene = scene->instance();
         add_child(CurrentScene);
         Vector3 translation(tok[1], tok[3], -tok[2]);
         Vector3 rotation(tok[5], tok[7], -tok[6]);
         Vector3 scale(tok[9], tok[11], tok[10]);
         Spatial* spatial = Node::cast_to<Spatial>(CurrentScene);
         spatial->set_translation(translation);
         spatial->set_rotation(rotation);
         spatial->set_scale(scale);
      }
   }
   return "Scenes Spawned";
}

void Level_Init::_ready() {
	Godot::print(spawn_scenes(tree_scene_path, tree_transforms_path));
   Godot::print(spawn_scenes(grass_scene_path, grass_transforms_path));
}