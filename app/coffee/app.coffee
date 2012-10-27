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
	
	# TAB-completions
	TABKEY = 9
	@COMPLETIONS =
		"pro" : "cessing-instruction()"
		"com" : "ment()"
		"tex" : "t()"
		"nod" : "e()"
		"norm": "alize-space()"
		"nam" : "e()"
		"loc" : "al-name()"
		"for" : "mat-number()"
		"pre" : "ceding-sibling::"
		"fol" : "lowing-sibling::"
		"cur" : "rrent()"
		"pos" : "ition()"
		"con" : "tains()"
		"sta" : "rts-with()"
		"conc": "at()"
		"not" : "()"
		"bool": "ean()"
		"num" : "ber()"
		"str" : "ing()"
	
	constructor: () ->
		@setup()
	
	# Focus the XPath field and select its contents
	setup: () ->
		@focusAndSelect "#xpath"
		($ "#toggle").on "click", (e) ->
			e.preventDefault()
			app.controller.toggleFold()

		@assignKeys()
		@renderHelpSheetCompletions()
	
	toggleFold: () ->
		$fold = $ "#xml-document"
		$fold.toggleClass "out"
		@focusAndSelect "#xdoc" if $fold.hasClass "out"
		
	toggleHelp: () ->
		($ 'body').toggleClass "showhelp"

	focusAndSelect: (field) ->
		$field = $ field
		window.setTimeout ->
			$field[0].select()
		, 300

	assignKeys: () ->
		controller = @
		# Handle TAB completions
		($ '#xpath').keydown @tabCompletion
		
		# Handle smart typing pairs
		($ '#xpath').keypress @smartTypingPairs
	
	tabCompletion: (event) ->
		if event.keyCode is TABKEY
			$input = $ this
			pos = $input.getCaretPos()
			# Grab the string from start up to the caret position
			uptoHere = $input.val().substring 0, pos
			# Go through the COMPLETIONS
			for shortcut, completion of FiddleController.COMPLETIONS
				# If we have a match for the shortcut
				if uptoHere[-shortcut.length...] is shortcut
					# Don't finish the TAB (would exit the input field) 
					event.preventDefault()
					# complete the word/function/etc.
					$input.insertAtCaretPos completion
	
	smartTypingPairs: (event) ->
		$input = $ this
		code = event.keyCode
		
		if code in FiddleController.KEYCODES
			event.preventDefault()
			pair = FiddleController.PAIRS[code]
			$input.insertAtCaretPos pair
			# looks wrong, but it works...
			$input.setCaretPos $input.getCaretPos()
	
	sendCharacters: (chars) ->
		oldValue = ($ '#xpath').val()
		($ '#xpath').val oldValue + chars
		
	renderHelpSheetCompletions: ->
		items = ""
		items += ("\n<dt>#{shortcut} &#x21E5;</dt>\n<dd>#{shortcut}#{completion}</dd>") for shortcut, completion of FiddleController.COMPLETIONS 
		list = $ "<h2>TAB completions</h2>\n<dl>#{items}</dl>"
		($ '#help').append list

# Start everything when the page is ready
$ ->
	app.controller = new FiddleController