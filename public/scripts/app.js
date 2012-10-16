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
      "pi": "processing-instruction()",
      "pre": "preceding-sibling::"
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
      ($('#xpath')).keydown(function(event) {
        if (event.keyCode === TABKEY) {
          return event.preventDefault();
        }
      });
      return ($('#xpath')).keypress(function(event) {
        var $input, code, pair;
        $input = $(this);
        code = event.keyCode;
        if (__indexOf.call(FiddleController.KEYCODES, code) >= 0) {
          event.preventDefault();
          pair = FiddleController.PAIRS[code];
          $input.insertAtCaretPos(pair);
          return $input.setCaretPos(2 + $input.val().indexOf(pair));
        }
      });
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
