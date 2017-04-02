var animationSpeed = 500;
var sap, selectedNetwork;

$(function() {
  sap = new SoftAPSetup();

  $('#buttons a').click(function(e){
    $(this).addClass('active');
    jQuery.ajax('/serve?index=' + $(e.currentTarget).data('index'));
  }).on('webkitAnimationEnd oanimationend msAnimationEnd animationend', function(){
    $(this).removeClass('active');
  });

  jQuery.ajax('/alive').then(function(response){
    if (response.alive) {
      $('#buttons').fadeIn(animationSpeed);
    } else {
      $('#setup').fadeIn(animationSpeed);
    }
  });
});

function step2() {
  $('.step').hide();
  $('#step-2').show();

  var callback = function(){
    sap.deviceInfo(function(err, dat){
      if (err) {
        console.log(err);
        return setTimeout(callback, 1000);
      }

      sap.scan(function(err, dat){
        for (var i = 0; i < dat.length; i++) {
          var network = dat[i];
          console.log(network);
          var button = $('<a/>')
            .data('network', network)
            .addClass('btn')
            .text(network.ssid)
            .click(function(e){
              selectedNetwork = $(e.currentTarget).data('network');
              step4();
            });
          $('#step-3 ul').append(button);
        }
        $('.step').hide();
        $('#step-3').show();
      });
    });
  };
  setTimeout(callback, 1000);
}

function step4() {
  $('.step').hide();
  $('#wifi-password').prop('placeholder', 'Password for "' + selectedNetwork.ssid + '"');
  $('#step-4').show();
}

function step5() {
  sap.publicKey(function() {
    sap.configure({
      ssid: selectedNetwork.ssid,
      sec: selectedNetwork.sec,
      password: $('#wifi-password').val(),
      channel: selectedNetwork.ch
    }, function(){
      sap.connect(function(){
        $('.step').hide();
        $('#step-5').show();

        var callback = function() {
          jQuery.ajax('/alive').then(function(response){
            if (response.alive) {
              $('#setup').fadeOut(animationSpeed / 2);
              $('#buttons').fadeIn(animationSpeed / 2);
            } else {
              setTimeout(callback, 1000);
            }
          }, function(){
            setTimeout(callback, 1000);
          });
        };
        setTimeout(callback, 1000);
      });
    });
  });
}
