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
		controller = @
		($ '#xpath').keypress (event) ->
			console.log document.getSelection().focusOffset
			switch event.keyCode
				when 91 # [
					controller.sendCharacters '[]'
					event.preventDefault()
					($ this).trigger($.Event('keydown', keyCode: 37))
				when 40 # (
					controller.sendCharacters '()'
					event.preventDefault()
			

	sendCharacters: (chars) ->
		oldValue = ($ '#xpath').val()
		($ '#xpath').val oldValue + chars

# Start everything when the page is ready
$ ->
	app.controller = new FiddleController