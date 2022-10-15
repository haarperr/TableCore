$(document).ready(function() {
    $(".container").hide();

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.action === "garage") {
            if (item.open == true) {
                $(".container").fadeIn(250);
            } else {
                $(".container").fadeOut(250);
            }
        }

        if (item.action == "setupPlayerVehicles") {
            setupPlayerVehicles(item.vehicles)
        }

        document.onkeyup = function (data) {
            if (data.which == 27 ) {
                $.post('http://tb-garage/exit', JSON.stringify({}));
                return
            }
        };
    });
});

function setupPlayerVehicles(vehicles) {
    $(".block").html("");
    $.each(vehicles, function(index, vehicle){
        $(".block").append('<div class="car"><span id="label">' + vehicle.name + '</span><span id="car-stats"><span id="fuel"><strong>Fuel</strong>: ' + vehicle.fuel + '%  | </span><span id="body-hp"><strong>Body HP</strong>: ' + vehicle.bodyhp + '%  | </span><span id="engine-hp"><strong>Engine HP</strong>: ' + vehicle.enginehp + '%</span></span><div class="take-out"><p>Pak</p></div></div>');
    })
}