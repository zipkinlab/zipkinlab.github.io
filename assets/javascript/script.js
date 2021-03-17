// Navigation 1.0 ALPHA
//
// * Highlights the appropriate element in the navigation when scrolling through the page
// * Scrolls to appropriate section of the page when the navigation is clicked

var sections = [];
var articleSections = $();
var autoscrolling = false;

$(document).ready(function(){

  $("nav").on("click","a",function(){
    $(".selected").removeClass("selected");
    $(this).addClass("selected");
    var section = $(this).attr("href");

    autoscrolling = true;

    $('html, body').animate({
        scrollTop: $(section).offset().top
    }, 500, function(){
      autoscrolling = false;
      window.location.hash = section;
    });

    return false;
  });

  $("nav a").each(function(i,el){
    var sectionName = $(el).attr("href");
    if(sectionName.length > 0) {
      sectionName = sectionName.replace("#","").toLowerCase();
      sections.push(sectionName);
    }
  });

  var jam = $("article *[id]");
  $(jam).each(function(i,el){
    var id = $(el).attr("id");
    id = id.replace("#","").toLowerCase();
    if(sections.indexOf(id) > -1) {
      articleSections.push(el);
    }
  });

  $(window).on("scroll",function(){
    if(autoscrolling == false) {
      scroll();
    }
  });

// Get the image and insert it inside the modal - use its "alt" text as a caption
//var img = document.getElementsByClassName(".modal-img");
//var modals = document.getElementsByClassName(".modal");
//var modimg = document.getElementsByClassName(".modal-content");
//var modcaption = document.getElementsByClassName(".modal-caption");
//var spans = document.getElementsByClassName(".close")[0];
  
var img = document.querySelectorAll(".modal-img");
var modals = document.querySelectorAll(".modal");
var modimg = document.querySelectorAll(".modal-content");
var modcaption = document.querySelectorAll(".modal-caption");
var spans = document.querySelectorAll(".close");

for (var i = 0; i < img.length; i++) {
  img[i].onclick = funcion(e) {
    e.preventDefault();
    modal = document.querySelector(e.target.getAttribute("alt"));
    modal.style.display = "block";
    modimg.src = this.src;
    modcaption.innerHTML = this.alt;
  }
}
  
//img.onclick = function() {
//  modals.style.display = "block";
//  modimg.src = this.src;
//  modcaption.innerHTML = this.alt;
//}
  
for (var i = 0; i < spans.length; i++) {
 spans[i].onclick = function() {
    for (var index in modals) {
      if (typeof modals[index].style !== 'undefined') modals[index].style.display = "none";    
    }
 }
}
  
window.onclick = function(event) {
    if (event.target.classList.contains('modal')) {
     for (var index in modals) {
      if (typeof modals[index].style !== 'undefined') modals[index].style.display = "none";    
     }
    }
}
  
});

function scroll(){
  articleSections.each(function(i,el){
    var windowTop = $(window).scrollTop();
    var offset = $(el).offset();
    var fromTop = offset.top - windowTop;
    if(fromTop > 0 && fromTop < 400) {
      var id = $(el).attr('id');
      id = id.toLowerCase().replace("#","");
      $("nav .selected").removeClass("selected");
      $("nav a[href=#"+id+"]").addClass("selected");
    }
  });
}
