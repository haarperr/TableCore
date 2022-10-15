var visable = false;

$(document).ready(function() {

    window.addEventListener('message', function(event) {
        var data = event.data;
        if (event.data.action == "toggle"){
            if (visable) {
                $('.container').fadeOut();
            } else {
                $('.container').fadeIn();
            }
            visable = !visable;
        }

        if (event.data.action == "show"){
            $('.container').fadeIn();
            visable = true;
        }

        if (event.data.action == "hide"){
            $('.container').fadeOut();
            visable = false;
        }

        if (event.data.action == "setValue"){
            setValue(data.key, data.value)
        }

        if (event.data.action == "addcash") {
            var element = $("<div class='cashchange'><font style='color: rgb(255, 255, 255); font-weight: 700;hasrfa margin-right: 6px;'>+ <span id='dollar-plus'>$  </span>" + data.value + "</font></div>");
            $("#cashchange").append(element);
            setTimeout(function () {
                $(element).fadeOut(1000, function () { $(this).remove(); });
            }, 1000);
        }

        if (event.data.action == "removecash") {
            var element = $("<div class='cashchange'><font style='color: rgb(255, 255, 255); font-weight: 700;hasrfa margin-right: 6px;'>- <span id='dollar-min'>$  </span>" + data.value + "</font></div>");
            $("#cashchange").append(element);
            setTimeout(function () {
                $(element).fadeOut(1000, function () { $(this).remove(); });
            }, 1000);
        }

        if (event.data.action == "updateValue"){
            updateValue(data.key, data.value)
        }
    })
})

function setValue(key, value){
	$('#'+key).html("<span id='dollar'>$  </span>" + value)
}

function updateValue(key, value){
	$('#'+key).html("<span id='dollar'>$  </span>" + value)
}