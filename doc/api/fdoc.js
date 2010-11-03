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
      $('.classes .selectable.ui-state-active').removeClass('ui-state-active');
      $(this).addClass('ui-state-active');
      var class_name = $(this).text();
      var class = docs.classes[class_name];
      $(".subject").text(class_name);
      $(".content").html(class.doc);
      $(".class-index .instance-methods, .class-content").html("");
      var fancyName = function(n) { return n[0] == ":" ? n.substring(1) : n };
      var firstLetter = function(n){ return n[0] == ":" ? n[1] : n[0]; };
      var indexed = _.reduce(class.instance_methods, function(dict, name) {
        var first = firstLetter(name);
        var ms = dict[first] || [];
        dict[first] = ms;
        ms.push(name);
        return dict;
      }, {});
      var index = _.keys(indexed).sort();
      $.each(index, function(i, letter) {
        $("<div>").text(letter).addClass("selectable").
          appendTo(".class-index .instance-methods");
        var section = $("<div>").append(
            $("<div>").text(letter).addClass("ui-state-default").addClass("letter")
          ).addClass("section").appendTo(".class-content");
        $.each(indexed[letter], function(j, name) {
          var method = $("<div>").text(name).addClass("method").appendTo(section);
        });
      });
      $(".instance-methods > div:even").addClass('even');
      $(".instance-methods > div:odd").addClass('odd');
    });
  };


  /* the main function */
  var main = function() {

    $("head").append($("<title>").text(docs.title));
    populateClasses();
    $(".sidebar div > div:even").addClass("even");
    $(".sidebar div > div:odd").addClass("odd");
    $(".selectable").hover(function() {
      $(this).addClass("ui-state-hover");
    }, function() {
      $(this).removeClass("ui-state-hover");
    })

    $('.sidebar .theme-roller').themeswitcher({ loadTheme: 'Flick' });

  }

  $(main);

})(jQuery);
