import List from 'list.js';

$( function () {
  // Add .agency-separator to agency pipe separator
  $(".agency-names").html(function(_, html){
    return html.replace("|","<span class='agency-separator'>|</span>");
  });

  // Deselect all buttons
  $(".clear-all").on('click', function(){
    const parentId = $(this).parent()[0].id; // "sections" or "agencies"
    // uncheck the checkboxes, fire the change event
    $(`#${parentId} input:checkbox`).prop("checked", false).trigger("change")
    // for dates
    if (parentId == 'publication-date-fields') {
      clearDatesFilter();
    }
  });

  // Get :checked on load and create badges
  $(".sidebar :checked").each(function(){
    if (this.name === "fields[]") {
      addBadge(this.id, "sections");
    } else if (this.name === "agencies[]") {
      addBadge(this.id, "agencies");
    }
  });

  //Add badge for date filters if populated
  if (parseInt($("#starting_year").val()) || parseInt($("#ending_year").val())) {
    publicationDateValidation();
  }

  // Listener for checkboxes
  $(".sidebar input:checkbox").on('change', function(){
    const parentId = $(this).parent().parent().parent()[0].id; // "sections" or "agencies"
    if (this.checked) {
      addBadge(this.id, parentId);
    } else {
      removeBadge(this.id, parentId);
    }
  });

  // Validate the publication date input
  $("#starting_year").on("change", publicationDateValidation);
  $("#ending_year").on("change", publicationDateValidation);

  // Listener for remove badge link
  $(document).on('click', 'a.remove-badge', function () {
    // uncheck the matching checkbox
    const checkboxId = $(this).parent()[0].id.replace("-badge","");
    $(`#${checkboxId}`).prop("checked", false).trigger("change");
    // clear date filters
    if ($(this).parent()[0].id == "active-date-range") {
      clearDatesFilter();
    }
  });

  agencyFiltering();

  hideEmptyFormFieldsFromUrl();
});

function addBadge(id, parentId){
  const $badge = $(`#${id}-badge`)
  const $filterSection = $(`#active-${parentId}-filters`)
  $badge.css("display", "inline-block");

  // show badges section if hidden
  if ($filterSection.is(":hidden") ){
    $filterSection.show();
  }
}

function removeBadge(id, parentId){
  const $badge = $(`#${id}-badge`)
  const $filterSection = $(`#active-${parentId}-filters`)

  $badge.hide();

  // hide badges section if empty
  if ( $filterSection.find(".active-filter:visible").length == 0 ){
    $filterSection.hide();
  }
}

function agencyFiltering() {
  const options = {
    searchClass: 'agency-filter',
    valueNames: [ 'agency-name', 'agency-short-name' ]
  };

  const agencyList = new List('agencies', options);

  // Ensures agencies that are checked, but currently filtered out
  // are included in the search request
  // during an agency name search
  agencyList.on('searchComplete', function() {
    updateAgencyFilterHelpText(agencyList);
    includeFilteredCheckedAgenciesInSearch(agencyList);
  });
}

function updateAgencyFilterHelpText(agencyList){
  let agencyFilterText = $("#agency-search").val();
  let count = agencyList.visibleItems.length;
  let pluralOrSingular = count == 1 ? " agency" : " agencies"
  // example -> general matches 2 agencies
  $("#agency-filter-help-text").text(agencyFilterText + " matches " + count + pluralOrSingular);

  // No help text if empty
  if (agencyFilterText == "") {
    $("#agency-filter-help-text").text("");
  }
}

function includeFilteredCheckedAgenciesInSearch(agencyList) {
  // loop through all of the agencies
  agencyList.items.forEach(agency => {
    // looking for checked boxes
    // agency.elm is the container <div class="usa-checkbox">
    let checkbox = agency.elm.children[0]
    if ( checkbox.checked ) {
      if (agency.visible() == false) {
        // if it is filtered out, add it to the list as a hidden checkbox
        // so that it is included if the search button is clicked
        $(agency.elm).hide().appendTo("#selected-agencies");
      } else {
        // show again if it is no longer filtered out
        $(agency.elm).show();
      }
    }
  });
}

function publicationDateValidation(){
  let startYear = parseInt($("#starting_year").val());
  let endYear = parseInt($("#ending_year").val());
  if (startYear > endYear) {
    $("#starting_year")[0].setCustomValidity("Starting year should be earlier than the ending year.");
  } else if (startYear < "1994") {
    $("#starting_year")[0].setCustomValidity("Sorry, this tool only contains SORNs starting from 1994. Please enter a later starting year");
  } else {
    $("#starting_year")[0].setCustomValidity('');
    // If dates are valid, create badge
    createDatesFilter(startYear, endYear);
  }
}

function createDatesFilter(startYear, endYear){
  const $filterSection = $('#active-date-filter')
  const $badge = $("#active-date-range")
  const $dates = $("#active-date-range span")
  if (isNaN(startYear)){
    startYear = "1994"
  } else if (isNaN(endYear)) {
    const d = new Date();
    endYear = d.getFullYear();
  }
  $dates.text(`${startYear} - ${endYear}`)
  if ($filterSection.is(":hidden")) {
    $filterSection.show();
    $badge.css("display", "inline-block");
  }
}

function clearDatesFilter(){
  // clear inputs
  $("#starting_year").val('');
  $("#ending_year").val('');
  // hide badges section
  $('#active-date-range').hide();
  $(`#active-date-filter`).hide();
}

function hideEmptyFormFieldsFromUrl(){
  // prevents &starting_year=&ending_year= from appearing in every request
  $("#search-form").on("submit", function() {
    $(this).find(":input").filter(function(){ return !this.value; }).attr("disabled", "disabled");
    return true; // ensure form still submits
  });

  // Un-disable form fields when page loads, in case they click back after submission
  $( "#search-form" ).find( ":input" ).prop( "disabled", false );
}