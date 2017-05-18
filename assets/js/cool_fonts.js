// console.clear(); // Is this line causing font storage to wipe on page refresh?
var fontsArr = ['Raleway', 'Josefin Sans', 'Montserrat', 'Quicksand', 'Marck Script'];
var $fontSelector = $('.font-selector select');
var $preview = $('.preview-title');
var $fontTextSelector = $('.font-selector-text select');
var $previewText = $('.preview-text');
$fontSelector.on('change', function() {
  $(this).css({
    fontFamily: $(this).val()
  });
  $preview.css({
    fontFamily: $(this).val()
  });
});
$fontTextSelector.on('change', function() {
  $(this).css({
    fontFamily: $(this).val()
  });
  $previewText.css({
    fontFamily: $(this).val()
  });
});
_.forEach(fontsArr, function(fontName, index){
  var $option = $('<option style="font-family:'+fontName+'">'+fontName+'</option>');
  $fontSelector.append($option);
});
_.forEach(fontsArr, function(fontName, index){
  var $option = $('<option style="font-family:'+fontName+'">'+fontName+'</option>');
  $fontTextSelector.append($option);
});
$fontSelector.trigger('change');
WebFont.load({
  google: {
    families: fontsArr 
  }
});