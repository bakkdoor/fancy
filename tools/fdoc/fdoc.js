(function($) {

  /* Set global fancy object to be called by generated jsonp */
  var fancy = {};
  window.fancy = fancy;

  /* A function to set the documentation json */
  var docs;
  fancy.fdoc = function(_docs) { docs = _docs; }


  /* populate functions */
  var populateClasses = function() {
    $.each(docs.classes, function(name, obj) {
      var cls_div = $("<div>").text(name)
        .addClass('class').addClass('selectable')
        .appendTo('.classes');
    });

    $(".classes .selectable").live("click", function(event) {
      event.preventDefault();
      var selected_class = $(this).text();
      $(".subject").text(selected_class)
      $(".content").html(docs.classes[selected_class].doc)
    })
  }


  /* the main function */
  var main = function() {
    $("head").append($("<title>").text(docs.title));
    populateClasses();
    $(".sidebar div :even").addClass("even");
    $(".sidebar div :odd").addClass("odd");
  }

  $(main);

})(jQuery);
