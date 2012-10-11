# Global app object 
@app = window.app ? {}	

# Main controller for the page's functions
class FiddleController
	constructor: () ->
		@setup()
	
	# Focus the XPath field and select its contents
	setup: () ->
		@focusAndSelect "#xpath"
		($ "#toggle").on "click", (e) ->
			e.preventDefault()
			app.controller.toggleFold()
		# Override filter() method in keymaster.js to allow monitoring INPUT 
		window.key.filter = @filter
		@assignKeys()
	
	toggleFold: () ->
		$fold = $ "#xml-document"
		$fold.toggleClass "out"
		@focusAndSelect "#xdoc" if $fold.hasClass "out"

	focusAndSelect: (field) ->
		$field = $ field
		window.setTimeout ->
			$field[0].select()
		, 300

	assignKeys: () ->
		key '[', -> console.log '[]'

	# Override for `filter()` in *keymaster.js*
	filter: (event) ->
		tagName = (event.target or event.srcElement).tagName
		console.log !(tagName is 'SELECT' or tagName is 'TEXTAREA')
		!(tagName is 'SELECT' or tagName is 'TEXTAREA')
	
# Start everything when the page is ready
$ ->
	app.controller = new FiddleController