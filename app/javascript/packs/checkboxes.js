$(document).ready( function () {
  const checkboxes = $("#fields input:checkbox")
  $("#select-all").click(function(){
    checkboxes.prop("checked", true)
  })
  $("#deselect-all").click(function(){
    checkboxes.prop("checked", false)
  })
})
