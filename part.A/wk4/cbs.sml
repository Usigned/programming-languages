val cbs: (int -> unit) list ref = ref []

fun reg f = cbs := f :: (!cbs)

fun triger i = 
    let
        fun calls fs = 
            case fs of 
                [] => () |
                f :: fs' => (f i; calls fs')
    in 
        calls (!cbs)
    end

val counter = ref 0;

reg (fn _ => (counter := 1 + (!counter)))


fun regPrintWhenPressed i = 
    reg (fn j => if i=j then print("yeah") else ())

regPrintWhenPressed 1;

regPrintWhenPressed 2;

regPrintWhenPressed 3;


triger 1;

triger 2;

triger 3;

triger 4;

!counter