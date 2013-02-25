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
			dataType: 'json'
		}).success(function(data){
			$.each(data, function(index, suggestion) {
				suggestions_box.append(
					$("<div>")
					.attr('class', 'suggestion')
					.data('suggestion-id', suggestion.id)
					.data('suggestion-weight', suggestion.weight)
					.html(suggestion.idea)
				)
			});
		});

		suggestions_box.show(500, 'linear');
	};

	$(".choice").toggle(function() {
		choice = $(this);
		choice.siblings().removeClass('selected');
		choice.addClass('selected');
		choice.siblings().hide(500, 'linear');

		if ( choice.data('choice-type') == 'time' ) {
			time = $(this).data('choice');
		} else {
			loc = $(this).data('choice');
		};

		if(loc && time) {
			getSuggestions();
		}

	}, function(){
		$(this).removeClass('selected');
		$(this).siblings().show(500, 'linear');
	});

});