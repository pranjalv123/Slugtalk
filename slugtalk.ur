table talk : {Id : int, Title : string, Person : string, Description : string, Finished : bool, Votes : int}
                 PRIMARY KEY Id

structure V = Vote.Make (struct val tab = talk end)
             
type render = {Id : int, Title : string, Votes : int, VotesSrc : V.t, Description : string, Person : string}
sequence nTalks
                  
style talkEntry
style talkTitle
style talkDescription
style newTalkForm
style newTitleBox
style newPersonBox
style newDescriptionBox
style votesArea
         
fun take [a] (n:int) (ls:list a) : list a =
    case ls of
        [] => []
      | x :: ls' => case n of
                      | 0 => []
                      | n => x :: (take (n-1) ls')
                             
         
(* source returns a transaction source x*)
fun makesrc talk : transaction render =
    s <- V.create talk.Id;
    return {Id = talk.Id, Title = talk.Title, Votes = talk.Votes,
            VotesSrc = s, Description = talk.Description, Person = talk.Person}
    
fun process (ren : render) = 
    <xml>
      <div class={talkEntry}>
        <div class={votesArea}>
          {V.votebutton ren.VotesSrc}
        </div>
        <div class={talkTitle}> {[ren.Title]} </div>
        <div class={talkDescription}> {[ren.Description]} </div>                
      </div>
    </xml>
    
fun list ()  =
    List.mapQueryM
        (SELECT * FROM talk ORDER BY Talk.Votes DESC)
        (fn a => makesrc (a.Talk))
    (*query returns a type per table, we want the talk table records*)

fun newtalk f inp =
    id <- nextval nTalks;
    dml (INSERT INTO talk (Id, Title, Person, Description, Finished, Votes)
                             VALUES ({[id]}, {[inp.Title]}, {[inp.Person]},
                                 {[inp.Description]}, {[False]}, {[0]}));
    redirect (url (f ()))
                                                                              

fun talkForm f : transaction xbody =
    return
        <xml>
          <div class={newTalkForm}>
            <form>
              <div class={newTitleBox}>
                Title: <textbox{#Title}/><br/>
              </div>
              <div class={newPersonBox}>
                Speaker: <textbox{#Person}/><br/>
              </div>
              <div class={newDescriptionBox}>
                Description: <br/> <textarea{#Description}/><br/>
              </div>
              <submit action={newtalk f}/>
            </form>
          </div>
        </xml>
(*Use mapQueryM!*)            
fun main () =
    talks' <- list ();
    talks <- return talks';
    tf <- talkForm main;
    loginbox <- Auth.loginbox (return (bless "/main"));
    return <xml>
      <head>
        <link rel="stylesheet" type="text/css" href="http://localhost/style.css"/>
        <title> Slugtalks! </title>
      </head>
      <body>
        {loginbox}
        {tf}
        {List.mapX process talks}
      </body>
    </xml>
