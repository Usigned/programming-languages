(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)

fun all_except_option (target: string, xs: string list) = 
   case xs of
      [] => NONE |
      x :: xs' => 
         if same_string(target, x) then SOME xs' else
            case all_except_option(target, xs') of
               NONE => NONE |
               SOME xs' => SOME (x :: xs')



fun get_substitutions1 (lists, s) = 
   case lists of
      [] => [] |
      hd :: tl => 
         case all_except_option(s, hd) of 
            NONE => get_substitutions1(tl, s) |
            SOME lis => lis @ get_substitutions1(tl, s)


fun get_substitutions2 (lists, s) = 
   let
      fun aux (lists, s, res) = 
         case lists of
            [] => res |
            hd :: tl => 
               case all_except_option(s, hd) of 
                  NONE => aux(tl, s, res) |
                  SOME lis => aux(tl, s, res @ lis)
   in
      aux(lists, s, [])
   end


fun similar_names (lists, name) = 
   let
      val {first=firstName, middle=middelName, last=lastName} = name
      val subs = get_substitutions1(lists, firstName)
      fun aux (subs, name, res) = 
         case subs of 
            [] => name :: res |
            sub :: subs' => aux (subs', name, {first=sub, middle=middelName, last=lastName} :: res)
   in
      aux(subs, name, [])
   end


(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)


fun card_color (card) = 
   case card of 
      (Clubs, _) => Black |
      (Spades,  _) => Black |
      (Diamonds, _) => Red |
      (Hearts, _) => Red
   

fun card_value (card) =
   case card of
      (_, Num(i)) => i |
      (_, Ace) => 11 |
      _ => 10


fun remove_card (cs, c, e) = 
   case cs of
      (hd : card) :: cs' => if hd = c then cs' else hd :: remove_card(cs', c, e) |
      [] => raise e


fun all_same_color (cs) = 
   case cs of 
      [] => true |
      c :: [] => true |
      c1 :: (c2 :: cs') => card_color(c1) = card_color(c2) andalso all_same_color(c2 :: cs')


fun sum_cards (cs) =
   let
      fun aux (cs, res) = 
         case cs of 
            [] => res |
            c :: cs' => aux(cs', res + card_value(c))
   in
      aux (cs, 0)
   end


fun score (cs, goal) = 
   let
      val sum = sum_cards(cs)
      val diff = if sum > goal then 3 * (sum -goal) else (goal - sum)
   in 
      case all_same_color(cs) of
         true => diff div 2 |
         _ => diff 
   end


fun officiate (cards, moves, goal) = 
   let
      fun act (hands, moves, cards) = 
         if sum_cards(hands) > goal then hands
         else 
            case (moves, cards) of
               ([], _) => hands |
               (Draw :: _, []) => hands |
               (Draw:: moves', card :: cards') => act(card :: hands, moves', cards') |
               (Discard card :: moves', _) => act(remove_card(hands, card, IllegalMove), moves', cards)
   in
      score(act([], moves, cards), goal)
   end
