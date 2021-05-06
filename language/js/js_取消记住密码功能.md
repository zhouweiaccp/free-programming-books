##
```js


var Password = function (el, focus) {
        var self = this;
        var inner = {};

        self.value = "";
        self.element = typeof el == "string" ? $(el) : el;

        //Invalid keycode.
        inner.keyCodes = [
            9, 12, 16, 17, 18, 19, 20, 27, 33, 34,
            35, 36, 37, 38, 39, 40, 45, 46, 91, 92,
            93, 112, 113, 114, 115, 116, 117, 118,
            119, 120, 121, 122, 123, 144, 145, 166,
            167, 255
        ];

        //Clear the password.
        self.clear = function () {
            self.element.val("");
            inner.value = "";
        }

        //Enter the event.
        self.onenter = function () { }

        //Initialize
        inner.init = function () {
            inner.bind();
        }

        //Bind element events.
        inner.bind = function () {
            self.element.attr("autofocus", focus ? true : false);
            self.element.attr("autocomplete", "off");
            self.element.bind("paste", function () { return false; });
            self.element.bind("dragenter", function () { return false; });
            self.element.bind("keydown", inner.onkeydown);
            self.element.bind("keyup", function () { return false; });
        }

      
        inner.onkeydown = function (event) {
            var element = event.target;
            var keyCode = window.event.keyCode;         //Current key ASCII code
            var startIndex = element.selectionStart;    //The starting position of the selected text.
            var password = self.value;

            if (inner.filter(keyCode)) return;

            //Enter to complete the password
            if (keyCode == 13) {
                return self.onenter();
            }

            //Input in Chinese is not allowed.
            if (keyCode == 229) {
                element.value = password.replace(/[\s\S]/g, "*");
                element.blur();
                setTimeout(function () { element.focus(); }, 300);
                //layer.msg('请切换至英文输入法');
				bootoast({
                                type:'danger',
                                message: '请切换至英文输入法',
                                position:'top-center',
                                timeout:2
                            });
                return false;
            }

            //The delete key.
            if (keyCode == 8) {
                //If the starting position of the selected text is equal 
                //to the character length, then no text is selected.
                if (startIndex == password.length) {
                    startIndex = startIndex - 1;
                }
                password = password.substr(0, startIndex);
            }
            else {
                password = password.substr(0, startIndex);
                password += window.event.key;
            }

            //Replace the password with * to display in the textbox.
            self.value = password;
			$('#password').val(password);
            element.value = password.replace(/[\s\S]/g, "*");
            element.focus();
            element.setSelectionRange(password.length, password.length);

            return false;
        }

      
        inner.filter = function (keyCode) {
            return inner.keyCodes.indexOf(keyCode) > -1;
        }

        inner.init();
    }
var password1 = new Password($("#passwordnew"));
```