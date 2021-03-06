#version 330 core

// Atributos de fragmentos recebidos como entrada ("in") pelo Fragment Shader.
// Neste exemplo, este atributo foi gerado pelo rasterizador como a
// interpolação da posição global e a normal de cada vértice, definidas em
// "shader_vertex.glsl" e "main.cpp".
in vec4 position_world;
in vec4 normal;

// Posição do vértice atual no sistema de coordenadas local do modelo.
in vec4 position_model;
in vec3 color_gou;

// Coordenadas de textura obtidas do arquivo OBJ (se existirem!)
in vec2 texcoords;

// Matrizes computadas no código C++ e enviadas para a GPU
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

// Identificador que define qual objeto está sendo desenhado no momento
#define BOX 0
#define BUNNY  1
#define PLANE  2
#define ORANGE 3
#define BITCOIN 4
#define LENGTH 5
#define SKULL 5
#define BANANA 6
#define HAND 7
uniform int object_id;

uniform bool spotlight;
// Parâmetros da axis-aligned bounding box (AABB) do modelo
uniform vec4 bbox_min;
uniform vec4 bbox_max;

// Variáveis para acesso das imagens de textura
uniform sampler2D TextureImage0;
uniform sampler2D TextureImage1;
uniform sampler2D TextureImage2;
uniform sampler2D TextureImage3;

// O valor de saída ("out") de um Fragment Shader é a cor final do fragmento.
out vec4 color;

// Constantes
#define M_PI   3.14159265358979323846
#define M_PI_2 1.57079632679489661923

