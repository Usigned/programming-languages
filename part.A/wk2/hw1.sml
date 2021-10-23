fun is_older(date1: int * int * int, date2: int * int * int) = 
    if #1date1 = #1date2
    then 
        if #2date1 = #2date2
        then
            if #3date1 = #3date2
            then false
            else #3date1 < #3date2
        else #2date1 < #2date2
    else #1date1 < #1date2


fun number_in_month(dates: (int * int * int) list, month: int) = 
    if null(dates)
    then 0
    else
        if #2(hd(dates)) = month
        then 1 + number_in_month(tl(dates), month)
        else number_in_month(tl(dates), month)


fun number_in_months(dates: (int * int * int) list, months: int list) = 
    if null(months)
    then 0
    else number_in_month(dates, hd(months)) + number_in_months(dates, tl(months))


fun dates_in_month(dates: (int * int * int) list, month: int) =
    if null(dates)
    then []
    else
        if #2(hd(dates)) = month
        then hd(dates) :: dates_in_month(tl(dates), month)
        else dates_in_month(tl(dates), month)


fun dates_in_months(dates: (int * int * int) list, months: int list) = 
    if null(months)
    then []
    else dates_in_month(dates, hd(months)) @ dates_in_months(dates, tl(months))


fun get_nth(strings: string list, index: int) = 
    if index = 1
    then hd(strings)
    else get_nth(tl(strings), index-1)
    

fun date_to_string(date: int * int * int) = 
    let
        val month_strings = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        val month_string = get_nth(month_strings, #2date)
    in
        month_string ^ " " ^ Int.toString(#3date) ^ ", " ^ Int.toString(#1date)
    end


fun number_before_reaching_sum(sum: int, nums: int list) = 
    if null(nums) orelse sum <= hd(nums)
    then 0
    else 1 + number_before_reaching_sum(sum-hd(nums), tl(nums))


fun what_month(day: int) = 
    let
        val days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    in
        number_before_reaching_sum(day, days_in_month) + 1
    end


fun month_range(day1: int, day2: int) = 
    if day1 > day2
    then []
    else what_month(day1) :: month_range(day1+1, day2)


fun oldest(dates: (int * int * int) list) = 
    if null(dates)
    then NONE
    else 
        let
            val temp = oldest(tl(dates))
        in
            if isSome(temp) andalso is_older(valOf(temp), hd(dates))
            then temp
            else SOME(hd(dates))
        end