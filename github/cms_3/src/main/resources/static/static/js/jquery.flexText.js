/*
    姝ゆ彃浠秚extarea鐨勯珮搴︽槸 height:100%; 缁ф壙鐖跺厓绱犵殑楂樺害 ==> 鐖跺厓绱犲彧鏈変竴涓� position:relative; 鐢ㄤ簬瀹氫綅textarea
    椤甸潰涓姞杞藉畬姣曞張娣诲姞浜唒re鏍囩锛宲re鏍囩鏄互鍧楀厓绱犲瓨鍦ㄧ殑骞朵笖涓嶅彲瑙侊紝浣嗘槸鍗犵敤绌洪棿锛�
    涓嶅儚display:none;浠€涔堢┖闂翠篃涓嶅崰銆�
    鎵€浠extarea鐖跺厓绱犵殑楂樺害鏄€氳繃pre鎾戝紑鐨�(鍦╰extarea閲岄潰鍐欏叆鏂囧瓧锛屾枃瀛椾細琚坊鍔犲埌pre搴曚笅鐨剆pan鏍囩閲岋紝浠ユ鏉ユ拺寮€pre鐨勯珮搴�)

    瑕佹敼鍙榯extarea鍒濆鍖栨椂鐨勯珮搴︼紝鍙渶鏀瑰彉pre鐨刾adding鍊煎嵆鍙紝椤甸潰鍔犺浇鏃秔re閲岄潰娣诲姞<br />鏍囩鏄负浜嗚pre鏍囩鍒濆鏃舵湁涓珮搴�
 */
(function ($) {

    // Constructor
    function FT(elem) {
        this.$textarea = $(elem);

        this._init();
    }

    FT.prototype = {
        _init: function () {
            var _this = this;

            // Insert wrapper elem & pre/span for textarea mirroring
            this.$textarea.wrap('<div class="flex-text-wrap" />').before('<pre class="pre"><span /><br /></pre>');

            this.$span = this.$textarea.prev().find('span');

            // Add input event listeners
            // * input for modern browsers
            // * propertychange for IE 7 & 8
            // * keyup for IE >= 9: catches keyboard-triggered undos/cuts/deletes
            // * change for IE >= 9: catches mouse-triggered undos/cuts/deletions (when textarea loses focus)
            this.$textarea.on('input propertychange keyup change', function () {
                _this._mirror();
            });

            // jQuery val() strips carriage return chars by default (see http://api.jquery.com/val/)
            // This causes issues in IE7, but a valHook can be used to preserve these chars
            $.valHooks.textarea = {
                get: function (elem) {
                    return elem.value.replace(/\r?\n/g, "\r\n");
                }
            };

            // Mirror contents once on init
            this._mirror();
        }

        // Mirror pre/span & textarea contents
        ,_mirror: function () {
            this.$span.text(this.$textarea.val());
        }
    };

    // jQuery plugin wrapper
    $.fn.flexText = function () {
        return this.each(function () {
            // Check if already instantiated on this elem
            if (!$.data(this, 'flexText')) {
                // Instantiate & store elem + string
                $.data(this, 'flexText', new FT(this));
            }
        });
    };

})(jQuery);