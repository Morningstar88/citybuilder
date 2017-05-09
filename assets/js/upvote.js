document.addEventListener("ajax:success", function(event) {
  if (event.target && event.target.hasAttribute("ujs-remote")) {
    var response = JSON.parse(event.data.xhr.response);
    var post_id = response.post_id;
    var upvotes_container = $("#post_" + response.post_id + " .upvote-count");
    var current_count = parseInt(upvotes_container.text());
    var upvote_btn = $("#post_" + response.post_id + " .upvote-btn");
    var upvote_delete_btn = $("#post_" + response.post_id + " .upvote-delete-btn");
    if (response.action == "upvote") {
      upvotes_container.text(current_count + 1);
      upvote_btn.addClass("hidden");
      upvote_delete_btn.removeClass("hidden");
    } else if (response.action == "delete_upvote") {
      upvotes_container.text(current_count - 1);
      upvote_delete_btn.addClass("hidden");
      upvote_btn.removeClass("hidden");
    }
  }
});
