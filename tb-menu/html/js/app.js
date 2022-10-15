var menus = new Array();
var menuData = new Array();
var activeMenu = new Array();
var activeRoot = 0;
var isMenuOpen = false;
var calling_resource = null;

window.addEventListener("message", function (event) {
    if (event.data.action == "display") {
        isMenuOpen = false;

        calling_resource = event.data.resource;
        menuData = event.data.data;

        let menuElement = $('.templates .menu').clone();
        $('.menus').append($(menuElement));
        menus.push($(menuElement));

        setupItems(menuData[0]);
        activeMenu.push(1);

        if (menuData[0].closeCb != null) {
            $(menus[(menus.length - 1)]).data('close', menuData[0].closeCb);
        }

        SetActiveRoot(activeRoot);
        
        $(menus[(menus.length - 1)]).show();
    } else if (event.data.action == "destroyMenus") {
        $('.menus').html('');

        menus = new Array();
        menuData = new Array();
        activeMenu = new Array();
        calling_resource = null;
    } else if (event.data.action == "refreshCurrentMenu") {
        $(menus[(menus.length - 1)]).find('menu-container').html('');
        setupItems(event.data.data);
    }
});

/*$(document).ready(function() {
    let menuElement = $('.templates .menu').clone();
    $('.menus').append($(menuElement));
    menus.push($(menuElement));

    let things = []
    for(let i = 1; i <= 50; i++) {
        let buttons = []
        for (let j = 0; j < 25; j++) {
            switch (i) {
                case 1:
                    buttons.push({
                        type: 1,
                        label: 'Type 1',
                        data: "LOL"
                    });
                    break;
                case 2:
                    buttons.push({
                        type: 2,
                        label: 'Type 2',
                        max: Math.ceil(Math.random() * 100),
                        data: "LOL"
                    });
                    break;
                case 4:
                    buttons.push({
                        type: 4,
                        label: 'Type 4',
                        right: '$500',
                        data: "LOL"
                    });
                    break;
                case 5:
                    buttons.push({
                        type: 5,
                        label: 'Type 5',
                        activate: false,
                        data: "LOL"
                    });
                    break;
            }
        }

        things.push({
            type: 0,
            label: 'Type ' + i,
            data: {
                title: "CUNT",
                subtitle: "Ayyyyye",
                buttons: buttons
            }
        });

    }

    let stuff = {
        title: "Title YAY",
        subtitle: "Sub Title WOOT",
        buttons: things
    }
    setupItems(stuff);
    $(menus[(menus.length - 1)]).show();
});*/

$("body").on("keyup", function (event) {
    event.preventDefault();
    if (event.keyCode === 13) {
        if (isMenuOpen) {
            SelectItem();
        }
    } else if (event.keyCode === 8) {
        if (isMenuOpen) {
            GoBack();
        }
    } else if (event.keyCode === 27) {
        if (isMenuOpen) {
            CloseUI();
        }
    }
});

$("body").on("keydown", function(event) {
    if (event.keyCode === 32) {
        event.preventDefault();
    } else if (event.keyCode === 37) {
        event.preventDefault();
        if (isMenuOpen) {
            setInterval(DoLeftAction(), 1000);
        }
    } else if (event.keyCode === 39) {
        event.preventDefault();
        if (isMenuOpen) {
            setInterval(DoRightAction(), 1000);
        }
    } else if(event.keyCode === 40) {
        event.preventDefault();
        if (isMenuOpen) {
            setInterval(MoveDown(), 1000);
        }
    } else if (event.keyCode === 38) {
        event.preventDefault();
        if (isMenuOpen) {
            setInterval(MoveUp(), 1000);
        }
    }
});

