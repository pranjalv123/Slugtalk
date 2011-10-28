style inputs

structure U = OpenidUser.Make(struct
                                  con cols = [Nam = string]

                                  val sessionLifetime = 3600
                                  val afterLogout = bless "/main"
                                  val secureCookies = False
                                  val association = Openid.Stateful {AssociationType = Openid.HMAC_SHA256,
                                                                     AssociationSessionType = Openid.NoEncryption}
                                  val realm = Some "http://localhost:8080/"

                                  val creationState =
                                      n <- source "";
                                      return {Nam = n}
                                      
                                  fun render r = <xml>
                                    <tr> <th class={inputs}>Name:</th> <td><ctextbox source={r.Nam}/></td> </tr>
                                  </xml>

                                  fun ready _ = return True

                                  fun tabulate r =
                                      n <- signal r.Nam;
                                      return {Nam = n}

                                  fun choose _ r = return (OpenidUser.Success r)

                                  val formClass = inputs

                                  val fakeId = None

                                  structure CtlDisplay = OpenidUser.DefaultDisplay
                              end)


fun wrap title body =
    userStuff <- U.main wrap;
    return <xml><head>
      <title>{[title]}</title>
    </head><body>
      {userStuff.Status}<br/>
      {userStuff.Other.Xml}

      <h1>{[title]}</h1>

      {body}
    </body></xml>
        
style loginBox
    
fun loginpage mainpage =
    whoami <- U.current;
    u <- mainpage;
    case whoami of
        None =>  wrap "Login" <xml>I don't think you're logged in.</xml>
      | Some whoami => redirect u
fun loginbox mainpage : transaction xbody =
    whoami <- U.current;
    return (case whoami of 
               None =>  <xml>                 
                 <a class={loginBox} link={loginpage mainpage}> Log In </a>
               </xml>
             | Some whoami => <xml>
               <div class={loginBox}>
                 Logged in as <b>{[whoami]}</b>
               </div>
             </xml>)
                     
fun user unit =
    return (Some "foo")
