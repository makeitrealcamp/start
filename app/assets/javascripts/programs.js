(function() {
  var updateCountryCode = function() {
    var country = $('#country').val();
    if (country !== "") {
      showMobile();
      $('#mobile').focus();
    } else {
      $('#mobile-wrapper').hide();
    }
  }

  var showMobile = function() {
    $('#mobile-code').html('+' + $('#country option:selected').data('code'));
    $('#mobile-wrapper').show();
  }

  var detectCountry = function(selector) {
    $.getJSON("//ipinfo.io?token=dbb0f38cf907e8")
      .done(function(response) {
        var country = response.country;
        var countries = $.map($('#country options'), function(option) {
          return option.value
        });
        if (countries.indexOf(country)) {
          $('#country').val(country);
          showMobile();
        } else {
          $('#country').val("");
          $('#mobile-wrapper').hide();
        }
      });

    $('#first-name').focus();
  };

  var initForm = function() {
    $('#form-register').on('submit', validateForm);
    $(document).on("turbolinks:click", function() {
      $('#form-register').off('submit');
    });

    detectCountry();
    $('#country').on('change', updateCountryCode);
    $(document).on("turbolinks:click", function() {
      $('#country').off('change');
    });
  };

  var validateField = function(selector, validFn, message) {
    var formGroup = selector.closest('.form-group');
    formGroup.removeClass("has-error");
    $('.help-block', formGroup).remove();

    var value = selector.val();
    if (!validFn(value)) {
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

    if (!validateField($('#form-register #first-name'), isBlank, "Campo requerido")) {
      $('#form-register #first-name').one('change', validateForm);
      isValid = false;
    }

    if (!validateField($('#form-register #last-name'), isBlank, "Campo requerido")) {
      $('#form-register #last-name').one('change', validateForm);
      isValid = false;
    }

    if (!validateField($('#form-register #email'), isBlank, "Campo requerido")) {
      $('#form-register #email').one('change', validateForm);
      isValid = false;
    } else if (!validateField($('#form-register #email'), isEmail, "Email inválido")) {
      $('#form-register #email').one('change', validateForm);
      isValid = false;
    }

    if (!validateField($('#form-register #country'), isBlank, "Campo requerido")) {
      $('#form-register #country').one('change', validateForm);
      isValid = false;
    }

    if (!validateField($('#form-register #mobile'), isBlank, "Campo requerido")) {
      $('#form-register #mobile').one('change', validateForm);
      isValid = false;
    } else if (!validateField($('#mobile'), isMobile, "Celular inválido")) {
      $('#form-register #mobile').one('change', validateForm);
      isValid = false;
    }

    return isValid;
  }

  window.initProgramPage = function() {
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
