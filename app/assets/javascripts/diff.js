/**
 * Created by ratovia on 2016/12/17.
 */
var diff = function(text,shadow){
  console.log("call diff function");
  var edit = [];
  var pre,ope;
  var len_t = text.vertices_id.length;
  var len_s = shadow.vertices_id.length;
  for(var i = 0; i < len_t;i++){
    pre = shadow.vertices_id.indexOf(text.vertices_id[i]);
    if(pre >= 0){
      if(shadow.vertices[pre * 3] != text.vertices[i * 3] || shadow.vertices[pre * 3 + 1] != text.vertices[i * 3 + 1] || shadow.vertices[pre * 3 + 2] != text.vertices[i * 3 + 2]){
        ope = [  "vertex_update",
                 shadow.vertices_id[pre],
                 [  text.vertices[i * 3],
                    text.vertices[i * 3 + 1],
                    text.vertices[i * 3 + 2]
                 ]
        ];
        edit.push(ope);
      }
    }else{
      ope = [  "vertex_add",
               text.vertices_id[i],
               [  text.vertices[i * 3],
                  text.vertices[i * 3 + 1],
                  text.vertices[i * 3 + 2]
               ]
      ];
      edit.push(ope);
    }
  }

  for(i = 0; i < len_s;i++){
    pre = text.vertices_id.indexOf(shadow.vertices_id[i]);
    if(pre < 0) {
      ope = [  "vertex_remove",
               shadow.vertices_id[i],
               [  shadow.vertices[i * 3],
                  shadow.vertices[i * 3 + 1],
                  shadow.vertices[i * 3 + 2]
               ]
      ];
      edit.push(ope);
    }
  }




  len_t = text.faces_id.length;
  len_s = shadow.faces_id.length;
  for(i = 0; i < len_t;i++){
    pre = shadow.faces_id.indexOf(text.faces_id[i]);
    if(pre >= 0) {
      if(text.faces[i] != shadow.faces[pre]){
        ope = [  "face_update",
          text.faces_id[i],
          text.faces[i]
        ];
        edit.push(ope);
      }
    }else{
      ope = [  "face_add",
               text.faces_id[i],
               text.faces[i]
      ];
      edit.push(ope);
    }
  }

  for(i = 0; i < len_s;i++){
    pre = text.faces_id.indexOf(shadow.faces_id[i]);
    if(pre < 0) {
      ope = [  "face_remove",
               shadow.faces_id[i],
               shadow.faces[i]
      ];
      edit.push(ope);
    }
  }


  len_t = text.mesh_id.length;
  len_s = shadow.mesh_id.length;
  for(i = 0; i < len_t;i++){
    pre = shadow.mesh_id.indexOf(text.mesh_id[i]);
    if(pre >= 0) {
      if(shadow.mesh[pre] != text.mesh[i]){
        ope = [  "mesh_update",
          text.mesh_id[i],
          text.mesh[i]
        ];
        edit.push(ope);
      }
    }else{
      ope = [  "mesh_add",
        text.mesh_id[i],
        text.mesh[i]
      ];
      edit.push(ope);
    }
  }

  for(i = 0; i < len_s;i++){
    pre = text.mesh_id.indexOf(shadow.mesh_id[i]);
    if(pre < 0) {
      ope = [  "mesh_remove",
        shadow.mesh_id[i],
        shadow.mesh[i]
      ];
      edit.push(ope);
    }
  }
  return edit;
};