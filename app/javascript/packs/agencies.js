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
    agencies.forEach(name => {
      $(`#agency-${name}`).prop("checked", true)
    });
  }

  // List.js to make list of agencies filterable
  var options = {
    searchClass: 'agency-filter',
    valueNames: [ 'agency-name' ]
  };
  agencyList = new List('agencies', options);

  // Keep selected agencies visible when checked
  // keep alphabetical sort
  // Also ensures they are always included in the search request
  agencyList.on('searchComplete', function() {
    agencyList.sort('agency-name');
    if (agencyList.searched == true) {
      showChecked();
    }
  })

  function showChecked () {
    agencyList.items.reverse().forEach(agency => {
      // agency.elm is the container <div class="usa-checkbox">
      // agency.elm.children[0] is the checkbox
      checkbox = agency.elm.children[0]
      if ( checkbox.checked ) {
        agency.show();
        $(agency.elm).prependTo("#selected-agencies");
      }
    })
  }
})
