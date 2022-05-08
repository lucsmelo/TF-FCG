#ifndef __COLLISIONS_H
#define __COLLISIONS_H
struct SceneObject
{
    std::string  name;        // Nome do objeto
    size_t       first_index; // �ndice do primeiro v�rtice dentro do vetor indices[] definido em BuildTrianglesAndAddToVirtualScene()
    size_t       num_indices; // N�mero de �ndices do objeto dentro do vetor indices[] definido em BuildTrianglesAndAddToVirtualScene()
    GLenum       rendering_mode; // Modo de rasteriza��o (GL_TRIANGLES, GL_TRIANGLE_STRIP, etc.)
    GLuint       vertex_array_object_id; // ID do VAO onde est�o armazenados os atributos do modelo
    glm::vec3    bbox_min; // Axis-Aligned Bounding Box do objeto
    glm::vec3    bbox_max;
};

struct Box{

    int id; //id da caixa(identificador de posi��o)
    float posx; // posi��o x no plano
    float posy;// posi��o y no plano
    float posz;// posi��o z no plano
    bool is_selected; // bool para verificar se ela foi selecionada

};
bool checkPlaneBoxColl(SceneObject box_sc, SceneObject plane,Box box);
#endif
