$(document).ready(function() {

    $(".container").show()

    window.addEventListener('message', function(event) {
        var data = event.data;

        if (data.action == "update") {
            $("#current-time").html(data.time.hour + ':' + data.time.minute + ' ' + data.time.ampm);
            $("#current-location").html(data.street1 + " | " + data.area + " | " + data.heading);
            $("#current-speed").html(data.speed);
            $("#current-speed-label").html(" kmh");
            $("#current-fuel").html((data.fuel).toFixed(0));
            $("#current-fuel-label").html(" fuel");
            $("#seatbelt-status").html("Seatbelt");
        }

        if (data.action == "seatbelt") {
            if (data.bool == false) {
                $("#seatbelt-status").css({'color': 'red'});
                console.log(data.bool)
            } else {
                $("#seatbelt-status").css({'color': 'green'});
                console.log(data.bool)
            }
        }

        if (data.action == "enableCarHud") {
            $(".container").fadeIn(500);
        }

        if (data.action == "disableCarHud") {
            $(".container").fadeOut(500);
        }
    })
})