void main()
{
    vec4 origin = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 camera_position = inverse(view) * origin;

    // O fragmento atual é coberto por um ponto que percente à superfície de um
    // dos objetos virtuais da cena. Este ponto, p, possui uma posição no
    // sistema de coordenadas global (World coordinates). Esta posição é obtida
    // através da interpolação, feita pelo rasterizador, da posição de cada
    // vértice.
    vec4 p = position_world;

    // Normal do fragmento atual, interpolada pelo rasterizador a partir das
    // normais de cada vértice.
    vec4 n = normalize(normal);

    // Vetor que define o sentido da fonte de luz em relação ao ponto atual.
    vec4 l = normalize(camera_position - p);




    // Vetor que define o sentido da câmera em relação ao ponto atual.
    vec4 v = normalize(camera_position - p);

    // Vetor que define o sentido da reflexão especular ideal.
    vec4 r = -l + 2*n*dot(n,l);

    // Parâmetros que definem as propriedades espectrais da superfície
    vec3 Kd; // Refletância difusa
    vec3 Ks; // Refletância especular
    vec3 Ka; // Refletância ambiente
    float q; // Expoente especular para o modelo de iluminação de Phong

        // Espectro da fonte de iluminação
    vec3 I = vec3(1.0,1.0,1.0); // o espectro da fonte de luz

    // Espectro da luz ambiente
    vec3 Ia = vec3(0.2, 0.2, 0.2); // o espectro da luz ambiente


    // Coordenadas de textura U e V
    float U = 0.0;
    float V = 0.0;

/* tentativa falha de implementar luz spotlight na tela final

    vec4 l_spotlight = vec4(0.0, 2.0, 1.0, 1.0);
    vec4 v_spotlight = vec4(0.0, -1.0, 0.0, 0.0);

    vec4 l_spot = normalize(l_spotlight -p);
    float pi=3.14159265358979;
    int angle=30;
    float angle_to_rad=angle*pi/180;
    float alpha=cos(angle_to_rad);
    float beta=dot(normalize(p - l_spotlight),normalize(v_spotlight));
    bool beta_alpha=beta<alpha;
*/
    if ( object_id == BOX )
    {
        // Propriedades espectrais da caixa
        Kd = vec3(0.8, 0.4, 0.08);
        Ks = vec3(0.0,0.0,0.0);
        Ka = vec3(0.4, 0.2, 0.04);
        q = 1.0;

    // Termo difuso utilizando a lei dos cossenos de Lambert
    vec3 lambert_diffuse_term = Kd*I*max(0, dot(n,l)); // o termo difuso de Lambert

    // Termo ambiente
    vec3 ambient_term =  Ka*Ia;// o termo ambiente

    // Termo especular utilizando o modelo de iluminação de Blinn-Phong
    vec4 h= normalize(v+l);//slide 150 aula 17-18
    vec3 blinn_phong_specular_term  = Ks*I*pow(max(0, dot(n,h)), q); // o termo especular de Blinn-Phong


    color.rgb = lambert_diffuse_term + ambient_term + blinn_phong_specular_term;
    }
    else if ( object_id == BUNNY )
    {
        //propriedades espectrais do coelho
        Kd = vec3(0.08,0.4,0.8);
        Ks = vec3(0.8,0.8,0.8);
        Ka = vec3(0.04,0.2,0.4);

        q = 32.0;

    // Termo difuso utilizando a lei dos cossenos de Lambert

    vec3 lambert_diffuse_term = Kd*I*max(0, dot(n,l)); // o termo difuso de Lambert
    /*
    if(spotlight)
        lambert_diffuse_term = Kd*I*max(0, dot(n,l_spot));
    */
    // Termo ambiente
    vec3 ambient_term =  Ka*Ia;// o termo ambiente

    // Termo especular utilizando o modelo de iluminação de Phong
    vec4 h= normalize(v+l);//slide 150 aula 17-18
    vec3 blinn_phong_specular_term  = Ks*I*pow(max(0, dot(n,h)), q); // o termo especular de Phong

    color.rgb = lambert_diffuse_term + ambient_term + blinn_phong_specular_term ;
    }
    else if ( object_id == PLANE )
    {
        // Propriedades espectrais do plano
        Kd = vec3(0.2, 0.2, 0.2);
        Ks = vec3(0.3, 0.3, 0.3);
        Ka = vec3(0.0,0.0,0.0);
        q = 20.0;

        // Termo difuso utilizando a lei dos cossenos de Lambert
        vec3 lambert_diffuse_term = Kd*I*max(0, dot(n,l)); // o termo difuso de Lambert

        // Termo ambiente
        vec3 ambient_term =  Ka*Ia;// o termo ambiente

        // Termo especular utilizando o modelo de iluminação de Phong
        vec4 h= normalize(v+l);//slide 150 aula 17-18
        vec3 blinn_phong_specular_term  = Ks*I*pow(max(0, dot(n,h)), q); // o termo especular de Phong
        color.rgb = lambert_diffuse_term + ambient_term;

    //tentativa falha de implementar luz spotlight na tela final
    /*
    if (beta_alpha) { // se não for iluminado , então apenas o termo ambiente, sem termos de iluminação de phong e lambert
        if(spotlight)
            color.rgb =  ambient_term ;
        else{
             color.rgb = lambert_diffuse_term + ambient_term;
        }


    }
    else
        color.rgb = lambert_diffuse_term + ambient_term;*/
    }

        else if ( object_id == ORANGE )
    {
        //laraja utilizando sua textura e iluminação difusa
        float rho=1.0f;

        vec4 bbox_center = (bbox_min + bbox_max) / 2.0;

        vec4 p_linha= bbox_center+rho*((position_model-bbox_center)/length((position_model-bbox_center)));
        vec4 p_vetor= p_linha-bbox_center;

        float theta = atan(p_vetor.x,p_vetor.z);
        float phi= asin(p_vetor.y/rho);



        U = (theta+M_PI)/(2*M_PI);
        V = (phi+M_PI_2)/M_PI;
        Kd = texture(TextureImage1, vec2(U,V)).rgb;
        Ks = vec3(0.0,0.0,0.0);
        q = 32.0;

        // Termo difuso utilizando a lei dos cossenos de Lambert
        vec3 lambert_diffuse_term = Kd*I*max(0, dot(n,l)); // o termo difuso de Lambert

        // Termo ambiente
        vec3 ambient_term =  Ka*Ia;// o termo ambiente


        color.rgb = lambert_diffuse_term;
    }

    else if ( object_id == BITCOIN )
    {
        //bitcoin usando interpolação de gourard definido no shader vertex
        color.rgb = color_gou;
    }

    else if ( object_id == SKULL )
    {
        // caveira sendo utilizado sua textura e iluminação difusa
        float minx = bbox_min.x;
        float maxx = bbox_max.x;

        float miny = bbox_min.y;
        float maxy = bbox_max.y;

        float minz = bbox_min.z;
        float maxz = bbox_max.z;

        U = (position_model.x-minx)/(maxx - minx);
        V = (position_model.y-miny)/(maxy - miny);

        Kd = texture(TextureImage3, vec2(U,V)).rgb;
        Ks = vec3(0.0,0.0,0.0);


        q =1.0;

        // Termo difuso utilizando a lei dos cossenos de Lambert
        vec3 lambert_diffuse_term = Kd*I*max(0, dot(n,l)); // o termo difuso de Lambert

        // Termo ambiente
        vec3 ambient_term =  Ka*Ia;// o termo ambiente


        color.rgb = lambert_diffuse_term;
    }

    else if ( object_id == BANANA )
    {
        // banana sendo utilizado sua textura e iluminação difusa ambiente
        float minx = bbox_min.x;
        float maxx = bbox_max.x;

        float miny = bbox_min.y;
        float maxy = bbox_max.y;

        float minz = bbox_min.z;
        float maxz = bbox_max.z;

        U = (position_model.x-minx)/(maxx - minx);
        V = (position_model.y-miny)/(maxy - miny);

        Kd = texture(TextureImage2, vec2(U,V)).rgb;
        Ks = vec3(0.0,0.0,0.0);


        q =1.0;
        // Termo difuso utilizando a lei dos cossenos de Lambert
        vec3 lambert_diffuse_term = Kd*I*max(0, dot(n,l)); // o termo difuso de Lambert

        // Termo ambiente
        vec3 ambient_term =  Ka*Ia;// o termo ambiente

        color.rgb = lambert_diffuse_term + ambient_term;
    }

    else if ( object_id == HAND )
    {
        // Propriedades espectrais da mão
        Kd = vec3(0.8, 0.4, 0.08);
        Ks = vec3(0.2,0.2,0.2);
        Ka = vec3(0.4, 0.2, 0.04);
        q = 1.0;


        // Termo difuso utilizando a lei dos cossenos de Lambert
        vec3 lambert_diffuse_term = Kd*I*max(0, dot(n,l)); // o termo difuso de Lambert

        // Termo ambiente
        vec3 ambient_term =  Ka*Ia;// o termo ambiente

        // Termo especular utilizando o modelo de iluminação de Blinn-Phong
        vec4 h= normalize(v+l);//slide 150 aula 17-18
        vec3 blinn_phong_specular_term  = Ks*I*pow(max(0, dot(n,h)), q); // o termo especular de Blinn-Phong

        color.rgb = lambert_diffuse_term + ambient_term + blinn_phong_specular_term;
    }

    else // Objeto desconhecido = preto
    {
        Kd = vec3(0.0,0.0,0.0);
        Ks = vec3(0.0,0.0,0.0);
        Ka = vec3(0.0,0.0,0.0);
        q = 1.0;
    }





    // NOTE: Se você quiser fazer o rendering de objetos transparentes, é
    // necessário:
    // 1) Habilitar a operação de "blending" de OpenGL logo antes de realizar o
    //    desenho dos objetos transparentes, com os comandos abaixo no código C++:
    //      glEnable(GL_BLEND);
    //      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    // 2) Realizar o desenho de todos objetos transparentes *após* ter desenhado
    //    todos os objetos opacos; e
    // 3) Realizar o desenho de objetos transparentes ordenados de acordo com
    //    suas distâncias para a câmera (desenhando primeiro objetos
    //    transparentes que estão mais longe da câmera).
    // Alpha default = 1 = 100% opaco = 0% transparente
    color.a = 1;

    // Cor final do fragmento calculada com uma combinação dos termos difuso,
    // especular, e ambiente. Veja slide 129 do documento Aula_17_e_18_Modelos_de_Iluminacao.pdf.


    // Cor final com correção gamma, considerando monitor sRGB.
    // Veja https://en.wikipedia.org/w/index.php?title=Gamma_correction&oldid=751281772#Windows.2C_Mac.2C_sRGB_and_TV.2Fvideo_standard_gammas
    color.rgb = pow(color.rgb, vec3(1.0,1.0,1.0)/2.2);
}
