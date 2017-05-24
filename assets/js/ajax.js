document.addEventListener("ajax:success", function(event) {
  if (event.target && event.target.hasAttribute("ujs-json")) {
    var response = JSON.parse(event.data.xhr.response);
    var post_id = response.post_id;
    var upvotes_container = $("#post_" + response.post_id + " .upvote-count");
    var current_count = upvotes_container.data("current-count");
    var upvote_add_btn = $("#post_" + response.post_id + " .upvote-add-btn");
    var upvote_delete_btn = $("#post_" + response.post_id + " .upvote-delete-btn");
    if (response.action == "upvote") {
      current_count = current_count + 1;
      upvote_add_btn.addClass("hidden");
      upvote_delete_btn.removeClass("hidden");
    } else if (response.action == "delete_upvote") {
      current_count = current_count - 1;
      upvote_delete_btn.addClass("hidden");
      upvote_add_btn.removeClass("hidden");
    }
    var upvote_btns = $("#post_" + response.post_id + " .upvote-btn");
    upvote_btns.text("⇧ " + current_count);
    upvotes_container.data("current-count", current_count);
  } else if (event.target && event.target.hasAttribute("ujs-eval")) {
    eval(event.data.xhr.responseText);
  };
});
