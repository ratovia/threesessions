/**
 * Created by ratovia on 2016/12/17.
 */
const poling_time = 4000;
var log = function(){
  console.log("クライアントデータ = { " + "\n" +
    "  '各オブジェクトがもつ面': " + JSON.stringify(clientText.mesh) + "\n" +
    "  'オブジェクト': "  + JSON.stringify(clientText.mesh_id) + "\n" +
    "  '各面がもつ頂点': "  + JSON.stringify(clientText.faces) + "\n" +
    "  '面': "  + JSON.stringify(clientText.faces_id) + "\n" +
    "  '各頂点の位置データ': "  + JSON.stringify(clientText.vertices) + "\n" +
    "  '頂点': "  + JSON.stringify(clientText.vertices_id) + "\n" +
    "}"
  );
};

var syncronization = function(){
  var res = diff(clientText,clientShadow);
  // log();
  clientShadow = makeshadow(clientText);
  // console.log(res);
  $.ajax({
    url: "/rooms/post",
    type: "post",
    data:{"edit": JSON.stringify(res),
          "user_id" : $('div').data('user'),
          "room_id" : $('div').data('room')
    }
  }).done(function(data){
    // console.log(data);
    patch(clientText,data);
    patch(clientShadow,data);
    // log();
    // console.log("/////////////////////////////////////////");
  }).fail(function(data){
    log();
  });

};

var makeshadow = function(text){
  var shadow = {
    'mesh': text.mesh.concat(),
    'mesh_id': text.mesh_id.concat(),
    'faces':text.faces.concat(),
    'faces_id':text.faces_id.concat(),
    'vertices':text.vertices.concat(),
    'vertices_id':text.vertices_id.concat()
  };
  return shadow
};


var  clientText = {
  'mesh':[],
  'mesh_id':[],
  'faces':[],
  'faces_id':[],
  'vertices':[],
  'vertices_id':[]
};


var clientShadow = makeshadow(clientText);
setInterval(syncronization,poling_time);


