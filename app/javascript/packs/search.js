$( function () {
   // Add .agency-separator to agency pipe separator
  $(".agency-names").html(function(_, html){
    return html.replace("|","<span class='agency-separator'>|</span>");
  });

  // Deselect all buttons
  $(".clear-all").on('click', function(){
    const parent_id = $(this).parent()[0].id
    if (parent_id === "fields") {
      $("#sorn-fields input:checkbox").prop("checked", false)
      $section = 'fields'
      $container = $("#active-section-filters")
    } else if (parent_id === "agency-accordion") {
      $("#agencies input:checkbox").prop("checked", false)
      $section = 'agencies'
      $container = $("#active-agency-filters")
    }
    clear_badges($section, $container)
  })
  
  // Validate the publication date input
  $("#starting_year").on("change", publicationDateValidation)
  $("#ending_year").on("change", publicationDateValidation)

  // Listener for checkboxes
  $(".sidebar input:checkbox").on('change', function(){
    if(this.checked) {
      const parent_id = $(this).parent().parent()[0].id;
      if (parent_id === "sorn-fields") {
        $section = $("#active-section-filters");
        $container = $("#active-fields")
      } else if(parent_id === "selected-agencies") {
        $section = $("#active-agency-filters");
        $container = $("#active-agencies")
      }

      add_badge(this.id, this.value, $section, $container)

    }else{
      // add '-badge' to id to remove
      $(`#active-filters #${this.id}-badge`).remove()
      if ( $("#active-section-filters .active-filter").length == 0 ){
        $("#active-section-filters").hide();
      }
      if ( $("#active-agency-filters .active-filter").length == 0 ){
        $("#active-agency-filters").hide();
      }
    }
  });

  // Listener for remove badge link
  $(document).on('click', 'a.remove-badge', function (e) {
    e.preventDefault()
    remove_badge($(this).parent())

    // strip '-badge' from id before calling
    uncheck_filter($(this).parent().attr('id').replace('-badge',''))

    if ( $("#active-section-filters .active-filter").length == 0 ){
      $("#active-section-filters").hide();
    }
    if ( $("#active-agency-filters .active-filter").length == 0 ){
      $("#active-agency-filters").hide();
    }
  });
});

// add filter badge and sort elements
function add_badge(id, value, $section, $container){
  // add '-badge' to ids for active filters
  var $new_badge = `<div class="active-filter" id="${id}-badge">${value}<a href="#" class="remove-badge">[X]</a></div>`

  $container.append($new_badge)

  var $filters = $section.find('.active-filter').clone().get()

  var $sorted = $filters.sort(function(a, b) {
    if (a.textContent < b.textContent) {
      return -1;
    } else {
      return 1;
    }
  });

  $container.html($sorted)

  if ( $section.is(":hidden") ){
    $section.show();
  }
};

// remove filter badge
function remove_badge(div){
  div.remove()
};

function clear_badges(section, container){
  $(`#active-${section}`).empty()
  $container.hide()
};

// uncheck filter
function uncheck_filter(id){
  var n = $(`input:checkbox[id^="${id}"]:checked`)
  n.prop("checked", false)
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
