var curdata

$(function () {
    function display(bool) {
        if (bool) {
            $(".container").fadeIn();
        } else {
            $(".container").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        curdata = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
        $('#wallet-value').html("Wallet Value: $ "+event.data.totalvalue.toFixed(0));
        $('#current-value').html("Current ƒ Value: $ "+event.data.curvalue.toFixed(0));
        $('#wallet2').html("Personal Wallet: ƒ "+event.data.amount);
    })

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://tb-cryptowallet/exit', JSON.stringify({}));
            return
        }
    };

    $('.buy-button').click(function(){
        if ($(".amount-buysell").val() != 0) {
            $.post('http://tb-cryptowallet/buy', JSON.stringify({
                amount: $(".amount-buysell").val()
            }));   
        }
    })

    $('.sell-button').click(function(){
        if ($(".amount-buysell").val() != 0) {
            $.post('http://tb-cryptowallet/sell', JSON.stringify({
                amount: $(".amount-buysell").val()
            }));   
        }
    })
})


function changeTotal() {
    var amount = $(".amount-buysell").val()
    var price = curdata.curvalue
    var total = amount * price
    $('#totalamount').html("$ " + total.toFixed(0));
}