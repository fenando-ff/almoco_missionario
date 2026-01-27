(function(){
  function formatPhoneValue(value){
    const digits = value.replace(/\D/g,'').slice(0,11);
    if(!digits) return '';
    if(digits.length <= 2) return '(' + digits;
    const ddd = digits.slice(0,2);
    const rest = digits.slice(2);
    let formatted = '(' + ddd + ') ';
    if(rest.length <= 4){
      formatted += rest;
    } else if(rest.length <= 8){
      formatted += rest.slice(0,4) + '-' + rest.slice(4);
    } else {
      // mobile with 9 digits after DDD
      formatted += rest.slice(0,5) + '-' + rest.slice(5);
    }
    return formatted;
  }

  function onInput(e){
    const el = e.target;
    const start = el.selectionStart;
    const old = el.value;
    const formatted = formatPhoneValue(old);
    el.value = formatted;
    // try to restore caret near the end
    if(start){
      el.selectionStart = el.selectionEnd = el.value.length;
    }
  }

  document.addEventListener('DOMContentLoaded', function(){
    const inputs = document.querySelectorAll('input[data-phone-input]');
    inputs.forEach(function(inp){
      inp.addEventListener('input', onInput);
      inp.addEventListener('blur', onInput);
      // prevent non-numeric paste
      inp.addEventListener('paste', function(ev){
        ev.preventDefault();
        const text = (ev.clipboardData || window.clipboardData).getData('text');
        const digits = text.replace(/\D/g,'');
        const formatted = formatPhoneValue(digits);
        inp.value = formatted;
      });
    });
  });
})();
