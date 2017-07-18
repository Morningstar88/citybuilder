$(document).ready(function() {
  $('a[data-toggle=modal]').click(function() {
    var data_id = $(this).data('postId');

    $.ajax({
      url: "/posts/" + data_id + "/preview",
    }).done(function(preview) {
      $('#postModal .modal-body').html(preview);
    });
  });

  $('a#closePostModal').click(function() {
    $('#postModal .modal-body').empty();
  });
});
