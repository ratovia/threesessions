/**
 * Created by ratovia on 2017/01/28.
 */
// MAXTIME  = 180000;
// MAXREQUEST = 50;
MAXTIME  = 300000;
MAXREQUEST = 50;
OPERATION = ["mesh_add","mesh_remove","mesh_update",
             "face_add","face_remove","face_update",
             "vertex_add","vertex_remove","vertex_update"
            ];
var myrand = function(val){
  return Math.floor( Math.random() * val)
};

$('#test_button').click(function() {
  console.log("start jikken!");
  for (var i = 0; i < MAXREQUEST; i++) {
    let timerand = myrand(MAXTIME);
    setTimeout(function () {
      let edit = [];
      let ope = makeoperation(OPERATION);
      edit.push(ope);
      patch(clientText, edit);
    }, timerand);
  }
  setTimeout(function(){
    log();
    console.log("end jikken!");
  },MAXTIME + 10000)
});
  
var makeoperation = function(operation){
  let operationrand = myrand(operation.length);

  let target,data;
  switch (operation[operationrand]) {
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
      data = [
        parseFloat((Math.random() * 100).toFixed(3)),
        parseFloat((Math.random() * 100).toFixed(3)),
        parseFloat((Math.random() * 100).toFixed(3))
      ];
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
  let ope = [   operation[operationrand],
    target,
    data
  ];

  return ope
};


MAXTIME_2  = 600000;
MAXREQUEST_2 = 20;
OPERATION_2 = [
  "face_add"
];

$('#test_button_2').click(function() {
  console.log("start jikken2!");
  var time = 0;
  while(time < MAXTIME_2){
    time += 5000;
    for (var i = 0; i < MAXREQUEST_2; i++) {
      setTimeout(function () {
        let edit = [];
        let ope = makeoperation(OPERATION_2);
        edit.push(ope);
        patch(clientText, edit);
      }, time);
    }
  }
  console.log("operation setup");
  setTimeout(function(){
    log();
    console.log("end jikken!");
  },MAXTIME + 10000)
});


MAXTIME_3  = 40000;
OPERATION_3 = [
  "face_add"
];

$('#test_button_3').click(function() {
  console.log("start jikken3!");
  var time = 0;
  var request = 1;
  while(time < MAXTIME_3){
    time += 4000;
    request = request * 2;
    for (var i = 0; i < request; i++) {
      setTimeout(function () {
        let edit = [];
        let ope = makeoperation(OPERATION_3);
        edit.push(ope);
        patch(clientText, edit);
      }, time);
    }
  }
  setTimeout(function(){
    log();
    console.log("end jikken!");
  },MAXTIME + 10000)
});

