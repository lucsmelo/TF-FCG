#include <string>
#include <iostream>


#include <glad/glad.h>
#include <GLFW/glfw3.h>

#include <glm/mat4x4.hpp>
#include <glm/vec4.hpp>

#include "collisions.h"
#define LENGTH 5
bool checkPlaneBoxColl(SceneObject box_sc, SceneObject plane,Box box) {
        int plane_center=(plane.bbox_max.z+plane.bbox_min.z)/2;
        int box_center=(box_sc.bbox_max.z+box_sc.bbox_min.z)/2;

        if ((box.posz - box_center*0.03 ) < plane.bbox_max.z/2-LENGTH)
        {
            return true;
        }

    return false;
}
