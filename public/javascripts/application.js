//display elements in collection in firebug
//TODO: fix sorting
jQuery.fn.debug = jQuery.fn.dbg = function () {
  var elements = $.makeArray(this);
  return elements.sort(
    function(a,b){
      if (a.toString() < b.toString()) return -1;
      if (a.toString() > b.toString()) return 1;
      return 0;
      });
};


$(function() {

  //anchor received from url (or empty string)
  var anchor = document.location.hash
  var path = document.location.pathname.split("/")
  var is_iteration_page = (path[1] == "iterations" && path[3] == "stories");
  
  // Set focus on login text input for login
  $("input#login,input#user_login,input#agile_task_name,input#story_name,input#milestone_name,input#feature_name").focus();

  // Set zebra style for data tables
  $('table.data tbody tr:nth-child(even)').addClass('even_row');

  // Set info messages dissapear after 5 seconds
  $('#flash').animate({opacity: 1.0}, 5000).hide('slow')
 

  $('#show_deadline').bind("click", function(e) {
    $(this).attr("checked") ? $('#deadline_field').show() : $('#deadline_field').hide();
  });

  //behavior of iteration page: /iterations/1/stories
  if (is_iteration_page) {

    function collapse (collapse) {
      var msg = collapse ? "Expand Stories" : "Collapse Stories"
      collapse ? $('.folder_content').hide("slide",{},200) : $('.folder_content').show("slide",{},200);
      $('#toggle_stories a').text(msg);
    }

    function saveCollapseState(collapse) {
      $.ajax({
        type: "PUT",
        url: "/iterations/" + path[2],
        data: "collapse=" + collapse,
      });
    }

    // highlights temporary and anchor for story or task
    if (anchor != "" && anchor.match(/^#(task|story)_[0-9]+$/)) {
      var originalBG = $(anchor).css("background-color"); 
      var highlightBG = "#ffe822";
      $.scrollTo(anchor, 1000, {offset:-150});
      $(anchor).animate({opacity: 1},500, 
        function(){
          $(anchor).effect("highlight",{},3000);
        });
    }

    //Toggle stories view
    $('#toggle_stories').bind("click", 
      function(e){
        if ($('#toggle_stories a').text() == "Expand Stories" && is_iteration_page) {
          collapse(false);
          saveCollapseState("false");
        } else {
          collapse(true);
          saveCollapseState("true");
        }
      }
    );
  }

  //Toggle drawer
  $('.drawer').bind("click", function(e){
    $(this).toggleClass("drawer_open").toggleClass("drawer_closed").children().toggleClass("hidden_div").end().next().toggleClass("hidden_div");
  });

});
