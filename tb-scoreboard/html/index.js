var visable = false;

$(function () {
	window.addEventListener('message', function (event) {
		switch (event.data.action) {
			
			case 'toggle':
				if (visable) {
					$('.container').fadeOut();
				} else {
					$('.container').fadeIn();
				}
				$('#current-players').html(event.data.currentPlayers);
				visable = !visable;
				break;

			case 'close':
				$('.container').fadeOut();
				visable = false;
				break;

			default:
				console.log('TBCore | Invalid action');
				break;
		}
	}, false);
});
