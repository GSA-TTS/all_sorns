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
  $("#agency-select-all").on('click', function(){
    agencyCheckboxes.prop("checked", true)
  })
  $("#agency-deselect-all").on('click', function(){
    agencyCheckboxes.prop("checked", false)
  })

  // Validate the publication date input
  $("#starting_year").on("change", publicationDateValidation)
  $("#ending_year").on("change", publicationDateValidation)

  // Listener for checkboxes
  $(".sidebar input:checkbox").on('change', function(){
    if(this.checked) {
      var $html = `<div class="active-filter" id="${this.id}">${this.value}<a href="#" class="remove-badge">[X]</a></div>`
      const parent_id = $(this).parent().parent()[0].id;

      if (parent_id === "sorn-fields") {
        // $("#active-fields").append($html)
        add_badge(this.id, this.value, "fields")
      }
      else if(parent_id === "selected-agencies") {
        // $("#active-agencies").append($html)
        add_badge(this.id, this.value, "agencies")
      }
      
    }else{
      $(`#active-filters #${this.id}`).remove()
    }
  });

  // Sort active filter divs
  // function(div_array, sort_attr, sort_type){

  // });

  // Listener for remove badge link
  $(document).on('click', 'a.remove-badge', function (e) {
    e.preventDefault()
    remove_badge($(this).parent())
    uncheck_filter($(this).parent().attr('id'))
  });

  // remove filter badge
  function remove_badge(div){
    div.remove()
  }

  // uncheck filter
  function uncheck_filter(id){
    console.log(id)
    var n = $(`input:checkbox[id^="${id}"]:checked`)
    n.prop("checked", false)
  }

});

// add filter badge
function add_badge(id, value, section){
  var $html = `<div class="active-filter" id="${id}">${value}<a href="#" class="remove-badge">[X]</a></div>`
  $(`#active-${section}`).append($html)
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