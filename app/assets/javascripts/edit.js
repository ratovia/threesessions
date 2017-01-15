/**
 * Created by ratovia on 2017/01/15.
 */
$('#face_button').click(function() {
  var edit = [];
  var ope = [   "face",
    grant($("div").data('user')),
    0
  ];
  edit.push(ope);
  patch(clientText,edit);
});

$('#deface_button').click(function() {
  var edit = [];
  var ope = [   "deface",
    $(':text[name="deface_uuid"]').val(),
    0
  ];
  edit.push(ope);
  patch(clientText,edit);
});

$('#add_button').click(function() {
  var edit = [];
  var ope = [   "add",
    grant($('div').data('user'),0),
    [
      $(':text[name="add_x"]').val().toString(),
      $(':text[name="add_y"]').val().toString(),
      $(':text[name="add_z"]').val().toString()
    ]
  ];
  edit.push(ope);
  patch(clientText,edit);
});

$('#remove_button').click(function() {
  var edit = [];
  var ope = [   "remove",
    $(':text[name="remove_uuid"]').val(),
    0
  ];
  edit.push(ope);
  patch(clientText,edit);
});

$('#move_button').click(function() {
  var edit = [];
  var ope = [   "move",
    $(':text[name="move_uuid"]').val(),
    [
      $(':text[name="move_x"]').val().toString(),
      $(':text[name="move_y"]').val().toString(),
      $(':text[name="move_z"]').val().toString()
    ]
  ];
  edit.push(ope);
  patch(clientText,edit);
});

var grant = function(user,type){
  var createUUID = function() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
      return v.toString(16);
    });
  };
  num = [user,type,createUUID()].join('');
  return num
};