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

  //show dom element marked by an id anchor in url
  /*var anchor = document.location.hash

  if (anchor != "" && anchor.match(/^#(task|story)_[0-9]+$/)) {
    
    var originalBG = $(anchor).css("background-color"); 
    var highlightBG = "#ffe822";
    $(anchor)
      .animate({backgroundColor:"#ff0000"}, 1500)
      .animate({opacity: 1}, 1500);
  }*/

  // Set focus on login text input for login
  $("input#login,input#user_login").focus();

  // Set zebra style for data tables
  $('table.data tbody tr:nth-child(even)').addClass('even_row');

  // Set info messages dissapear after 5 seconds
  $('#flash').animate({opacity: 1.0}, 5000).hide('slow')

  //Toggle stories view
  $('#toggle_stories').bind("click", 
    function(e){
      if ($('#toggle_stories a strong').text() == "Expand Stories") {
        $('.agile_tasks').show();
        $('#toggle_stories a strong').text("Collapse Stories");
      } else {
        $('.agile_tasks').hide();
        $('#toggle_stories a strong').text("Expand Stories");
      }
    });
  
});

function toggleDrawer(drawerId){
    drawer=document.getElementById(drawerId + '_drawer');
    drawerText=document.getElementById(drawerId + '_drawer_text');
    elementContent=document.getElementById(drawerId + '_drawer_content');
    if (elementContent.style.display=='block') {
        drawer.className='drawer_closed';
        elementContent.style.display='none';
        if (drawerText){
            drawerText.style.display='block';
            drawerText.style.padding='1em';}
        } else {
        drawer.className='drawer_open';
        elementContent.style.display='block';
        if (drawerText){
            drawerText.style.display='none';
            drawerText.style.padding='0';
            }
        }
}

