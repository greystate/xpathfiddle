# Global app object 
@app = window.app ? {}	

# Main controller for the page's functions
class FiddleController
	# Character pairs to insert automatically
	# key is keyCode of trigger, value is characters to insert
	@PAIRS =
		39 : "''"
		40 : "()"
		91 : "[]"
	# Grab the keyCodes for easier lookup later (+k to make sure they're stored as numbers)
	@KEYCODES = (+k for k of @PAIRS)
	
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
			$input = $ this
			code = event.keyCode
			
			if code in FiddleController.KEYCODES
				event.preventDefault()
				pair = FiddleController.PAIRS[code]
				$input.insertAtCaretPos pair
				$input.setCaretPos 2 + $input.val().indexOf pair
			
	sendCharacters: (chars) ->
		oldValue = ($ '#xpath').val()
		($ '#xpath').val oldValue + chars

# Start everything when the page is ready
$ ->
	app.controller = new FiddleController