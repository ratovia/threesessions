/**
 * Created by ratovia on 2016/12/17.
 */
const poling_time = 7000;
var log = function(){
  console.log("clientText = { " + "\n" +
    "  'mesh': " + JSON.stringify(clientText.mesh) + "\n" +
    "  'mesh_id': "  + JSON.stringify(clientText.mesh_id) + "\n" +
    "  'faces': "  + JSON.stringify(clientText.faces) + "\n" +
    "  'faces_id': "  + JSON.stringify(clientText.faces_id) + "\n" +
    "  'vertices': "  + JSON.stringify(clientText.vertices) + "\n" +
    "  'vertices_id': "  + JSON.stringify(clientText.vertices_id) + "\n" +
    "}"
  );
  // console.log("clientShadow " + JSON.stringify(clientShadow));
  // $('.clientText').text("clientText " + JSON.stringify(clientText));
  // $('.clientShadow').text("clientShadow " + JSON.stringify(clientShadow));
};

var syncronization = function(){
  var res = diff(clientText,clientShadow);
  log();
  clientShadow = makeshadow(clientText);
  console.log(res);
  $.ajax({
    url: "/rooms/post",
    type: "post",
    data:{"edit": JSON.stringify(res),
          "user_id" : $('div').data('user'),
          "room_id" : $('div').data('room')
    }
  }).done(function(data){
    console.log(data);
    patch(clientText,data);
    patch(clientShadow,data);
    log();
    console.log("/////////////////////////////////////////");
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


