/*
    Code to collapse and expand tree nodes
*/

 function toggleNode(a_node) 
      { 
         node = a_node.parentNode.getElementsByTagName('ul')[0] 
         state = node.className; 
         if (state == 'expanded') { 
                state = 'collapsed';
                a_node.innerHTML = '+'; 
              } 
         else { 
                state = 'expanded';
                a_node.innerHTML = '--'
               } 
         node.className = state; 
      } 

