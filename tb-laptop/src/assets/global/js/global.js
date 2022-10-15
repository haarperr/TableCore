// GLOBAL jQuery

$("#close-laptop").click(function(){
    $.post('http://tb-laptop/close', JSON.stringify({}));
    return
});


$(".windows-start").hide();
$(".microsoft-edge").hide();

// WINDOWS START
$("#windows-start").click(function(){ 
    $(".windows-start").slideToggle("fast");
});

// MICROSOFT EDGE

$("#microsoft-edge").click(function(){
    $(".microsoft-edge").fadeIn(100);

    dragElement(document.getElementById("microsoft-edge-2"));

        function dragElement(elmnt) {
        var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
        if (document.getElementById("microsoft-edge-current-window")) {
            document.getElementById("microsoft-edge-current-window").onmousedown = dragMouseDown;
        } else {
            elmnt.onmousedown = dragMouseDown;
        }

        function dragMouseDown(e) {
            e = e || window.event;
            e.preventDefault();
            pos3 = e.clientX;
            pos4 = e.clientY;
            document.onmouseup = closeDragElement;
            document.onmousemove = elementDrag;
        }

        function elementDrag(e) {
            e = e || window.event;
            e.preventDefault();
            pos1 = pos3 - e.clientX;
            pos2 = pos4 - e.clientY;
            pos3 = e.clientX;
            pos4 = e.clientY;
            elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
            elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
        }

        function closeDragElement() {
            document.onmouseup = null;
            document.onmousemove = null;
        }
        }


});

$(".edge-close").click(function(){
    $(".microsoft-edge").fadeOut(100);
});
