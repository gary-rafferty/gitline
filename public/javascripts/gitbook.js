$(function() {
  $('.login').click(function() {
    whenAvailable('FB', function(fb) {
      fb.login(function(r) {
        console.log(r);
      }, {
        scope: 'email,publish_stream'
      });
    });
  });

 function whenAvailable(name, callback) {
   var interval = 10;
   window.setTimeout(function() {
     if(window[name]) {
       callback(window[name]);
     } else {
       setTimeout(arguments.callee, interval);
     }
   }, interval);
 }
});
