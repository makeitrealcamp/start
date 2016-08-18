(function() {
  var initForm = function() {
    $('#form-start-now').on('submit', validateForm);
    $(document).on("page:before-change", function() {
      $('#form-start-now').off('submit');
    });
  };

  var validateField = function(selector, validFn, message) {
    var formGroup = selector.closest('.form-group');
    formGroup.removeClass("has-error");
    $('.help-block', formGroup).remove();

    var firstName = selector.val();
    if (!validFn(firstName)) {
      selector.closest('.form-group').addClass("has-error").append('<span class="help-block">' + message + '</span>');
      return false;
    }

    return true;
  }

  var isBlank = function(val) {
    return val.trim().length !== 0;
  };

  var isEmail = function(val) {
    return /(.+)@(.+){2,}\.(.+){2,}/.test(val);
  }

  var isMobile = function(val) {
    return /[0-9\-()\+\s]{7,20}/.test(val);
  }

  var validateForm = function() {
    var isValid = true;

    if (!validateField($('#first-name'), isBlank, "Campo requerido")) {
      $('#first-name').one('change', validateForm);
      isValid = false;
    }

    if (!validateField($('#last-name'), isBlank, "Campo requerido")) {
      $('#last-name').one('change', validateForm);
      isValid = false;
    }

    if (!validateField($('#email'), isBlank, "Campo requerido")) {
      $('#email').one('change', validateForm);
      isValid = false;
    } else if (!validateField($('#email'), isEmail, "Email inválido")) {
      $('#email').one('change', validateForm);
      isValid = false;
    }

    if (!validateField($('#mobile'), isBlank, "Campo requerido")) {
      $('#mobile').one('change', validateForm);
      isValid = false;
    } else if (!validateField($('#mobile'), isMobile, "Celular inválido")) {
      $('#mobile').one('change', validateForm);
      isValid = false;
    }

    return isValid;
  }

  window.initMedellinProgramPage = function() {
    initForm();
    
    $(window).on('scroll', function() {
      var scroll = $(window).scrollTop();
      if (scroll > 600) {
        $('.header-register').slideDown();
      } else {
        $('.header-register').slideUp();
      }
    });
  };

})();
