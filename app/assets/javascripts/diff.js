/**
 * Created by ratovia on 2016/12/17.
 */
var diff = function(text,shadow){
  var edit = [];
  var pre,ope;
  var len_t = text.vertices_id.length;
  var len_s = shadow.vertices_id.length;
  for(var i = 0; i < len_t;i++){
    pre = shadow.vertices_id.indexOf(text.vertices_id[i]);
    if(pre >= 0){
      if(shadow.vertices[pre * 3] != text.vertices[i * 3] || shadow.vertices[pre * 3 + 1] != text.vertices[i * 3 + 1] || shadow.vertices[pre * 3 + 2] != text.vertices[i * 3 + 2]){
        ope = [  "move",
                 shadow.vertices_id[pre],
                 [  text.vertices[i * 3],
                    text.vertices[i * 3 + 1],
                    text.vertices[i * 3 + 2]
                 ]
        ];
        edit.push(ope);
      }
    }else{
      ope = [  "add",
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
      ope = [  "remove",
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
    if(pre < 0){
      ope = [  "face",
               text.faces_id[i],
               text.faces[i]
      ];
      edit.push(ope);
    }
  }

  for(i = 0; i < len_s;i++){
    pre = text.faces_id.indexOf(shadow.faces_id[i]);
    if(pre < 0) {
      ope = [  "deface",
               shadow.faces_id[i],
               shadow.faces[i]
      ];
      edit.push(ope);
    }
  }

  return edit;
  //
  // [  "deface",
  //   shadow.faces_id[i],
  //   shadow.faces[i]
  // ]
};