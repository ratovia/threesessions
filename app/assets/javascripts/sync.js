/**
 * Created by ratovia on 2016/12/17.
 */
const poling_time = 5000;
var log = function(){
  console.log("clientText " + JSON.stringify(clientText));
  console.log("clientShadow " + JSON.stringify(clientShadow));
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
    log()
  });
};

// var sort_operation = function(data){
//   for(var i = 0,l = data.length - 1 ;i < l;i++){
//     for(var j = data.length - 1 ; j > i ; j--){
//       if(data[j][0] == "add" && data[j - 1][0] == ""){
//         var tmp = data[j].concat();
//         data[j] = data[j-1];
//         data[j-1] = tmp;
//       }
//     }
//   }
// };

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


