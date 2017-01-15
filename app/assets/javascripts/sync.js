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

// var  clientText = {
//   'faces':[[0,1,3,2],[2,3,7,6],[6,7,5,4],[1,0,4,5],[4,0,2,6]],
//   'faces_id':[100,101,102,103,104],
//   'vertices':[-1,-1,1,-1,1,1,-1,-1,-1,-1,1,-1,1,-1,1,1,1,1,1,1,-1],
//   'vertices_id':[100,101,102,103,104,105,107]
// };
//
// var  clientShadow = {
//   'faces':[[0,1,3,2],[6,7,5,4],[1,0,4,5],[4,0,2,6]],
//   'faces_id':[100,102,103,104],
//   'vertices':[-1,1,1,-1,-1,-1,-1,1,-1,1,-1,1,1,1,1,1,-1,-1,1,1,-1],
//   'vertices_id':[101,102,103,104,105,106,107]
// };


// var  clientShadow = {
//   'faces':[],
//   'faces_id':[],
//   'vertices':[],
//   'vertices_id':[]
// };
// var clientShadow = $.extend(true,{},clientText);
// clientText.vertices[3] = 10;
// clientText.vertices[4] = 10;
// clientText.vertices[5] = 10;
// console.log("edit");
// log();
//
// console.log(res);
// $('.edit').text("edit " + JSON.stringify(res));

// log();

var syncronization = function(){
  var res = diff(clientText,clientShadow);
  log();
  makeshadow(clientText);
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

var makeshadow = function(text){
  var shadow = {
    'faces':text.faces,
    'faces_id':text.faces_id,
    'vertices':text.vertices,
    'vertices_id':text.vertices_id
  };
  return shadow
};


var  clientText = {
  'faces':[],
  'faces_id':[],
  'vertices':[],
  'vertices_id':[]
};


var clientShadow = makeshadow(clientText);
setInterval(syncronization,poling_time);


