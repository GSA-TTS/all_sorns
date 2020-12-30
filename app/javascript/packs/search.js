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

  // Listener for fields checkboxes
  $("#fields input:checkbox").on('change', function(){
    if(this.checked) {
      console.log(`${this.id} checked`) // DEBUG
      html = `<div class="active-filter" id="${this.id}-badge">${this.value}<a href="#" class="remove-badge">[X]</a></div>`
      $("#active-fields").append(html)
    }else{
      console.log(`${this.id} unchecked`)
      $(`#${this.id}-badge`).remove()
    }
  });
  
  // Listener for agency checkboxes
  $("#agencies input:checkbox").on('change', function(){
    if(this.checked) {
      console.log(`${this.id} checked`) // DEBUG
      html = `<div class="active-filter" id="${this.id}-badge">${this.value}<a href="#" class="remove-badge">[X]</a></div>`
      $("#active-agencies").append(html)
    }else{
      console.log(`${this.id} unchecked`)
      $(`#${this.id}-badge`).remove()
    }
  });

  // Remove badges and uncheck filters
  $(document).on('click', 'a.remove-badge', function (e) {
    e.preventDefault()
    $(this).parent().remove()
  });

});

function checkboxesFromUrl(elementName) {
  checkboxes = $(`#${elementName} input:checkbox`)
  dataFromurl = $(`#${elementName}-for-js`).data(elementName)
  if (dataFromurl) {
    // uncheck all
    checkboxes.prop("checked", false)
    // check those found in url
    dataFromurl.forEach(data => {
      $(`#${elementName}-${data}`).prop("checked", true)
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