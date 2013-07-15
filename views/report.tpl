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
      .btn-start{
        background-color: #5bb75b;
        background-image:-moz-linear-gradient(top,#5CB87b,#5bb75b);
      }
      .btn-start:hover,
      .btn-start:focus,
      .btn-start:active{
        background-color: #5bb75b;
      }
      .btn-stop{
        background-color: #bd362f;
        background-image:-moz-linear-gradient(top,#bd362f,#bd362f);
      }
      .label-info{
        background-color: #555555;
      }
    </style>
  </head>
  <body>
        <div class="container-narrow"> 
              <div class="masthead">
                <ul class="nav nav-pills pull-right">
                  <li><a href="/">Home</a></li>
                  <li><a href="/manage">Manage</a></li>
                  <li class="active"><a href="/report">Reports</a></li>
                </ul>                
              </div>              
              <div class="row-fluid">
                <div class="span12">
                  <h4>Track Runners</h4>
                    <table class="table table-bordered span12">
                      <thead>
                        <th class="span1">Bib Number</th>
                        <th class="span3">Name</th>
                        <th class="span7">Split Times</th>
                        <th class="span1">Total Time</th>
                      </thead>
                      <tbody id="list_of_runners"> 
                        %for result in results:
                        <tr>
                          <td>{{result['bib_number']}}
                          </td>
                          <td>{{result['name']}}
                          </td>
                          <td>
                            <div class='progress progress-striped active'>
                              % numLaps = len(result['laps'])
                              %for i in range (0,numLaps):
                              <div class='bar'  style='width: 25%;'>{{result['laps'][i]['time']}}</div>
                              %end
                            </div> 
                          </td>
                          <td>{{result['total_time']}}
                          </td>
                        %end
                        </tr>                       
                      </tbody>
                    </table>                                                      
                </div>
              </div>
          <hr>      
        </div> <!-- /container -->

  <script type="text/javascript" src="views/jquery.js"></script>
  <script type="text/javascript" src="views/bootstrap.min.js"></script>
  <script type="text/javascript">
      var refreshtime;
      $('#start_timer').click(function(){ 
        $('#start_timer').removeClass('btn-start');
        $('a').bind('click', function(e){e.preventDefault();})
        $(this).text(function(i, text){                               
            var timer_start = {timer : "Start"};
            var timer_stop = {timer: "Stop"};
            $.ajax({
              type: 'POST',
              url: '/',
              data: text === "Start" ? timer_start: timer_stop,
              datatype: "text",
              success: function(response){
                if(text == "Stop"){
                  $('#start_timer').addClass('btn-start');
                  clearInterval(refreshtime);
                  $('a').unbind('click');
                }else{
                   refreshtime = setInterval(function() {                              
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
                 }

              },
              error: function(response){
                console.log("Error Response 1 ",response);
              }
            });          
          return text === "Start"?"Stop" : "Start";          
        });
      });
               
  </script>
  </body>

</html>
