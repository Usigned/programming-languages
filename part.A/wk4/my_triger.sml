(* event给定一个int *)

val cbs: (int -> unit) list ref = ref []

fun register f = cbs := f :: !(cbs)

fun triger i =
    let
        fun call fs = 
            case fs of 
                [] => () |
                f :: fs' => (f i; call fs')
    in
        call (!cbs)
    end

val timesTrigered = ref 0

register (fn _ => timesTrigered := (!timesTrigered) + 1)

fun printIfPressed i = 
    register (fn j => if i=j then print(Int.toString i ^ " is pressed\n") else ())

val _ = printIfPressed 1

val _ = printIfPressed 2

val _ = printIfPressed 3

val _ = printIfPressed 4

triger 1