$(function() {
  $('.login').click(function() {
    whenAvailable('FB', function(fb) {
      fb.login(function(r) {
        if(r.authResponse) {
          var response = r.authResponse;

          var uid = response.userID;
          var token = response.accessToken;
          var email;

          fb.api('/me',function(r) {
            email = r.email;
            $.ajax({
              url:'/sessions/new',
              type:'POST',
              data:{uid:uid,token:token,email:email},
              success:function(data) {
                window.location.href = '/home';
              },
              error: function(data) {
                console.log(data);
              }
            });
          });
         }
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
