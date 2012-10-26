// Generated by CoffeeScript 1.3.3
(function() {
  var FiddleController, _ref,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  this.app = (_ref = window.app) != null ? _ref : {};

  FiddleController = (function() {
    var TABKEY, k;

    FiddleController.PAIRS = {
      39: "''",
      40: "()",
      91: "[]"
    };

    FiddleController.KEYCODES = (function() {
      var _results;
      _results = [];
      for (k in FiddleController.PAIRS) {
        _results.push(+k);
      }
      return _results;
    })();

    TABKEY = 9;

    FiddleController.COMPLETIONS = {
      "pro": "cessing-instruction()",
      "com": "ment()",
      "tex": "t()",
      "nod": "e()",
      "norm": "alize-space()",
      "nam": "e()",
      "loc": "al-name()",
      "for": "mat-number()",
      "pre": "ceding-sibling::",
      "fol": "lowing-sibling::",
      "cur": "rrent()",
      "pos": "ition()",
      "con": "tains()",
      "conc": "at()",
      "not": "()",
      "bool": "ean()",
      "num": "ber()",
      "str": "ing()"
    };

    function FiddleController() {
      this.setup();
    }

    FiddleController.prototype.setup = function() {
      this.focusAndSelect("#xpath");
      ($("#toggle")).on("click", function(e) {
        e.preventDefault();
        return app.controller.toggleFold();
      });
      return this.assignKeys();
    };

    FiddleController.prototype.toggleFold = function() {
      var $fold;
      $fold = $("#xml-document");
      $fold.toggleClass("out");
      if ($fold.hasClass("out")) {
        return this.focusAndSelect("#xdoc");
      }
    };

    FiddleController.prototype.focusAndSelect = function(field) {
      var $field;
      $field = $(field);
      return window.setTimeout(function() {
        return $field[0].select();
      }, 300);
    };

    FiddleController.prototype.assignKeys = function() {
      var controller;
      controller = this;
      ($('#xpath')).keydown(this.tabCompletion);
      return ($('#xpath')).keypress(this.smartTypingPairs);
    };

    FiddleController.prototype.tabCompletion = function(event) {
      var $input, completion, pos, shortcut, uptoHere, _ref1, _results;
      if (event.keyCode === TABKEY) {
        $input = $(this);
        pos = $input.getCaretPos();
        uptoHere = $input.val().substring(0, pos);
        _ref1 = FiddleController.COMPLETIONS;
        _results = [];
        for (shortcut in _ref1) {
          completion = _ref1[shortcut];
          if (uptoHere.slice(-shortcut.length) === shortcut) {
            event.preventDefault();
            _results.push($input.insertAtCaretPos(completion));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      }
    };

    FiddleController.prototype.smartTypingPairs = function(event) {
      var $input, code, pair;
      $input = $(this);
      code = event.keyCode;
      if (__indexOf.call(FiddleController.KEYCODES, code) >= 0) {
        event.preventDefault();
        pair = FiddleController.PAIRS[code];
        $input.insertAtCaretPos(pair);
        return $input.setCaretPos($input.getCaretPos());
      }
    };

    FiddleController.prototype.sendCharacters = function(chars) {
      var oldValue;
      oldValue = ($('#xpath')).val();
      return ($('#xpath')).val(oldValue + chars);
    };

    return FiddleController;

  })();

  $(function() {
    return app.controller = new FiddleController;
  });

}).call(this);
