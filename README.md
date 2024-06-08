# WCA-Statistics
Some interesting WCA statistics 一些WCA趣味数据统计

## Events
333 222 444 555 666 777 333bf 333fm 333oh clock minx pyram skewb sq1 444bf 555bf 333mbf 333ft magic mmagic 333mbo

## Batch image link
```
=CONCATENATE("IMAGE(""", A2, """)")
```

## HTM*
```excel
=LEN(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(A2," ",""),"(",""),")",""),"'",""),"x",""),"y",""),"z",""),"2",""),"3",""))
```

## QTM*
```excel
=LEN(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(A2," ",""),"(",""),")",""),"'",""),"x",""),"y",""),"z",""),"2",""),"3","")) + (LEN(A2) - LEN(SUBSTITUTE(A2, "2", "")))
```

## result value to result
当值小于等于999999时，
=IF(A2=-1, "DNF",
   IF(A2=-2, "DNS",
      IF(A2=0, "",
         IF(A2 < 6000, 
            TEXT(A2 / 100, "0.00"), 
            TEXT(INT(A2 / 6000), "0") & ":" & TEXT(MOD(INT(A2 / 100), 60), "0") & "." & TEXT(MOD(A2, 100), "00")
         )
      )
   )
)

当值大于999999且小于999999999时，设该数被划分为DDTTTTTMM，取solved = 99 - DD  + MM, missed = MM, attempted = solved + missed, 输出文本格式"solved/attempted time"

当值大于等于999999999时，先丢去最高位, 然后将数被划分为SSAATTTTT, 取solved  = 99 - SS, attempted = AA, 输出文本格式"solved/attempted time"

其中time的定义如下:
当TTTTT=99999时，time = ?:??:??
当TTTTT不等于99999时, TTTTT表示秒数, time为将其转化小时:分钟:秒的时间, 注意当小时为0时，简化为分钟:秒

```excel
=IF(C4=-1, "DNF",
   IF(C4=-2, "DNS",
      IF(C4=0, "",
         IF(C4 <= 999999, 
            IF(C4 < 6000, 
               TEXT(C4 / 100, "0.00"), 
               TEXT(INT(C4 / 6000), "0") & ":" & TEXT(MOD(INT(C4 / 100), 60), "00") & "." & TEXT(MOD(C4, 100), "00")
            ),
            IF(C4 < 1000000000, 
               LET(
                  DD, LEFT(C4, 2),
                  TTTTT, MID(C4, 3, 5),
                  MM, RIGHT(C4, 2),
                  solved, 99 - DD + MM,
                  missed, MM,
                  attempted, solved + missed,
                  time, IF(TTTTT = 99999, "?:??:??", IF(INT(TTTTT / 3600) = 0, TEXT(MOD(INT(TTTTT / 60), 60), "0") & ":" & TEXT(MOD(TTTTT, 60), "00"), TEXT(INT(TTTTT / 3600), "0") & ":" & TEXT(MOD(INT(TTTTT / 60), 60), "00") & ":" & TEXT(MOD(TTTTT, 60), "00"))),
                  solved & "/" & attempted & " " & time
               ),
               LET(
                  truncated, RIGHT(C4, 9),
                  SS, MID(truncated, 1, 2),
                  AA, MID(truncated, 3, 2),
                  TTTTT, RIGHT(truncated, 5),
                  solved, 99 - SS,
                  attempted, VALUE(AA),
                  time, IF(TTTTT = 99999, "?:??:??", IF(INT(TTTTT / 3600) = 0, TEXT(MOD(INT(TTTTT / 60), 60), "0") & ":" & TEXT(MOD(TTTTT, 60), "00"), TEXT(INT(TTTTT / 3600), "0") & ":" & TEXT(MOD(INT(TTTTT / 60), 60), "00") & ":" & TEXT(MOD(TTTTT, 60), "00"))),
                  solved & "/" & attempted & " " & time
               )
            )
         )
      )
   )
)
```
