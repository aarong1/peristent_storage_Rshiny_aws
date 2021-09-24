// When locator icon in datatable is clicked, go to that spot on the map
$(document).on("click", ".go-map", function(e) {
  e.preventDefault();
  $el = $(this);
  var lat = $el.data("lat");
  var lng = $el.data("lng");
  var where=$el.data("where");
  //var zip = $el.data("zip");
  $($("#nav a")[0]).tab("show");
  Shiny.onInputChange("goto", {
    lat: lat,
    lng: lng,
    where: where,
    
    //zip: zip,
    nonce: Math.random()
  });
});
