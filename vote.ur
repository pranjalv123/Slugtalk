style voteButton
style voteNum

functor Make (M:sig
                  con unvote::{Type}
                  constraint [Id, Votes] ~ unvote
                  table tab:(unvote ++ [Votes = int, Id = int])
             end) = struct
    open M
    type t = {VotesSrc : source int, Id : int}

    fun create id : transaction t =
        v <- oneRowE1(SELECT (tab.Votes) FROM tab WHERE tab.Id = {[id]});
        sv <- (source v);
        return {VotesSrc = sv, Id = id}
        
    fun votebutton t : xbody =
        let
            val k = t.Id
            fun vote () : transaction int =
                dml (UPDATE tab SET Votes=Votes + 1 WHERE Id={[k]});
                v <- oneOrNoRows (SELECT * FROM tab WHERE tab.Id={[k]});
                case v of
                    None => return 0
                  | Some a => return a.Tab.Votes
            val up_but = bless "http://localhost/up-arrow.png"
        in
            <xml>
              <img class={voteButton} onclick={n <- rpc (vote ()); set t.VotesSrc n} src={up_but}/>
              <div class={voteNum}>
                <dyn signal={v <- signal t.VotesSrc; return <xml>{[v]}</xml>}/>
              </div>
            </xml>
        end
end
