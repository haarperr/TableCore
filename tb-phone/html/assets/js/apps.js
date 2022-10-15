$(".phone-bank").hide();

// GENERAL jQUERY

$("#phone-close").click(function() {
    $.post('http://tb-phone/exit', JSON.stringify({}));
    return
});

$(document).ready(function(){
    $('select').formSelect();
    $('.collapsible').collapsible();
})

// BANK jQUERY

$("#bank-app").click(function() {
    $(".phone-screen").hide();
    $(".phone-bank").show();
    $(".bank-add-accounts-inputs").hide();
    $.post('http://tb-phone/getBankAccounts', JSON.stringify({}));
});

$("#phone-bank-back").click(function() {
    $(".phone-bank").hide();
    $(".phone-screen").show();
});

$("#phone-bank-home").click(function() {
    $(".phone-bank").hide();
    $(".phone-screen").show();
});
$("#bank-add-account").click(function(){
    $(".phone-bank-accounts").hide();
    $(".bank-add-accounts-inputs").show();
});

$("#bank-bills").click(function(e){
    $(".phone-bank-accounts").hide();
    $(".bank-bills").show();
})

$("#bank-change-account").click(function(){
    console.log("Account wijzigen")
});
$("#account-1").click(function() {
    console.log("Rekening 1 openen")
});
$("#account-2").click(function() {
    console.log("Rekening 2 openen")
});
$("#bank-add-accounts-cancel").click(function() {
    $(".bank-add-accounts-inputs").hide();
    $(".phone-bank-accounts").show();
});
$("#bank-add-accounts-accept").click(function() {
    console.log("Account aanmaken gelukt");
    $(".bank-add-accounts-inputs").hide();
    $(".phone-bank-accounts").show();
});