function setupItems(items) {
    $(menus[(menus.length - 1)]).find('.menu-container').html('');
    $(menus[(menus.length - 1)]).find('.menu-header').html(items.title);
    $(menus[(menus.length - 1)]).find('.menu-sub-header .sub-title').html(items.subtitle);
    $(menus[(menus.length - 1)]).find('.menu-sub-header .max-index').html(items.buttons.length);
    $(menus[(menus.length - 1)]).find('.menu-sub-header .current-index').html(1);

    if (items.optionCb != null) {
        $(menus[(menus.length - 1)]).data('optionChange', items.optionCb);
    }

    if (items.closeCb != null) {
        $(menus[(menus.length - 1)]).data('close', items.closeCb);
    }

    $.each(items.buttons, function(index, item) {
        let element = null;

        switch(item.type) {
            // Slider
            case 2:
                element = $('.templates .slider.template').clone();
                $(element).find('.left').html(item.label);
                $(element).find('.max-index').html(item.max);
                $(element).find('input').attr('max', (item.max));
                break;
            // Progress Bar
            case 3:
                element = $('.templates .standard.template').clone();
                $(element).html(item.label);
                break;
            // Submenu
            case 4:
                element = $('.templates .advanced.template').clone();
                $(element).find('.left').html(item.label);
                if (item.right != null) {
                    $(element).find('.right').html(item.right);
                }
                break;
            case 5:
                    element = $('.templates .check.template').clone();
                    $(element).find('.left').html(item.label);
                    if (!item.active) {
                        $(element).find('.right').html('');
                    } else {
                        $(element).find('.right').html('<i class="fas fa-check-circle"></i>');
                    }
                    break;
            case 6:
                element = $('.templates .advanced.template').clone();
                $(element).find('.left').html(item.label);
                if (item.right != null) {
                    $(element).find('.right').html(item.right);
                }
                break;
            case 0:
            // Standard Button
            case 1:
            case -1:
            default:
                element = $('.templates .standard.template').clone();
                $(element).html(item.label);
                break;
        }

        $(menus[(menus.length - 1)]).find('.menu-container').append(element);
        $(element).data('type', item.type);

        if (item.data != null) {
            if (item.type == 0) {
                $(element).data('data', menuData[(item.data.index - 1)]);
                $(element).data('menuId', item.data.index);
            } else {
                $(element).data('data', item.data);
            }
        }

        if (item.select != null) {
            $(element).data('select', item.select);
        }

        if (item.slideChange != null) {
            $(element).data('slideChange', item.slideChange);
        }

        if (item.disabled) {
            $(element).addClass('disabled');
        }

        $(element).addClass('menu-button');
        $(element).attr('tabindex', (index + 1));

        if (index === 0) { $(element).addClass('active'); }

        $(element).removeClass('template');
    });

    $(menus[(menus.length - 1)]).find('.menu-button.active').focus();
    $(menus[(menus.length - 1)]).find('.menu-container').animate({ scrollTop: 0 }, "fast");

    isMenuOpen = true;
}

function MoveUp() {
    $.post('http://tb-menu/MenuUpDown', JSON.stringify({}));

    if ($(menus[(menus.length - 1)]).find(".menu-button").not('.disabled').length < 1) { return; }

    let curActive = $(menus[(menus.length - 1)]).find(".menu-button.active");
    let newActive = $(menus[(menus.length - 1)]).find(".menu-button.active").prev('.menu-button');


    let optionChangeCb = $(menus[(menus.length - 1)]).data('optionChange');

    if (newActive.length > 0) {
        $(newActive).addClass('active');
        $(curActive).removeClass('active');

        let currIndex = +$(menus[(menus.length - 1)]).find('.menu-sub-header .current-index').html();
        $(menus[(menus.length - 1)]).find('.menu-sub-header .current-index').html(currIndex - 1);

        if ($(newActive).data('type') == 2) {
            $(newActive).find('input').focus();
        } else {
            $(newActive).focus();
        }
    } else {
        newActive = $(menus[(menus.length - 1)]).find('.menu-button:last-child');

        $(menus[(menus.length - 1)]).find('.menu-sub-header .current-index').html(+$(menus[(menus.length - 1)]).find('.menu-sub-header .max-index').html());

        $(newActive).addClass('active');
        $(curActive).removeClass('active');

        if ($(newActive).data('type') == 2) {
            $(newActive).find('input').focus();
        } else {
            $(newActive).focus();
        }
    }

    if ((menus.length - 1) === 0) {
        activeRoot -= 1;
    }

    if (optionChangeCb != null) {
        let data = $(newActive).data('data');

        $.post('http://tb-menu/MenuOptionChange', JSON.stringify({
            data: data,
            resource: calling_resource,
            callback: optionChangeCb
        }));
    }
}

