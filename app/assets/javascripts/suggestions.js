$(document).ready(function(){

	var time = null;
	var loc	 = null;
	var latitude 	= null;
	var longitude = null;

	$.geolocation.get({
		win: function(position) {
			latitude 	= position.coords.latitude;
			longitude = position.coords.longitude;
			$.cookie('latitude', latitude);
			$.cookie('longitude', longitude);
		}, 
		fail: function(position) {
		}
	});


	function getSuggestions() {
		suggestions_box = $('#suggestions');

		$.ajax({
			type: 		'POST',
			url: 			'/suggestions',
			data: 		{ time: time, loc: loc, longitude: longitude, latitude: latitude },
			dataType: 'html'
		}).success(function(data){
			suggestions_box.html(data);
		});

		suggestions_box.show(500, 'linear');
	};

	$(".choice").bind('click', function() {
		choice = $(this);

		if (choice.hasClass('selected')) {
			choice.removeClass('selected');
			choice.siblings().show(500, 'linear');

		} else {
			choice.siblings().removeClass('selected');
			choice.addClass('selected');
			choice.siblings().hide(500, 'linear');

			if ( choice.data('choice-type') == 'time' ) {
				time = choice.data('choice');

			} else {
				loc = choice.data('choice');

			};

			if(loc && time) {
				mixpanel.track('Suggestions Requested', {'time': time, 'location': loc});
				getSuggestions();
			}

		}
	});

});