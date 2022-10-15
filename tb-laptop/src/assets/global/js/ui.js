$('document').ready(function () {
    $(".laptop-ui").hide();

    function display(bool) {
        if (bool) {
            $(".laptop-ui").fadeIn(250);
        } else {
            $(".laptop-ui").fadeOut(250);
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
                console.log('open nu!')
            } else {
                display(false)
            }
        }
    })

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://tb-laptop/exit', JSON.stringify({}));
            return
        }
    };
});
