$(document).ready( function () {
  const checkboxes = $("#fields input:checkbox")
  $("#select-all").click(function(){
    checkboxes.prop("checked", true)
  })
  $("#deselect-all").click(function(){
    checkboxes.prop("checked", false)
  })

  const fields = $("#fields-for-js").data("fields")
  if (fields) {
    checkboxes.prop("checked", false)
    fields.forEach(field => {
      $(`#search-${field}`).prop("checked", true)
    });
  }
})
