(function($) {

  /* Set global fancy object to be called by generated jsonp */
  var fancy = {};
  window.fancy = fancy;

  var docs;
  var addGithubLinks = false;
  var githubRepo;

  /* A function to set the documentation json */
  fancy.fdoc = function(_addGithubLinks, _githubRepo, _docs) {
    addGithubLinks = _addGithubLinks;
    if(_addGithubLinks) {
      if(_githubRepo) {
        githubRepo = _githubRepo;
      }
    }
    docs = _docs;
  }

  var github_src = function(file, lines) {
    return "http://github.com/"+githubRepo+"/blob/master/"+file+"#L"+lines[0]+"-L"+lines[1];
  }


  var fancyName = function(n) { return n[0] == ":" ? n.substring(1) : n };
  var firstLetter = function(n){ return n[0] == ":" ? n[1] : n[0]; };

  var addTree = function(into, tree, depth) {
    $.each(_.keys(tree).sort(), function(i, name){
      var div = $("<div>").
        css("padding-left", (8*depth.length + 16)+"px").appendTo(into);
      var sub = tree[name];
      var len = _.keys(sub).length;
      var open = $("<span>").addClass("expand").appendTo(div);
      if(len > 0) {
        open.addClass("ui-icon").addClass("ui-icon-carat-1-e");
        open.attr("style", "float:left")
      }
      $("<span>").attr("data-class", depth.concat([name]).join(" ")).
        text(name).addClass("selectable").appendTo(div);
      if(len > 0) {
        addTree(div, sub, depth.concat([name]));
      }
    });
  };

  var populateMethods = function(type, cls) {
      var indexed = _.reduce(_.keys(cls[type]), function(dict, name) {
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
          var mdoc = cls[type][name] || {};
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

          if(mdoc.file && /\.fy$/.test(mdoc.file)) {
            if(addGithubLinks) {
              $("<a>").attr("href", github_src(mdoc.file, mdoc.lines)).
                attr("target", "_blank").
                attr("title", "Source at GitHub").
                append(
                  $("<img>").attr("src", "octocat.png")
              ).addClass("github").appendTo(signature)
            }
          }
        });
      });
      return _.keys(cls[type]).length;
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

    $("[data-class-ref]").live("click", function(event) {
      event.preventDefault();
      var ref = $(this).attr("data-class-ref");
      var cls = $(".classes [data-class='"+ref+"']");
      cls.trigger('click');
      while(!cls.is(":visible")) {
        par = cls.parent();
        par.find("> .expand").trigger("click");
        cls = par;
      }
    });

    $(".classes [data-class]").live("click", function(event) {
      event.preventDefault();
      $('.classes .selectable.ui-state-active').removeClass('ui-state-active');
      $(this).addClass('ui-state-active');
      var class_name = $(this).attr("data-class");
      var cls = docs.classes[class_name];

      $(".subject, .content, .index").html("");

      _.reduce(class_name.split(" "), function(ary, name){
        $("<span>").
          attr("data-class-ref", ary.concat([name]).join(" ")).
          text(name).addClass("selectable").appendTo($(".subject"));
        $("<span>&nbsp;</span>").appendTo($(".subject"));
        return ary.concat([name]);
      }, []);

      $(".class.content").html(cls.doc);


      // hide instance and class method parts if none available
      // otherwise show them
      if(populateMethods("instance_methods", cls) == 0) {
        $(".accordion .instance_methods").hide();
      } else {
        $(".accordion .instance_methods").show();
      }

      if(populateMethods("methods", cls) == 0) {
        $(".accordion .methods").hide();
      } else {
        $(".accordion .methods").show();
      }

      // reset accordion to be closed
      $(".accordion").accordion({
        collapsible: true,
        active: false,
        fillSpace: true
      });

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
      active: false,
      fillSpace: true
    });
  }

  $(main);

})(jQuery);
