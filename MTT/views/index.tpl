<!DOCTYPE html>

<html>
  <head>
    <title>Team Asha Mile Time Trial</title>
    <link type="text/css" media="all" href="static/bootstrap.min.css" rel="stylesheet" />
    <link type="text/css" media="all" href="static/bootstrap-responsive.min.css" rel="stylesheet" />
    <style type="text/css">
      body {
        padding-top: 20px;
        padding-bottom: 40px;
      }

      /* Custom container */
      .container-narrow {
        margin: 0 auto;
        max-width: 800px;
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
                  <li class="active"><a href="/">Home</a></li>
                  <li><a href="/manage">Manage</a></li>
                  <li><a href="/report">Reports</a></li>
                </ul>                
              </div>   
              <div class="jumbotron">
                <a href="/"><img src="static/ta2logo_800.gif" class="img-rounded navbar"/></a>
                <hr>
                  <div class="controls">
                      <select id="SelectedRelay">
                        <option value=''>---</option> 
                        %for relay in relays:
                        <option>{{relay['relay_number']}}</option>
                        %end
                      </select>
                  </div>
                  <h4 id="error" class="hidden alert-error">Select a Relay before you start the timer.</h4>
                  <span id="box_time" align="center" class="img-rounded label label-info">00:00:00.0</span><br><br>
                  <span id="start_timer" align="center" class="img-rounded btn btn-large btn-primary btn-start">Start</span>
              </div>              
              <div class="row-fluid">
                <div class="span12">
                  <h4>Track Runners</h4>
                    <table class="table table-bordered span12">
                      <thead>
                        <th class="span2">Bib Number</th>
                        <th class="span8">Progress</th>
                        <th class="span2">Total Time</th>
                      </thead>
                      <tbody id="list_of_runners">                        
                      </tbody>
                    </table>                                                      
                </div>
              </div>
          <hr>      
        </div> <!-- /container -->

  <script type="text/javascript" src="static/jquery.js"></script>
  <script type="text/javascript" src="static/bootstrap.min.js"></script>
  <script type="text/javascript">      
      var refreshtime;
      var relay_number;
      $('#start_timer').click(function(){
        if($('#SelectedRelay').val().length>0){
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
                  $('#list_of_runners').delegate('div.progress','click',function(){
                    var bib_no = $(this).parent().siblings('.bib').text();                    
                    var that = $(this);
                    var class_id = ".bib_"+bib_no;
                      $.ajax({
                        type: 'GET',
                        url: '/add_runner_time',
                        data: {'bib_no': bib_no, 'relay_number':relay_number},
                        datatype: "json",
                        success: function(response){
                            var html_data = "<div class='bar'  style='width: 25%;'>"+response['elapsed']+"</div>";
                            $(that).append(html_data);
                            if(response['lap']==4){
                              $(that).parent().siblings('.total_time').text(response['total_time']);
                              $(that).parents().siblings('.progress').unbind('click');
                            }
                        },
                        error: function(response){

                        }
                      });
                      
                   });                   
                 }

              },
              error: function(response){
                console.log("Error Response 1 ",response);
              }
            });          
          return text === "Start"?"Stop" : "Start";          
        });
        }
        else{
          $('#error').removeClass('hidden');
          setInterval(function(){             
            $('#error').addClass('hidden'); 
          },3000);
          
        } 
      });

    $('#SelectedRelay').change(function(){
      if($(this).val().length>0){
        relay_number = $(this).val()
        $('#list_of_runners').text('');
        $.ajax({
          type: 'GET',
          url: '/get_relay_runners',
          data: {'relay_number': relay_number},
          datatype: "json",
          success: function(response){
            var number_of_runners = response['relay_runners'].length;
            var runners = response['relay_runners'];            
            var html_data = '';
            $.each(runners,function(){
              $.each(this, function(k){
                var bib_no = this[k];
                html_data = html_data+"<tr><td class='bib'>"+bib_no+"</td><td><div class='progress progress-striped active'></div></td><td class='total_time'>00:00:00.0</td></tr>"
              })
            })
            $('#list_of_runners').append(html_data);            
          },
          error: function(response){
            console.log(response);
          }

        });
      }

    })
               
  </script>
  </body>

</html>
