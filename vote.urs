functor Make (M:sig
                  con unvote::{Type}
                  constraint [Id, Votes] ~ unvote
                  table tab:(unvote ++ [Votes = int, Id = int])
             end):sig
    type t
    val create : int -> transaction t
    val votebutton : t -> xbody
(*    val changeImage : url -> t -> transaction ()*)
                                  (* or put url in the static part/signature*)
end
