$( function () {
  // Select all and deselect all buttons
  const checkboxes = $("#agencies input:checkbox")
  $("#agency-select-all").on('click', function(){
    checkboxes.prop("checked", true)
  })
  $("#agency-deselect-all").on('click', function(){
    checkboxes.prop("checked", false)
  })

  // Load checked agencies from url
  const agencies = $("#agencies-for-js").data("agencies")
  if (agencies) {
    checkboxes.prop("checked", false);
    agencies.forEach(name => {
      $(`#agency-${name}`).prop("checked", true)
    });
  }
});
