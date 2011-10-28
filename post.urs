functor Make (M:sig
                  con unpost::{Type}
                  constraint [Id, Speaker, Description, Date] ~ unpost
                  table tab:(unpost ++ [Id = int, Speaker = string,
                                        Description = string, Date = time])
              end):sig
    type t
    sequence nTalks
    val create :  -> transaction t                         
end
