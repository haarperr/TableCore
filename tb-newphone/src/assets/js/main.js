var currentApp = null;
var previousPage = null;
var notificationClosed = false;

$('document').ready(function(){

    $('.collapsible').collapsible();

    window.addEventListener('message', function(event) {
        var item = event.data;

        if (item.type == "phone") {
            if (item.toggle) {
                $('.phone').fadeIn(250);
            } else {
                $('.phone').fadeOut(250);
            }
        }

        if (item.type == "setupPlayerContacts") {
            setupPlayerContacts(event.data.contacts)
        }

        if (item.type == "setupBankAccounts") {
            setupBankAccounts(event.data.accounts, event.data.totalbalance)
        }

        if (item.type == "updateTime") {
            $('#current-time').html(item.time.hour + ':' + item.time.minute + ' ' + item.time.ampm)
        }
    });

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://tb-newphone/exit', JSON.stringify({}));
            return
        }
    };
});

function setupBankAccounts(accounts, totalbalance) {
    $.each(accounts, function (index, account) {
        $(".app-bank-accounts").html("");
        setTimeout(function () {
            $(".app-bank-accounts").append('<div class="account"><span id="bank-name">' + account.name + '</span><br><span id="bank-type">' + account.type + '</span><br><span id="bank-banknumber">' + account.banknumber + '</span><br><i class="fas fa-piggy-bank" id="account-icon"></i><span id="bank-balance">€ ' + (account.balance).toFixed(2) + '</span><br></div>');
        }, 1)
    });
    setTimeout(function () {
        $(".app-bank-accounts").append('<div class="app-bank-total-balance"><p>Totaalsaldo</p><i class="material-icons">info</i><span id="total-accounts-balance">€ 0</span></div>');
        $('#total-accounts-balance').html("€ " + (totalbalance).toFixed(2));
    }, 2)
}

$(document).on('click', '#contact-call', function(e) {
    e.preventDefault();
    var parentId = $(this).parent().attr("id");
    var cData = $('#'+parentId).data("cData");
    phoneNotify("Oproep", "Contact Gegevens: </br> Contact: " + cData.name + ". </br> Tel: "+cData.number+"");
});

$('#phone-close').click(function(e){
    e.preventDefault();
    $.post('http://tb-newphone/exit', JSON.stringify({}));
    return
})

$('#information').click(function(e){
    e.preventDefault();
    $('.phone-screen').css("display", "none");
    $('.app-information').css("display", "block");
    currentApp = $('.app-information');
    previousPage = $('.phone-screen');
});

$('#bank').click(function(e){
    e.preventDefault();
    $.post('http://tb-newphone/getBankAccounts', JSON.stringify({}));
    $('.phone-screen').css("display", "none");
    $('.app-bank').css("display", "block");
    currentApp = $('.app-bank');
    previousPage = $('.phone-screen');
});

$(".bank-transfer").click(function(e){
    e.preventDefault();
    $('.app-bank').css("display", "none");
    $('.app-bank-transfer').css("display", "block");
    currentApp = $('.app-bank-transfer');
    previousPage = $('.app-bank');
})

$('#contacts').click(function(e){
    e.preventDefault();
    $.post('http://tb-newphone/getPlayerContacts', JSON.stringify({}));
    $('.phone-screen').css("display", "none");
    $('.app-contacts').css("display", "block");
    currentApp = $('.app-contacts');
    previousPage = $('.phone-screen');
});

$('#phone-home').click(function(e){
    e.preventDefault();
    if (currentApp !== null) {
        $(currentApp).css("display", "none");
        $('.phone-screen').css("display", "block");
    }
});

$('#bank-add-account').click(function(e){
    e.preventDefault();
    phoneNotify("Maze Bank", "Er is zojuist $500 op uw betaalrekening bijgeschreven.")

    console.log('yeet')
});

$('#add-contact-page-button').click(function(e){
    e.preventDefault();
    $('.add-contact-page').fadeIn(250);
})

$('#contact-save').click(function(e){
    e.preventDefault();
    var contactname = $('.add-contact-name').val();
    var contactnr = $('.add-contact-nr').val();

    if (contactname !== "" && contactnr !== "") {
        if (isNaN(contactnr)) {
            phoneNotify("Error", "Een tel nr. bestaat uit cijfers")
        } else {
            console.log('Naam : ' + contactname + ' Tel nr. : ' + contactnr)
            $.post('http://tb-newphone/addContact', JSON.stringify({
                name: contactname,
                nr: contactnr
            }))
            $('.add-contact-page').fadeOut(250);
        }
    } else {
        phoneNotify("Error", "U heeft geen naam of tel nr. opgegeven")
    }
})

$('#contact-cancel').click(function(e){
    e.preventDefault();
    $('.add-contact-page').fadeOut(250);
})

$('#phone-back').click(function(e){
    e.preventDefault();
    if (previousPage !== null) {
        $(currentApp).css("display", "none");
        $(previousPage).css("display", "block");
        currentApp = previousPage;
        previousPage = null;
    } else {
        if (currentApp !== null || $('.phone-screen').css("display") !== "block") {
            $(currentApp).css("display", "none");
            $('.phone-screen').css("display", "block");
            console.log('yalla terug')
        }
    }
});

function setupPlayerContacts(contacts) {
    $.each(contacts, function(index, contact){
        $('.player-contacts').html("");
        setTimeout(function() {
            $('.player-contacts').append('<div class="contact" id="cData-'+index+'"><div class="first-letter" style="background-color: rgb(' + contact.color.r + ', ' + contact.color.g + ', ' + contact.color.b + ');">' + (contact.name).charAt(0).toUpperCase() + '</div><span id="name">' + contact.name + '</span><i class="material-icons waves-effect" id="contact-call">call</i><i class="material-icons" id="contact-sms">textsms</i><i class="material-icons" id="contact-edit">edit</i></div>');
            $('#cData-'+index).data("cData", contact);
        }, 100)
    })
}


$('#phone-notification-close').click(function(e){
    e.preventDefault();
    $('.phone-notification').fadeOut(100);
    notificationClosed = true;
})

function phoneNotify(titel, text) {
    notificationClosed = false;
    $('#phone-notification-titel').html(titel);
    $('#phone-notification-content').html(text)
    $('.phone-notification').fadeIn(250);
    setTimeout(function () {
        if (!notificationClosed) {
            $('.phone-notification').fadeOut(250);
        }
    }, 3500)
}