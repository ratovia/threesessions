/**
 * Created by ratovia on 2017/01/15.
 */
$('#face_button').click(function() {
  console.log("face");
  var edit = [];
  var ope = [   "face",
    grant($("div").data('user'),1),
    [ 
      $(':text[name="face_1"]').val(),
      $(':text[name="face_2"]').val(),
      $(':text[name="face_3"]').val(),
      $(':text[name="face_4"]').val()
    ]
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
      parseFloat($(':text[name="add_x"]').val()),
      parseFloat($(':text[name="add_y"]').val()),
      parseFloat($(':text[name="add_z"]').val())
    ]
  ];
  edit.push(ope);
  patch(clientText,edit);
  console.log("aaa");
  log();
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
      parseFloat($(':text[name="move_x"]').val()),
      parseFloat($(':text[name="move_y"]').val()),
      parseFloat($(':text[name="move_z"]').val())
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