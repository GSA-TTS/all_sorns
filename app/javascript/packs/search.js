$( function () {
   // Add .agency-separator to agency pipe separator
  $(".agency-names").html(function(_, html){
    return html.replace("|","<span class='agency-separator'>|</span>");
  });

  // Deselect all buttons
  $(".clear-all").on('click', function(){
    const parentId = $(this).parent()[0].id; // "sections" or "agencies"
    // uncheck the checkboxes, fire the change event
    $(`#${parentId} input:checkbox`).prop("checked", false).trigger("change");
  })

  // Get :checked on load and create badges
  $(".sidebar :checked").each(function(){
    if (this.name === "fields[]") {
      addBadge(this.id, "sections")
    } else if (this.name === "agencies[]") {
      addBadge(this.id, "agencies")
    }
  })
  
  // Listener for checkboxes
  $(".sidebar input:checkbox").on('change', function(){
    const parentId = $(this).parent().parent().parent()[0].id; // "sections" or "agencies"
    if(this.checked) {
      addBadge(this.id, parentId)
    } else {
      removeBadge(this.id, parentId)
    }
  });

  // Validate the publication date input
  $("#starting_year").on("change", publicationDateValidation)
  $("#ending_year").on("change", publicationDateValidation)

  // Listener for remove badge link
  $(document).on('click', 'a.remove-badge', function () {
    // uncheck the matching checkbox
    checboxId = $(this).parent()[0].id.replace("-badge","");
    $(`#${checboxId}`).prop("checked", false).trigger("change");
  });

  agencyListing()
});

function addBadge(id, parentId){
  $badge = $(`#${id}-badge`)
  $filterSection = $(`#active-${parentId}-filters`)

  $badge.css("display", "inline-block");

  // show badges section if hidden
  if ($filterSection.is(":hidden") ){
    $filterSection.show();
  }
}

function removeBadge(id, parentId){
  $badge = $(`#${id}-badge`)
  $filterSection = $(`#active-${parentId}-filters`)

  $badge.hide();

  // hide badges section if empty
  if ( $filterSection.find(".active-filter:visible").length == 0 ){
    $filterSection.hide();
  }
}

function agencyListing() {
  var options = {
    searchClass: 'agency-filter',
    valueNames: [ 'agency-name', 'agency-short-name' ]
  };

  agencyList = new List('agencies', options);

  // Ensures they are always included in the search request
  agencyList.on('searchComplete', function() {
    agencyList.sort('agency-name');
    if (agencyList.searched == true) {
      includeChecked();
    }
  })
}

function includeChecked () {
  agencyList.items.forEach(agency => {
    // agency.elm is the container <div class="usa-checkbox">
    checkbox = agency.elm.children[0]
    if ( checkbox.checked ) {
      if (agency.visible() == false) {
        $(agency.elm).hide().appendTo("#selected-agencies");
      } else {
        $(agency.elm).show()
      }
    }
  })
}

function publicationDateValidation(){
  startYear = parseInt($("#starting_year").val())
  endYear = parseInt($("#ending_year").val())
  if (startYear > endYear) {
    $("#starting_year")[0].setCustomValidity("Starting year should be earlier than the ending year.");
  } else if (startYear < "1994") {
    $("#starting_year")[0].setCustomValidity("Sorry, this tool only contains SORNs starting from 1994. Please enter a later starting year");
  } else {
    $("#starting_year")[0].setCustomValidity('');
  }
}