function MoveDown() {
    $.post('http://tb-menu/MenuUpDown', JSON.stringify({}));
    if ($(menus[(menus.length - 1)]).find(".menu-button").not('.disabled').length < 1) { return; }

    let curActive = $(menus[(menus.length - 1)]).find(".menu-button.active");
    let newActive = $(menus[(menus.length - 1)]).find(".menu-button.active").next('.menu-button');
    
    let optionChangeCb = $(menus[(menus.length - 1)]).data('optionChange');

    if (newActive.length > 0) {
        $(newActive).addClass('active');
        $(curActive).removeClass('active');

        let currIndex = +$(menus[(menus.length - 1)]).find('.menu-sub-header .current-index').html();
        $(menus[(menus.length - 1)]).find('.menu-sub-header .current-index').html(currIndex + 1);

        if ($(newActive).data('type') == 2) {
            $(newActive).find('input').focus();
        } else {
            $(newActive).focus();
        }
    } else {
        newActive = $(menus[(menus.length - 1)]).find('.menu-button:first-child');

        $(menus[(menus.length - 1)]).find('.menu-sub-header .current-index').html(1);
        $(newActive).addClass('active');
        $(curActive).removeClass('active');

        if ($(newActive).data('type') == 2) {
            $(newActive).find('input').focus();
        } else {
            $(newActive).focus();
        }
    }

    if ((menus.length - 1) === 0) {
        activeRoot += 1;
    }

    if (optionChangeCb != null) {
        let data = $(newActive).data('data');

        $.post('http://tb-menu/MenuOptionChange', JSON.stringify({
            data: data,
            resource: calling_resource,
            callback: optionChangeCb
        }));
    }
}

function DoLeftAction() {
    let curActive = $(menus[(menus.length - 1)]).find(".menu-button.active");

    if ($(curActive).hasClass('slider')) {
        let value = $(curActive).find('input').val();
        let data = $(curActive).data('data');
        let valChangeCb = $(curActive).data('slideChange');

        if (value === "1") {
            $(curActive).find('input').val($(curActive).find('input').attr('max'));
            $.post('http://tb-menu/MenuSlideChange', JSON.stringify({}));
            $(curActive).find('.curr-index').html($(curActive).find('input').val());
        } else {
            $(curActive).find('input').val(value - 1);
            $.post('http://tb-menu/MenuSlideChange', JSON.stringify({}));
            $(curActive).find('.curr-index').html($(curActive).find('input').val());
        }

        $.post('http://tb-menu/SlideValueChange', JSON.stringify({
            data: data,
            index: +$(curActive).find('input').val(),
            resource: calling_resource,
            callback: valChangeCb
        }));
    }
}

function DoRightAction() {
    let curActive = $(menus[(menus.length - 1)]).find(".menu-button.active");

    if ($(curActive).hasClass('slider')) {
        let value = $(curActive).find('input').val();
        let data = $(curActive).data('data');
        let valChangeCb = $(curActive).data('slideChange');

        if (value === $(curActive).find('input').attr('max')) {
            $(curActive).find('input').val(1);
            $.post('http://tb-menu/MenuSlideChange', JSON.stringify({}));
            $(curActive).find('.curr-index').html($(curActive).find('input').val());
        } else {
            $(curActive).find('input').val(+value + 1);
            $.post('http://tb-menu/MenuSlideChange', JSON.stringify({}));
            $(curActive).find('.curr-index').html($(curActive).find('input').val());
        }

        $.post('http://tb-menu/SlideValueChange', JSON.stringify({
            data: data,
            index: +$(curActive).find('input').val(),
            resource: calling_resource,
            callback: valChangeCb
        }));
    }
}

