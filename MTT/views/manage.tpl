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
                  <li ><a href="/">Home</a></li>
                  <li class="active"><a href="/manage">Manage</a></li>
                  <li><a href="/report">Reports</a></li>
                </ul>                
              </div>                 
                <a href="/"><img src="static/ta2logo_800.gif" class="img-rounded navbar"/></a>
                <hr>
                <div class="accordion" id="accordion1">
                <div class="accordion-group">
                  <div class="accordion-heading">
                    <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion1" href="#collapse1">
                      Add Runner
                    </a>
                  </div>
                  <div id="collapse1" class="accordion-body collapse in">
                    <div class="accordion-inner">
                      <form class="form-horizontal span4" action="/add_runner" method="POST">  
                          <fieldset>  
                            <div class="control-group">
                                <label for="BibNumber" class="control-label">Bib Number:</label>

                                <div class="controls">
                                    <input type="text" id="BibNumber" name="BibNumber"/>                            
                                </div>
                            </div>  
                            <div class="control-group">
                                <label for="Name" class="control-label">Name:</label>

                                <div class="controls">
                                    <input type="text" id="Name" name="Name"/>                            
                                </div>
                            </div>
                            <div class="form-actions">
                              <input type="submit" class="img-rounded btn btn-medium btn-primary btn-start" value="Save" />
                              <span id="cancel_form" class="img-rounded btn btn-medium btn-primary btn-stop">Cancel</span>
                            </div>      
                          </fieldset>
                        </form>
                    </div>
                  </div>
                </div>
                %if (len(runners)>0):
                <div class="accordion-group">
                  <div class="accordion-heading">
                    <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion1" href="#collapse2">
                      Add Relay
                    </a>
                  </div>
                  <div id="collapse2" class="accordion-body collapse">
                    <div class="accordion-inner">
                      <form class="form-horizontal span4" action="/add_relay" method="POST">  
                          <fieldset>  
                            <div class="control-group">
                                <label for="RelayNumber" class="control-label">Relay Number:</label>

                                <div class="controls">
                                    <input type="text" id="RelayNumber" name="RelayNumber"/>                            
                                </div>
                            </div>  
                            <div class="control-group">
                                <label for="Runners" class="control-label">Runners:</label>

                                <div class="controls">
                                    <select multiple="multiple" name="Runners"> 
                                      %for runner in runners:
                                      <option>{{runner['bib_no']}}</option>
                                      %end                                      
                                    </select>
                                </div>
                            </div>
                            <div class="form-actions">
                              <input type="submit" class="img-rounded btn btn-medium btn-primary btn-start" value="Save" />
                              <span id="cancel_form" class="img-rounded btn btn-medium btn-primary btn-stop">Cancel</span>
                            </div>      
                          </fieldset>
                        </form>
                    </div>
                  </div>
                </div>
                %end
                %if(len(relays)>0):
                <div class="accordion-group">
                  <div class="accordion-heading">
                    <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion1" href="#collapse3">
                      Show Relays
                    </a>
                  </div>
                  <div id="collapse3" class="accordion-body collapse">
                    <div class="accordion-inner">
                      <table class="table table-bordered"> 
                        <thead >
                          <tr >
                            <th style="width: 20%">Relay Number</th>
                            <th>Bib Number</th>                            
                          </tr>
                        </thead>
                        <tbody>
                        %for relay in relays:
                        <tr >
                          <td style="width: 15%">
                            {{relay['relay_no']}}
                          </td>
                          <td>
                            %for runner in relay['relay_runners'][0:1]:
                            {{runner}}
                            %for runner in relay['relay_runners'][1:]:
                            , {{runner}} 
                            %end
                            %end                              
                          </td>                           
                        </tr>
                        %end                                          
                        </tbody>  
                      </table> 
                    </div>
                  </div>
                </div>
                %end
                %if(len(runners)>0):
                <div class="accordion-group">
                  <div class="accordion-heading">
                    <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion1" href="#collapse4">
                      Show Runners
                    </a>
                  </div>
                  <div id="collapse4" class="accordion-body collapse">
                    <div class="accordion-inner">
                      <table class="table table-bordered"> 
                        <thead class=>
                          <tr >
                            <th style="width: 15%">Bib Number</th>
                            <th>Name</th>                            
                          </tr>
                        </thead>
                        <tbody>
                        %for runner in runners:
                        <tr >
                          <td style="width: 15%">
                            {{runner['bib_no']}}
                          </td>
                          <td>
                            {{runner['name']}}   
                          </td>                           
                        </tr>                  
                        %end                   
                        </tbody>  
                      </table> 
                    </div>
                  </div>
                </div>
                %end
              </div>                  
          <hr>      
        </div> <!-- /container -->

  <script type="text/javascript" src="static/jquery.js"></script>
  <script type="text/javascript" src="static/bootstrap.min.js"></script>
  <script type="text/javascript">
      $('#cancel_form').click(function(){ 
        $(this).closest('form').find("input[type=text], textarea").val("");
      });               
  </script>
  </body>

</html>
