$(document).ready(function() {

    $(".container").hide()

    window.addEventListener('message', function(event) {
        var data = event.data;
        
        if(event.data.action == "show"){
            $(".container").fadeIn()
        }

        $("#boxHeal").css("width",data.health + "%");
        $("#boxArmor").css("width",data.armor + "%");
        $("#boxHunger").css("width",(data.hunger / 1000) + "%");
        $("#boxThirst").css("width",(data.thirst / 1000) + "%");
        if (event.data.action == "updateStatus") {
            updateStatus(event.data.st);
        }
    })
})