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

  // Set focus on login text input for login
  $("input#login,input#user_login").focus();

  // Set zebra style for data tables
  $('table.data tbody tr:nth-child(even)').addClass('even_row');

  // Set info messages dissapear after 5 seconds
  $('#flash').animate({opacity: 1.0}, 5000).hide('slow')
  
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

