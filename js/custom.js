$(document).ready(function(){
	// lights
	$("#menu .theme a").click(function() {
		$('body').addClass('no-effects');
		setTimeout(function(){
			$('body').removeClass('no-effects');
		}, 500);

		var current = $('link#theme').attr('href');
		if(current == '/style/dark.css') {
			$('link#theme').attr('href', '/style/light.css')
		} else {
			$('link#theme').attr('href', '/style/dark.css')
		}
	});

	$('#toggle-box-checkbox').change(function() {
		if(this.checked){
			$('link#theme').attr('href', '/style/dark.css');
		} else {
			$('link#theme').attr('href', '/style/light.css');
		}
	});

	$('.col .row .title').append('<span class="icon fa toggle-row"></span>');

	$('.col .row .title .toggle-row').click(function(){
		$(this).parent('.title').parent('.row').toggleClass('innactive');
		$(this).toggleClass('innactive');
	});

	var zindex = 3;
	$('.col .row').draggable({
		handle: '.title',
		containment: '#content',
		scroll: false,
		start: function() {
			zindex++; //first selected is 4
			

			$('.col .row').each(function() {
				newzindex = $(this).css('z-index');
				$(this).css('z-index', newzindex);

				if(zindex <= newzindex) {
					zindex = parseFloat(newzindex) + 1;
				}
			});

			$(this).addClass('no-effect');
			$(this).css('z-index', zindex);
		},
		stop: function() {
			$(this).removeClass('no-effect');
		},
	});

	$('.row').draggable('disable');

	function getDimensions() {
		$('.col .row').each(function() {
			this.dataset.left	= $(this).position().left - 5;
			this.dataset.top	= $(this).offset().top - 60;
		});
	}
	getDimensions();

	toggleDragging = function toggleDragging() {
		if($('.col .row').draggable('option', 'disabled')) {
			// now it is enabled
			$('.col .row .title').css('cursor', 'move');
			$('.col .row').each(function() {
				$(this).css('left', this.dataset.left + 'px').addClass('draggable');
			});

			$('.col .row').draggable('enable');
			$('a#draggable span').html('Disable Dragging');
		} else {
			// not it is disabled
			$('.col .row .title').css('cursor', '');
			$('.col .row').each(function() {
				$(this).css('left', '').css('top', '').removeClass('draggable');
			});

			$('.col .row').draggable('disable');
			$('a#draggable span').html('Enable Dragging');
		}
	}
});