/**
 * Created by ratovia on 2017/01/15.
 */
$('#mesh_add_button').click(function() {
  var edit = [];
  var ope = [   "mesh_add",
    grant($('div').data('user'),2),
    0
  ];
  edit.push(ope);
  patch(clientText,edit);
});

$('#mesh_remove_button').click(function() {
  var edit = [];
  var ope = [   "mesh_remove",
    clientText.mesh_id[parseInt($(':text[name="mesh_remove_index"]').val())],
    0
  ];
  edit.push(ope);
  patch(clientText,edit);
});

$('#mesh_update_button').click(function() {
  var edit = [];
  var ope = [   "mesh_update",
    clientText.mesh_id[parseInt($(':text[name="mesh_update_index"]').val())],
    [
      clientText.faces_id[parseInt($(':text[name="mesh_update_data"]').val())]
    ]
  ];
  edit.push(ope);
  patch(clientText,edit);
});

$('#face_add_button').click(function() {
  var edit = [];
  var ope = [   "face_add",
    grant($("div").data('user'),1),
    0
  ];
  edit.push(ope);
  patch(clientText,edit);
});

$('#face_remove_button').click(function() {
  var edit = [];
  var ope = [   "face_remove",
    clientText.faces_id[parseInt($(':text[name="face_remove_index"]').val())],
    0
  ];
  edit.push(ope);
  patch(clientText,edit);

});

$('#face_update_button').click(function() {
  var edit = [];
  var ope = [   "face_update",
    clientText.faces_id[parseInt($(':text[name="face_update_index"]').val())],
    [
      clientText.vertices_id[parseInt($(':text[name="face_update_data"]').val())]
    ]
  ];
  edit.push(ope);
  patch(clientText,edit);
});

$('#vertex_add_button').click(function() {
  var edit = [];
  var ope = [   "vertex_add",
    grant($('div').data('user'),0),
    [
      parseFloat($(':text[name="vertex_add_data_x"]').val()),
      parseFloat($(':text[name="vertex_add_data_y"]').val()),
      parseFloat($(':text[name="vertex_add_data_z"]').val())
    ]
  ];
  edit.push(ope);
  patch(clientText,edit);
});

$('#vertex_remove_button').click(function() {
  var edit = [];
  var ope = [   "vertex_remove",
    clientText.vertices_id[parseInt($(':text[name="vertex_remove_index"]').val())],
    0
  ];
  edit.push(ope);
  patch(clientText,edit);
});

$('#vertex_update_button').click(function() {
  var edit = [];
  var ope = [   "vertex_update",
    clientText.vertices_id[parseInt($(':text[name="vertex_update_index"]').val())],
    [
      parseFloat($(':text[name="vertex_update_data_x"]').val()),
      parseFloat($(':text[name="vertex_update_data_y"]').val()),
      parseFloat($(':text[name="vertex_update_data_z"]').val())
    ]
  ];
  edit.push(ope);
  patch(clientText,edit);
});




last = 1;
var grant = function(user,type){
  var rand = function() {
    return 'xxx'.replace(/[xy]/g, function(c) {
      var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
      return v.toString(16);
    });
  };
  
  last++;
  num = [user,type,last,rand()].join('');
  return num
};
