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
      var class_name = $(this).text();
      var class = docs.classes[class_name];
      $(".subject").text(class_name);
      $(".content").html(class.doc);
      $(".class-index .instance-methods").html("");
      var fancyName = function(n) { return n[0] == ":" ? n.substring(1) : n };
      var firstLetter = function(n){ return n[0] == ":" ? n[1] : n[0]; };
      var index = _.uniq(_(class.instance_methods).map(firstLetter).sort(), true);
      $.each(index, function(i, letter) {
        $("<div>").text(letter).addClass("selectable").
          appendTo(".class-index .instance-methods");
      });
      $(".instance-methods :even").addClass('even');
      $(".instance-methods :odd").addClass('odd');
      $.each(class.instance_methods, function(i, name) {
        console.debug(name);
      });
    });
  };


  /* the main function */
  var main = function() {
    $("head").append($("<title>").text(docs.title));
    populateClasses();
    $(".sidebar div :even").addClass("even");
    $(".sidebar div :odd").addClass("odd");

    $('.sidebar .theme-roller').themeswitcher();
  }

  $(main);

})(jQuery);
