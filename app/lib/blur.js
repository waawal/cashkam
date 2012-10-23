(function($) {
	$.fn.extend({
        blurjs: function(options) {
            this.defaultOptions = {
                customClass: 'blurjs',
                radius: 5,
                persist: false
            };

			function removeBlurs(_obj){
				for(var i in window.blurJSClasses){
					if(_obj.hasClass(window.blurJSClasses[i])){
						_obj.removeClass(window.blurJSClasses[i]);
					}
				}
			}

            function singleSetting(obj, target){
            	switch(target){
            		case 'remove':
            			removeBlurs(obj);
            	}
            }
            
            function svg(amt) {
                return "url(data:image/svg+xml," + escape('<svg xmlns="http://www.w3.org/2000/svg"><filter id="blur"><feGaussianBlur stdDeviation="' + amt + '" /></filter></svg>') + "#blur)";
            }

            function css(cssClass, amt) {
                return '<style type="text/css">.' + cssClass + '{-webkit-filter:blur(' + amt + 'px);filter:' + svg(amt) + ';}</style>';
            }

			if(typeof options=='string'){
				singleSetting($(this), options);
				return;
			}
			
			var settings = $.extend({}, this.defaultOptions, options);
			
			if(typeof window.blurJSClasses=='undefined'){
				window.blurJSClasses=[];
			}
			
            return this.each(function() {
                var $this = $(this),
                    blurredClass = settings.customClass + '-' + settings.radius + '-radius';
				
				window.blurJSClasses.push(blurredClass);
				
				if (!settings.persist && $('head style:contains(' + settings.customClass + ')').length !== 0) {
                    $('head style:contains(' + settings.customClass + ')').remove();
                }
				if ($('head style:contains('+blurredClass+')').length === 0) {
					var cssData = css(blurredClass, settings.radius);
					console.log(cssData);
                    $(cssData).appendTo('head');
                }
                $this.addClass(blurredClass);
            });
        }
    });
    $.extend({
		blurjs: function(action){
			if(action=='reset'){
				for(var i in window.blurJSClasses){
					$('.'+window.blurJSClasses[i]).removeClass(window.blurJSClasses[i]);
				}
			}
		}
	});
})(jQuery);