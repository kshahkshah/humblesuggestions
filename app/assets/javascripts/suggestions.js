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
			// $.each(data, function(index, suggestion) {
			// 	suggestions_box.append(
			// 		$("<div>")
			// 		.attr('class', 'suggestion')
			// 		.data('suggestion-id', suggestion.id)
			// 		.data('suggestion-weight', suggestion.weight)
			// 		.html(suggestion.idea).append(
			// 			$("<div class='description'>")
			// 			.append(
			// 				$("<div>").attr('class','image')
			// 				.append(
			// 					$("<img>").attr('src', suggestion.image)
			// 				)
			// 			)
			// 			.append(
			// 				$("<div>")
			// 				.attr('class', 'text')
			// 				.html(suggestion.description + "<br /><span class='link'><a href='"+suggestion.link+"'>click to watch it now</a></span>")
			// 			)
			// 		)
			// 	)
			// });
			// $(".suggestion:first").children().show();
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
				getSuggestions();

			}

		}
	});

	$("#suggestions").on('click', '.suggestion', function() {
		suggestion = $(this);

		if (suggestion.hasClass('selected')) {
			suggestion.removeClass('selected');
			suggestion.children().hide();

		} else {
			suggestion.siblings().removeClass('selected');
			suggestion.siblings().children().hide();
			suggestion.addClass('selected');
			suggestion.children().show();

		}
	});

});