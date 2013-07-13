<!DOCTYPE html>

<html>
  <head>
    <title>Team Asha Mile Time Trial</title>
    <link type="text/css" media="all" href="views/bootstrap.min.css" rel="stylesheet" />
    <link type="text/css" media="all" href="views/bootstrap-responsive.min.css" rel="stylesheet" />
    <style type="text/css">
      body {
        padding-top: 20px;
        padding-bottom: 40px;
      }

      /* Custom container */
      .container-narrow {
        margin: 0 auto;
        max-width: 700px;
      }
      .container-narrow > hr {
        margin: 30px 0;
      }

      /* Main marketing message and sign up button */
      .jumbotron {
        margin: 60px 0;
        text-align: center;
      }
      .jumbotron h1 {
        font-size: 72px;
        line-height: 1;
      }
      .jumbotron .btn {
        font-size: 21px;
        padding: 14px 24px;
      }

      /* Supporting marketing content */
      .marketing {
        margin: 60px 0;
      }
      .marketing p + h4 {
        margin-top: 28px;
      }
    </style>
  </head>
  <body>
        <div class="container-narrow"> 
              <div class="masthead">
                <ul class="nav nav-pills pull-right">
                  <li class="active"><a href="/">Home</a></li>
                  <li><a href="#">Manage</a></li>
                  <li><a href="#">Reports</a></li>
                </ul>
                <h1 class="text-error">MILE TIME TRIAL</h1>
              </div>   
              <div class="jumbotron">
                <a href="/"><img src="views/ta2logo_800.gif" class="img-rounded navbar"/></a>
                <hr>
                  <span id="box_time" align="center" class="img-rounded btn btn-large btn-primary">Start Timer</span>
              </div>              
              <div class="row-fluid marketing">
                <div class="span8">
                  <h4>Runners</h4>                  
                </div>
              </div>
          <hr>      
        </div> <!-- /container -->
        
  <script type="text/javascript" src="views/jquery.js"></script>
  <script type="text/javascript" src="views/bootstrap.min.js"></script>
  <script type="text/javascript">
      $('#box_time').click(function(){
        var timer_start = {timer : "Start"};
        $.ajax({
          type: 'POST',
          url: '/',
          data: timer_start,
          datatype: "text",
          success: function(response){
            var refreshtime = setInterval(function() {
                            $(document).ready(function(){
                              $.ajax({
                                type: 'GET',
                                url: '/get_time',
                                data: $(this).serialize(),
                                success: function(response){
                                  $('#box_time').text(response);
                                },
                                error: function(response){
                                  clearInterval(refreshtime);
                                }
                              });
                            });
                          }, 100);        
          },
          error: function(response){
            console.log(response);
          }
        });
      });                
  </script>
  </body>

</html>
