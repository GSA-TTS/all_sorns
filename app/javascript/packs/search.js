
$( function () {
  // Set checked fields from url
  checkboxesFromUrl("fields")

  // Set checked agencies from url
  checkboxesFromUrl("agencies")

  // Add .agency-separator to agency pipe separator
  $(".agency-names").html(function(_, html){
    return html.replace("|","<span class='agency-separator'>|</span>")
  });

  // Select all and deselect all buttons
  const agencyCheckboxes = $("#agencies input:checkbox")
  const fieldCheckboxes = $("#sorn-fields input:checkbox")
  $("#agency-select-all").on('click', function(){
    agencyCheckboxes.prop("checked", true)
  })
  $("#agency-deselect-all").on('click', function(){
    agencyCheckboxes.prop("checked", false)
    clear_badges('agencies')
  })
  $("#fields-deselect-all").on('click', function(){
    fieldCheckboxes.prop("checked", false)
    clear_badges('fields')
  })

  // Validate the publication date input
  $("#starting_year").on("change", publicationDateValidation)
  $("#ending_year").on("change", publicationDateValidation)

  // Listener for checkboxes
  $(".sidebar input:checkbox").on('change', function(){
    if(this.checked) {
      const parent_id = $(this).parent().parent()[0].id;

      if (parent_id === "sorn-fields") {
        add_badge(this.id, this.value, "fields")
      }
      else if(parent_id === "selected-agencies") {
        add_badge(this.id, this.value, "agencies")
      }
      
    }else{
      // add '-badge' to id to remove
      $(`#active-filters #${this.id}-badge`).remove()
    }
  });

  // Listener for remove badge link
  $(document).on('click', 'a.remove-badge', function (e) {
    e.preventDefault()
    remove_badge($(this).parent())
    
    // strip '-badge' from id before calling
    uncheck_filter($(this).parent().attr('id').replace('-badge',''))
  });

  // remove filter badge
  function remove_badge(div){
    div.remove()
  };

  function clear_badges(section){
    $(`#active-${section}`).empty()
  };

  // uncheck filter
  function uncheck_filter(id){
    var n = $(`input:checkbox[id^="${id}"]:checked`)
    n.prop("checked", false)
  }

});

// add filter badge and sort elements
function add_badge(id, value, section){
  var $container = $(`#active-${section}`)

  // add '-badge' to ids for active filters
  var $new_badge = `<div class="active-filter" id="${id}-badge">${value}<a href="#" class="remove-badge">[X]</a></div>`

  $container.append($new_badge)

  var $filters = $container.find('.active-filter').clone().get()

  var $sorted = $filters.sort(function(a, b) {
    if (a.textContent < b.textContent) {
      return -1;
    } else {
      return 1;
    }
  });

  $(`#active-${section}`).html($sorted) 
};

function checkboxesFromUrl(elementName) {
  checkboxes = $(`#${elementName} input:checkbox`)
  dataFromurl = $(`#${elementName}-for-js`).data(elementName)
  if (dataFromurl) {
    // uncheck all
    checkboxes.prop("checked", false)
    // check those found in url
    dataFromurl.forEach(data => {
      $(`#${elementName}-${data}`).prop("checked", true)
      add_badge(`${elementName}-${data}`,data,elementName)
    });
  }
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