function SelectItem() {
    let active = $(menus[(menus.length - 1)]).find(".menu-button.active");

    if ($(active).hasClass('disabled')) {
        $.post('http://tb-menu/MenuSelectDisabled', JSON.stringify({}));
        return
    } else {
        $.post('http://tb-menu/MenuSelect', JSON.stringify({}));
    }

    let type = $(active).data('type');
    let selectCb = $(active).data('select');
    let data = $(active).data('data');
    
    if (type === -1) {
        GoBack();
    } else if (type === 0) {
        menus.push($('.sub-menu.template').clone());
        $('.menus').append(menus[(menus.length - 1)]);

        if (data.closeCb != null) {
            $(menus[(menus.length - 1)]).data('close', data.closeCb);
        }

        setupItems(data);

        activeMenu.push(+$(active).data('menuId'));

        $(menus[(menus.length - 2)]).hide()
        $(menus[(menus.length - 1)]).removeClass('template');
        $(menus[(menus.length - 1)]).show()
    } else if (type === 5) {
        $(active).find('.right').html('<i class="fas fa-check-circle"></i>');

        $(menus[(menus.length - 1)]).find('.check').each(function() {
            if (!$(this).hasClass('active')) {
                $(this).find('.right').html('');
            }
        });
    } else if (type === 6) {
        $(active).find('.right').html('OWNED');
        $(active).addClass('disabled')

        $(menus[(menus.length - 1)]).find('.disabled').each(function() {
            if (!$(this).hasClass('active')) {
                let tData = $(this).data('data');
                $(this).find('.right').html('$' + formatCurrency(tData.item.cost));
                $(this).removeClass('disabled');
            }
        });
    }


    if (!(type === 0) && !(type === -1)) {
        if (selectCb == null) { return }
        isMenuOpen = false;

        data.activeMenu = activeMenu[(activeMenu.length - 1)]

        $.post('http://tb-menu/SelectItem', JSON.stringify({
            data: data,
            resource: calling_resource,
            callback: selectCb
        }), function(close) {
            if (close) {
                CloseUI();
            } else {
                isMenuOpen = true;
            }
        });
    }
}

function GoBack() {
    if (menus.length === 1) {
        CloseUI();
    } else {
        $.post('http://tb-menu/MenuBack', JSON.stringify({}));

        let close = $(menus[(menus.length - 1)]).data('close');
        if (close != null) {
            $.post('http://tb-menu/CloseCb', JSON.stringify({
                resource: calling_resource,
                callback: close
            }));
        }

        $(menus[(menus.length - 1)]).remove();
        menus.pop();
        activeMenu.pop();
        $(menus[(menus.length - 1)]).show();
        $(menus[(menus.length - 1)]).find('.menu-button.active').focus();
    }
}

function CloseUI() {
    let closeCb = $(menus[(menus.length - 1)]).data('close');
    if (closeCb != null) {
        $.post('http://tb-menu/CloseCb', JSON.stringify({
            resource: calling_resource,
            callback: closeCb
        }));
    }

    $('.menus').html('');
    $.post('http://tb-menu/CloseUI', JSON.stringify({}));

    menus = new Array();
    menuData = new Array();
    activeMenu = new Array();
    calling_resource = null;
    activeRoot = 0;
}

function SetActiveRoot(index) {
    let curActive = $(menus[(menus.length - 1)]).find(".menu-button.active");
    let newActive = $(menus[(menus.length - 1)]).find(".menu-button").eq( index );

    $(curActive).removeClass('active');
    $(newActive).addClass('active');

    if ($(newActive).data('type') == 2) {
        $(newActive).find('input').focus();
    } else {
        $(newActive).focus();
    }
}

function formatCurrency(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}