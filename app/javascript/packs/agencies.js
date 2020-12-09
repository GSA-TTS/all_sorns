
$( function () {
  const checkboxes = $("#agencies input:checkbox")
  $("#agency-select-all").on('click', function(){
    checkboxes.prop("checked", true)
  })
  $("#agency-deselect-all").on('click', function(){
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
  agencyList = new List('agencies', options);

  // Keep selected agencies visible when checked
  // Also ensures they are always included in the search request
  agencyList.on('searchComplete', function() {
    showChecked();
    sortChecked();
  })

  function showChecked () {
    // make a list
    agencyList.items.forEach(agency => {
      // agency.elm is the container <div class="usa-checkbox">
      // agency.elm.children[0] is the checkbox
      checkbox = agency.elm.children[0]
      if ( checkbox.checked ) {
        agency.show();
        // $(agency.elm).prependTo("#selected-agencies");
      }
    })
  }

  function sortChecked(){
    checked = $("#agencies :checked")
    console.log(checked)
    checked.each(function(i, obj){
      $(obj).parent().prependTo("#selected-agencies");
    })
  }
})
