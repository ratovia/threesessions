/**
 * Created by ratovia on 2016/12/17.
 */
var patch = function(scene,edit){
  console.log("call patch funciton");
  var ope;
  for(var i = 0,l = edit.length; i < l;i++){
    ope = edit[i][0];
    id = edit[i][1];
    data = edit[i][2];
    if(ope == "add"){
      if(!has_id(scene,id,"vertex")){
        scene.vertices_id.push(id);
        scene.vertices.push(data[0]);
        scene.vertices.push(data[1]);
        scene.vertices.push(data[2]);
      }
    }else if(ope == "remove"){
      if(has_id(scene,id,"vertex")){
        var pos = scene.vertices_id.indexOf(id);
        scene.vertices_id.splice(pos,1);
        scene.vertices.splice(pos * 3,3);
      }
      
    }else if(ope == "face"){
      if(!has_id(scene,id,"face")){
        scene.faces_id.push(id);
        var array = [];
        for(var j = 0,l2 = data.length;j < l2;j++){
          array.push(data[j]);
        }
        if(array.length > 0){
          scene.faces.push(array);
        }
      }
    }else if(ope == "deface"){
      if(has_id(scene,id,"face")){
        var index = scene.faces_id.indexOf(id);
        scene.faces.splice(index,1);
        scene.faces_id.splice(index,1)
      }
    }else if(ope == "move"){
      for(var j = 0,l2 = data.length;j < l2;j++){
        scene.vertices[scene.vertices_id.indexOf(id) * 3 + j] = data[j];
      }
    }else if(ope == "mesh"){
      if(!has_id(scene,id,"mesh")){
        scene.mesh_id.push(id);
        var array = [];
        for(var j = 0,l2 = data.length;j < l2;j++){
          array.push(data[j]);
        }
        if(array.length > 0){
          scene.mesh.push(array);
        }
      }
    }else if(ope == "demesh"){
      if(has_id(scene,id,"mesh")){
        var index = scene.mesh_id.indexOf(id);
        scene.mesh.splice(index,1);
        scene.mesh_id.splice(index,1)
      }
    }
  }
};

var has_id = function(object,id,type){
  if(type == "face"){
    if(object.faces_id.indexOf(id) >= 0){
      return true;
    }else{
      return false;
    }
  }else if(type == "vertex"){
    if(object.vertices_id.indexOf(id) >= 0){
      return true;
    }else{
      return false;
    }
  }else if(type = "mesh"){
    if(object.mesh_id.indexOf(id) >= 0){
      return true;
    }else{
      return false;
    }
  }
};