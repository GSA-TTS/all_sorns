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

  $badge.css("display", "inline");

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

  var hackerList = new List('agencies', options);

  console.log(hackerList)
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
