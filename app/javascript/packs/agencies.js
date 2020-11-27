
$(document).ready( function () {
  const checkboxes = $("#agencies input:checkbox")
  $("#agency-select-all").click(function(){
    checkboxes.prop("checked", true)
  })
  $("#agency-deselect-all").click(function(){
    checkboxes.prop("checked", false)
  })

  const agencies = $("#agencies-for-js").data("agencies")
  if (agencies) {
    agencies.forEach(name => {
      $(`#agency-${name}`).prop("checked", true)
    });
  }

  var options = {
    searchClass: 'agency-filter',
    valueNames: [ 'agency-name' ]
  };
  new List('agencies', options);

})