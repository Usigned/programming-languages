fun demo (z: int) =
    let
      val x = if z >0 then z else 34
      val y = x + z + 9
    in
      if x > y then x * 2 else y*y
    end

fun countup_from1(x: int) = 
  let
    fun count (from: int) = 
      if from = x
      then [from]
      else from :: count (from+1)
  in
    count(1)
  end

countup_from1(7)