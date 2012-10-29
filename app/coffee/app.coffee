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

	TABKEY = 9
	HELPKEY = 63
	XPATHKEY = 120 # x

	# TAB-completions
	@COMPLETIONS =
		# Node types
		"pro" : "cessing-instruction()"
		"com" : "ment()"
		"tex" : "t()"
		"nod" : "e()"
		"cur" : "rent()"
		# Axes
		"pre" : "ceding-sibling::"
		"fol" : "lowing-sibling::"
		"anc" : "estor-or-self::"
		"des" : "cendant-or-self::"
		"par" : "ent::"
		# String functions
		"norm": "alize-space()"
		"gen" : "erate-id()"
		"nam" : "e()"
		"loc" : "al-name()"
		"str" : "ing()"
		"con" : "tains()"
		"sta" : "rts-with()"
		"tr"  : "anslate()"
		"conc": "at()"
		"for" : "mat-number()"
		# Numeric functions
		"pos" : "ition()"
		"cou" : "nt()"
		"cei" : "ling()"
		"flo" : "or()"
		"rou" : "nd()"
		"num" : "ber()"
		# Boolean functions
		"lan" : "g()"
		"las" : "t()"
		"not" : "()"
		"bool": "ean()"
		"tru" : "e()"
		"fal" : "se()"
	
	constructor: () ->
		@setup()
	
	# Focus the XPath field and select its contents
	setup: () ->
		@focusAndSelect "#xpath"
		($ ".doc-toggle").on "click", (e) ->
			e.preventDefault()
			app.controller.toggleFold()
		($ ".help-toggle").on "click", (e) ->
			e.preventDefault()
			app.controller.toggleHelp()

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

		# Handle smart typing pairs and general shortcuts
		($ '#xpath').keypress @handleKeypress
		($ 'body').keypress @generalShortcut

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
					# don't apply any other completions 
					break

	#### Keyboard Shortcuts
	# * `?` - toggle the Help Sheet
	# * `x` - focus the XPath field
	generalShortcut: (event) ->
		switch event.keyCode
			when HELPKEY
				# Don't let the character output to XPath field
				event.preventDefault()
				app.controller.toggleHelp()
			when XPATHKEY
				# Only focus the field if we're not in it, otherwise we let the character output
				app.controller.focusAndSelect '#xpath' unless event.target.id is 'xpath'

	# * `[`, `(` and `'` will trigger insertion of the corresponding `]`, `)` or `'` to complete the pair
	handleKeypress: (event) ->
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