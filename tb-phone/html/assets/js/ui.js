// UI Show / Hide

$(function () {
    $(".phone").hide();
    function display(bool) {
        if (bool) {
            $(".phone").fadeIn(250);
        } else {
            $(".phone").fadeOut(250);
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }

        if (item.type == "setupBankAccounts") {
            setupBankAccounts(event.data.accounts)
        }
    })

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://tb-phone/exit', JSON.stringify({}));
            return
        }
    };
});

function setupBankAccounts(accounts) {
    $.each(accounts, function (index, account) {
        $(".collapsible").html("");
        setTimeout(function () {
            $(".collapsible").append('<li><div class="collapsible-header"><i class="material-icons">attach_money</i>' + account.name + '</div><div class="collapsible-body"><span><div class="card-panel blue-grey lighten-4"><span>Uw huidige saldo: <span id="account-1" style="color:green;float:right;font-weight:bold;">$ ' + account.balance + '</span></div></span></div></li>');
        }, 1)
    });
}