$(function() {
    $(".firefox-browser").hide();
    $(".system-actions").hide();
    $(".hornbach-browser").hide();
    $(".ah-browser").hide();
    $(".postnl-browser").hide();
    $(".email-browser").show();

    // FIREFOX

    $("#firefox-button").click(function() {
        $(".firefox-browser").hide(0);
        $(".firefox-browser").fadeIn(100);
        $(".system-actions").hide();
        $(".hornbach-browser").hide();
        $(".ah-browser").hide();
        $(".postnl-browser").hide();
        $(".email-browser").hide();
        dragElement(document.getElementById("firefox-browser"));

        function dragElement(elmnt) {
        var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
        if (document.getElementById("firefox-header")) {
            document.getElementById("firefox-header").onmousedown = dragMouseDown;
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
    $("#close-firefox").click(function() {
        $(".firefox-browser").fadeOut(100);
    });
    $("#close-firefox-2").click(function() {
        $(".firefox-browser").fadeOut(100);
    });
    $("#system-actions-trigger").click(function() {
        $(".system-actions").fadeIn();
    });
    $("#close-actions-menu").click(function() {
        $(".system-actions").fadeOut();
    });

    // HORNBACH

    $("#hornbach-trigger").click(function() {
        $(".hornbach-browser").show();
        $(".firefox-browser").hide();
        $(".postnl-browser").hide();
        dragElement(document.getElementById("hornbach-browser"));

        function dragElement(elmnt) {
        var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
        if (document.getElementById("hornbach-browser")) {
            document.getElementById("hornbach-browser").onmousedown = dragMouseDown;
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
    $("#hornbach-info-close").click(function() {
        $(".hornbach-info").hide();
    });
    $("#hornbach-close").click(function() {
        $(".hornbach-browser").fadeOut(100);
    });
    $("#close-hornbach-2").click(function() {
        $(".hornbach-browser").fadeOut(100);
    });
    $("#last-page").click(function() {
        $(".firefox-browser").show();
        $(".system-actions").hide();
        $(".hornbach-browser").hide();
        $(".ah-browser").hide();
        $(".postnl-browser").hide();
        $(".email-browser").hide();
    });
    $("#ah-last-page").click(function(){
        $(".firefox-browser").show();
        $(".system-actions").hide();
        $(".hornbach-browser").hide();
        $(".ah-browser").hide();
        $(".postnl-browser").hide();
        $(".email-browser").hide();
    });
    $("#postnl-last-page").click(function(){
        $(".firefox-browser").show();
        $(".system-actions").hide();
        $(".hornbach-browser").hide();
        $(".ah-browser").hide();
        $(".postnl-browser").hide();
        $(".email-browser").hide();
    });
    $("#email-last-page").click(function(){
        $(".firefox-browser").show();
        $(".system-actions").hide();
        $(".hornbach-browser").hide();
        $(".ah-browser").hide();
        $(".postnl-browser").hide();
        $(".email-browser").hide();
    });
    $("#firefox-refresh").click(function() {
        $(".firefox-browser").fadeOut(50);
        $(".firefox-browser").fadeIn(50);
    });
    
    $("#hornbach-refresh").click(function() {
        $(".hornbach-browser").fadeOut(50);
        $(".hornbach-browser").fadeIn(50);
    });
    $("#ah-refresh").click(function() {
        $(".ah-browser").fadeOut(50);
        $(".ah-browser").fadeIn(50);
    });
    $("#postnl-refresh").click(function() {
        $(".postnl-browser").fadeOut(50);
        $(".postnl-browser").fadeIn(50);
    });
    $("#email-refresh").click(function() {
        $(".email-browser").fadeOut(50);
        $(".email-browser").fadeIn(50);
    });

    // CLOSE COMPLETE UI

    $("#close").click(function () {
        $.post('http://tb-internet/exit', JSON.stringify({}));
        return
    });

    // HORNBACH ORDERS

    $("#hornbach-1-order").click(function() {
        $.post('http://tb-internet/order', JSON.stringify({
            item: "WEAPON_CROWBAR",
            price: 500.50,
            amount: 1
        }));
    });
    $("#hornbach-2-order").click(function() {
        $.post('http://tb-internet/order', JSON.stringify({
            item: "WEAPON_PIPEWRENCH",
            price: 250.00,
            amount: 1
        }))
    });

    // ALBERT HEIJN

    $("#ah-trigger").click(function() {
        $(".ah-browser").show();
        $(".firefox-browser").hide();
        dragElement(document.getElementById("ah-browser"));

        function dragElement(elmnt) {
        var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
        if (document.getElementById("ah-browser")) {
            document.getElementById("ah-browser").onmousedown = dragMouseDown;
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
    $("#close-ah").click(function() {
        $(".ah-browser").fadeOut(100);
    });
    $("#close-ah-2").click(function() {
        $(".ah-browser").fadeOut(100);
    });
    $("#ah-cookies-accepted").click(function() {
        $(".ah-cookies").hide();
    });

    // AH ORDERS

    $("#ah-order-1").click(function() {
        $.post("http://tb-internet/order", JSON.stringify({
            item: "bread",
            price: 25.00,
            amount: 1
        }));
    });
    $("#ah-order-2").click(function() {
        $.post("http://tb-internet/order", JSON.stringify({
            item: "burger",
            price: 40.00,
            amount: 1
        }));
    });
    $("#ah-order-3").click(function() {
        $.post("http://tb-internet/order", JSON.stringify({
            item: "water",
            price: 25.00,
            amount: 1
        }));
    });

    // POSTNL 

    $("#postnl-trigger").click(function() {
        $(".postnl-browser").show();
        $(".firefox-browser").hide();
        dragElement(document.getElementById("postnl-browser"));

        function dragElement(elmnt) {
        var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
        if (document.getElementById("postnl-browser")) {
            document.getElementById("postnl-browser").onmousedown = dragMouseDown;
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
    $("#close-postnl").click(function() {
        $(".postnl-browser").fadeOut(100);
    });
    $("#close-postnl-2").click(function() {
        $(".postnl-browser").fadeOut(100);
    });

    // EMAIL

    $("#email-trigger").click(function() {
        $(".email-browser").show();
        $(".firefox-browser").hide();
        dragElement(document.getElementById("email-browser"));

        function dragElement(elmnt) {
        var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
        if (document.getElementById("email-browser")) {
            document.getElementById("email-browser").onmousedown = dragMouseDown;
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
    $("#close-email").click(function() {
        $(".email-browser").fadeOut(100);
    });
    $("#close-email-2").click(function() {
        $(".email-browser").fadeOut(100);
    });

});

// DATE SPAN

var d = new Date();
var weekday = new Array(7);
weekday[0] =  "Zondag";
weekday[1] = "Maandag";
weekday[2] = "Dinsdag";
weekday[3] = "Woensdag";
weekday[4] = "Donderdag";
weekday[5] = "Vrijdag";
weekday[6] = "Zaterdag";

var n = weekday[d.getDay()];

var today = new Date();
var time = today.getHours() + ":" + today.getMinutes()
$("#current-time").html(time);
$("#current-day").html(n);