document.addEventListener("ajax:success", function(event) {
  if (event.target && event.target.hasAttribute("ujs-eval")) {
    eval(event.data.xhr.responseText);
  };
});
