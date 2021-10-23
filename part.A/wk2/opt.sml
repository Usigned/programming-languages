fun fix_bad_max_1(xs : int list) = 
    if null xs
    then NONE
    else
        let
          val temp = fix_bad_max(tl xs)
        in
          if isSome(temp) andalso hd(xs) < valOf(temp)
          then temp 
          else SOME(hd(xs))
        end

fix_bad_max([1,2,3,4,5])

fun cleanup(xs: int list) = 
    if null(xs)
    then NONE
    else
        let
            fun nonEmpty(xs: int list) = 
                if null(tl(xs))
                then hd(xs)
                else
                    let
                        val temp = nonEmpty(tl(xs))
                    in
                        if temp > hd(xs)
                        then temp
                        else hd(xs)
                    end
        in
            SOME(nonEmpty(xs))
        end