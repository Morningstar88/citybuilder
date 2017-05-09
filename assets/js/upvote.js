var upvote = {
  handleEvent: function(event) {
    var response = JSON.parse(event.data.xhr.response);
    if (response.upvote_post) {
      var upvotes_container = $("#post_" + response.upvote_post + " .upvote-count");
      var current_count = parseInt(upvotes_container.text());
      upvotes_container.text(current_count + 1);
      var upvote_btn = $("#post_" + response.upvote_post + " .upvote-btn");
      upvote_btn.addClass("upvoted");
    }
  }
};

document.addEventListener("ajax:success", upvote, false);
