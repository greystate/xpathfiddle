# Global app object 
@app = window.app ? {}	

# Main controller for the page's functions
class FiddleController
	constructor: () ->
		@setup()
	
	# Focus the XPath field and select its contents
	setup: () ->
		$xpathField = $ "#xpath"
		$xpathField.focus()
		$xpathField[0].select()
		($ "#toggle").on "click", (e) ->
			e.preventDefault()
			app.controller.toggleFold()
	
	toggleFold: () ->
		$fold = $ "#xml-document"
		$fold.toggleClass "out"

# Start everything when the page is ready
$ ->
	app.controller = new FiddleController