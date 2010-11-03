(function($) {

  /* Set global fancy object to be called by generated jsonp */
  var fancy = {};
  window.fancy = fancy;

  /* A function to set the documentation json */
  var docs;
  fancy.fdoc = function(_docs) { docs = _docs; }

  var github_src = function(file, lines) {
    return "http://github.com/bakkdoor/fancy/blob/master/"+file+"#L"+lines[0]+"-L"+lines[1];
  }


  var fancyName = function(n) { return n[0] == ":" ? n.substring(1) : n };
  var firstLetter = function(n){ return n[0] == ":" ? n[1] : n[0]; };

  var addTree = function(into, tree, depth) {
    $.each(_.keys(tree).sort(), function(i, name){
      var div = $("<div>").
        css("padding-left", (8*depth.length)+"px").appendTo(into);
      var sub = tree[name];
      var len = _.keys(sub).length;
      var open = $("<span>").addClass("expand").appendTo(div);
      if(len > 0) {
        open.addClass("ui-icon").addClass("ui-icon-carat-1-e");
      }
      $("<span>").attr("data-class", depth.concat([name]).join(" ")).
        text(name).addClass("selectable").appendTo(div);
      if(len > 0) {
        addTree(div, sub, depth.concat([name]));
      }
    });
  };

  var populateMethods = function(type, class) {

      var indexed = _.reduce(_.keys(class[type]), function(dict, name) {
        var first = firstLetter(name);
        var ms = dict[first] || [];
        dict[first] = ms;
        ms.push(name);
        return dict;
      }, {});

      var index = _.keys(indexed).sort();
      $.each(index, function(i, letter) {
        $("<a>").text(letter).
          attr("href", "#"+type+"_"+letter).
          addClass("ui-state-default").
          addClass("selectable").
          appendTo(".index."+type);
        $("<a name='"+type+"_"+letter+"'/>").appendTo(".content."+type);
        var section = $("<div>").append(
          $("<div>").addClass("letter").append(
            $("<span>").addClass("box").addClass("ui-corner-all").
              addClass("ui-state-highlight").text(letter)
          )
        ).addClass("section").appendTo(".content."+type);
        $.each(indexed[letter], function(j, name) {
          var method = $("<div>").addClass("method").appendTo(section);
          var mdoc = class[type][name] || {};
          var names = [];
          if(/^:/.test(name)) {
            names = [name.substring(1)]
          } else if(/:$/.test(name)) {
            names = name.split(":");
            if(names[names.length - 1] == "") { names.pop(); }
            names = _.map(names, function(n){ return n + ":"; })
          } else {
            names = [name];
          }
          names = _.map(names, function(n){return $("<span>").text(n).addClass("ui-priority-primary").addClass("selector")});
          arg = mdoc.arg || [];
          args = _.map(arg, function(n){return $("<span>").text(n).addClass("ui-priority-secondary").addClass("arg")});

          var signature = $("<div>").addClass("signature").addClass("ui-accordion-header ui-state-default").appendTo(method);
          _.each(_.flatten(_.zip(names, args)), function(e){ signature.append(e); });

          var content = $("<div>").addClass("docs").addClass("ui-widget-content").html(mdoc.doc || "Not documented").appendTo(method);

          console.debug(name, mdoc.lines);
          if(mdoc.file && /\.fy$/.test(mdoc.file)) {
            $("<a>").attr("href", github_src(mdoc.file, mdoc.lines)).
              attr("target", "_blank").
              attr("title", "Source at GitHub").
              append(
                $("<img>").attr("src", "http://static.tumblr.com/vwpvxmx/5Wclbbqbj/github.png")
            ).addClass("github").appendTo(signature)
          }
        });
      });

  }

  /* populate functions */
  var populateClasses = function() {

    var cls_tree = {};
    $.each(docs.classes, function(cls_name){
      _.reduce(cls_name.split(" "), function(tree, name) {
        return tree[name] = tree[name] || {};
      }, cls_tree);
    });

    addTree($(".classes"), cls_tree, []);

    $(".classes .expand").live("click", function(event){
      event.preventDefault();
      if($(this).hasClass("ui-icon-carat-1-e")) {
        $(this).removeClass("ui-icon-carat-1-e").addClass("ui-icon-carat-1-s");
        $(this).parent().children("div").slideDown('fast');
      } else {
        $(this).removeClass("ui-icon-carat-1-s").addClass("ui-icon-carat-1-e");
        $(this).parent().children("div").slideUp('fast');
      }
    });

    $("[data-class]").live("click", function(event) {
      event.preventDefault();
      $('.classes .selectable.ui-state-active').removeClass('ui-state-active');
      $(this).addClass('ui-state-active');
      var class_name = $(this).attr("data-class");
      var class = docs.classes[class_name];

      $(".subject, .content, .index").html("");

      _.reduce(class_name.split(" "), function(ary, name){
        $("<span>").
          attr("data-class", ary.concat([name]).join(" ")).
          text(name).addClass("selectable").appendTo($(".subject"));
        $("<span>&nbsp;</span>").appendTo($(".subject"));
        return ary.concat([name]);
      }, []);

      $(".class.content").html(class.doc);


      populateMethods("instance_methods", class);
      populateMethods("methods", class);
    });
  };


  /* the main function */
  var main = function() {

    $("head").append($("<title>").text(docs.title));

    populateClasses();

    $(".classes > div div").hide();

    $(".sidebar div > div:even").addClass("even");
    $(".sidebar div > div:odd").addClass("odd");
    $(".selectable").live('mouseenter', function() {
      $(this).addClass("ui-state-hover");
    });
    $(".selectable").live('mouseleave', function() {
      $(this).removeClass("ui-state-hover");
    });

    $(".accordion").accordion({
      collapsible: true,
      fillSpace: true
    });

    $('.sidebar .theme-roller').themeswitcher({ loadTheme: 'Flick' });

  }

  $(main);

})(jQuery);
