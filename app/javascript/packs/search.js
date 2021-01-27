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
     clearDatesFilter()
   }
 })

 // Get :checked on load and create badges
 $(".sidebar :checked").each(function(){
   if (this.name === "fields[]") {
     addBadge(this.id, "sections")
   } else if (this.name === "agencies[]") {
     addBadge(this.id, "agencies")
   }
 })
 
 //Add badge for date filters if populated
 if(parseInt($("#starting_year").val()) && parseInt($("#ending_year").val())) {
   startYear = parseInt($("#starting_year").val())
   endYear = parseInt($("#ending_year").val())
   $filterSection = $('#active-date-filter')
   $badge = $("#active-date-range")
   $dates = $("#active-date-range span")
   $dates.text(`${startYear} - ${endYear}`)
   if ($filterSection.is(":hidden") ){
     $filterSection.show();
     $badge.css("display", "inline-block");
   }
 }

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
   // clear date filters
   if($(this).parent()[0].id == "active-date-range"){
     clearDatesFilter()
   }
 });
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

function publicationDateValidation(){
 startYear = parseInt($("#starting_year").val())
 endYear = parseInt($("#ending_year").val())
 if (startYear > endYear) {
   $("#starting_year")[0].setCustomValidity("Starting year should be earlier than the ending year.");
 } else if (startYear < "1994") {
   $("#starting_year")[0].setCustomValidity("Sorry, this tool only contains SORNs starting from 1994. Please enter a later starting year");
 } else {
   $("#starting_year")[0].setCustomValidity('');
   
   // If dates are valid, create badge
   if(startYear && endYear) {
     createDatesFilter(startYear, endYear)
   }
 }
 }

 function createDatesFilter(startYear, endYear){
  console.log(startYear)
  $filterSection = $('#active-date-filter')
  $badge = $("#active-date-range")
  $dates = $("#active-date-range span")
  $dates.text(`${startYear} - ${endYear}`)
  if ($filterSection.is(":hidden") ){
    $filterSection.show();
    $badge.css("display", "inline-block");
  }
 }

 function clearDatesFilter(){
     // clear inputs
     $("#starting_year").val('')
     $("#ending_year").val('')
     // hide badges section
     $badge = $('#active-date-range')
     $filterSection = $(`#active-date-filter`)
     $badge.hide()
     $filterSection.hide()
 }
