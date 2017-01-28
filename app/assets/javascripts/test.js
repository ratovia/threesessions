/**
 * Created by ratovia on 2017/01/28.
 */
// MAXTIME  = 180000;
// MAXREQUEST = 50;
MAXTIME  = 18000;
MAXREQUEST = 5;
OPERATION = ["mesh_add","mesh_remove","mesh_update","face_add","face_remove","face_update","vertex_add","vertex_remove","vertex_update"];
var myrand = function(val){
  return Math.floor( Math.random() * val)
};

$('#test_button').click(function() {
  for (var i = 0; i < MAXREQUEST; i++) {
    let timerand = myrand(MAXTIME);
    setTimeout(function () {
      let edit = [];
      let ope = makeoperation();
      edit.push(ope);
      patch(clientText, edit);
    }, timerand);
  }
});
  
var makeoperation = function(){
  let operationrand = myrand(OPERATION.length);

  let target,data;
  switch (OPERATION[operationrand]) {
    case "mesh_add":
      target =  grant($('div').data('user'),2);
      data = 0;
      break;
    case "mesh_remove":
      target = clientText.mesh_id[myrand(clientText.mesh_id.length)];
      data = 0;
      break;
    case "mesh_update":
      target = clientText.mesh_id[myrand(clientText.mesh_id.length)];
      data = [
        clientText.faces_id[myrand(clientText.faces_id.length)]
      ];
      break;
    case "face_add":
      target =  grant($('div').data('user'),1);
      data = 0;
      break;
    case "face_remove":
      target = clientText.faces_id[myrand(clientText.faces_id.length)];
      data = 0;
      break;
    case "face_update":
      target = clientText.faces_id[myrand(clientText.faces_id.length)];
      data = [
        clientText.vertices_id[myrand(clientText.vertices_id.length)]
      ];
      break;
    case "vertex_add":
      target =  grant($('div').data('user'),0);
      data = 0;
      break;
    case "vertex_remove":
      target = clientText.vertices_id[myrand(clientText.vertices_id.length)];
      data = 0;
      break;
    case "vertex_update":
      target = clientText.vertices_id[myrand(clientText.vertices_id.length)];
      data = [
        parseFloat((Math.random() * 100).toFixed(3)),
        parseFloat((Math.random() * 100).toFixed(3)),
        parseFloat((Math.random() * 100).toFixed(3))
      ];
      break;
  }
  let ope = [   OPERATION[operationrand],
    target,
    data
  ];

  return ope
};

