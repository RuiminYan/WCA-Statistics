# WCA-Statistics
Some interesting WCA statistics 一些WCA趣味数据统计

## Note
After importing wca_export.sql, you should: 
1) change Charset/Collation to utf8mb4_unicode_ci.
2) Add id column
```
ALTER TABLE Results ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY;
```

## Prompt
使用Windows11, 用户名CubeRoot. 用MySQL Workbench 8.0. 数据库wca_export, 是世界魔方协会的官方数据库，有

表格competitions的列名有：id, name, cityName, countryId, information, year, month, day, endMonth, endDay, cancelled, eventSpecs, wcaDelegate, organiser, venue, venueAddress, venueDetails, external_website, cellName, latitude, longitude. 其中year, month, day表示比赛开始的年, 月, 日, endMonth, endDay表示比赛结束的月, 日

表格results的列名有：competitionId, eventId, roundTypeId, pos, best, average, personName, personId, personCountryId, formatId, value1, value2, value3, value4, value5, regionalSingleRecord, regionalAverageRecord.

eventId取值为333, 222, 444, 555, 666, 777, 333bf, 333fm, 333oh, clock, minx, pyram, skewb, sq1, 444bf, 555bf, 333mbf, 333ft, magic, mmagic, 333mbo，分别表示三阶魔方，二阶魔方，四阶魔方，五阶魔方，六阶魔方，七阶魔方，三盲，FMC，单手，魔表，五魔，斜转，SQ1，四盲，五盲，多盲，脚拧，八板，十二板，旧多盲

轮次roundTypeId取值为1或d,2或e,3或g,f或b或c, 分别表示初赛，复赛，半决赛，决赛. 还有0表示资格轮次, 但这个很多年前的比赛才采用的，目前比赛已弃用.

输出表的表头有NULL AS flag, personName, value, NULL AS nothing, date, name, value1, value2, value3, value4, value5, personId, personCountryId.



The format "multi" is for old and new multi-blind, encoding the time as well as the number of cubes attempted and solved. This is a decimal value, which can be interpreted ("decoded") as follows:

eventId="333mbf", 均使用333mbf格式

由于历史遗留问题，在eventId="333mbo"中，每一行中value1~3可能既有333mbf还有333mbo的格式，在计算平均的时候，需要先将333mbf转化为333mbo格式，然后再算. 给出完整代码.
注意：eventId只使用"333mbo";
333mbf转换为333mbo时需要用的公式：SS = DD - MM, AA = 99 - DD + MM * 2;
333mbo格式为1SSAATTTTT，也就是说共10位，而且最高位一定是1;
333mbf格式为DDTTTTTMM，也就是说共9位

      333mbo: 1SSAATTTTT
             solved        = 99 - SS
             attempted     = AA
             timeInSeconds = TTTTT (99999 means unknown)
        333mbf: DDTTTTTMM
             difference    = 99 - DD
             timeInSeconds = TTTTT (99999 means unknown)
             missed        = MM
             solved        = difference + missed
             attempted     = solved + missed

    In order to encode data, use the following procedure:

             solved        = # cubes solved
             attempted     = # cubes attempted
             missed        = # cubes missed = attempted - solved
             DD            = 99 - (solved - missed)
             TTTTT         = solve time in seconds
             MM            = missed




## Events
```
IN ('333', '222', '444', '555', '666', '777', '333bf', '333fm', '333oh', 'clock', 'minx', 'pyram', 'skewb', 'sq1', '444bf', '555bf', '333mbf', '333ft', 'magic', 'mmagic', '333mbo')
```

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
=IF(D4=-1, "DNF",
   IF(D4=-2, "DNS",
      IF(D4=0, "",
         IF(D4 <= 999999, 
            IF(D4 < 6000, 
               TEXT(D4 / 100, "0.00"), 
               TEXT(INT(D4 / 6000), "0") & ":" & TEXT(MOD(INT(D4 / 100), 60), "00") & "." & TEXT(MOD(D4, 100), "00")
            ),
            IF(D4 < 1000000000, 
               LET(
                  DD, LEFT(D4, 2),
                  TTTTT, MID(D4, 3, 5),
                  MM, RIGHT(D4, 2),
                  solved, 99 - DD + MM,
                  missed, MM,
                  attempted, solved + missed,
                  time, IF(TTTTT = "99999", "?:??:??", IF(INT(TTTTT / 3600) = 0, TEXT(MOD(INT(TTTTT / 60), 60), "0") & ":" & TEXT(MOD(TTTTT, 60), "00"), TEXT(INT(TTTTT / 3600), "0") & ":" & TEXT(MOD(INT(TTTTT / 60), 60), "00") & ":" & TEXT(MOD(TTTTT, 60), "00"))),
                  solved & "/" & attempted & " " & time
               ),
               LET(
                  truncated, RIGHT(D4, 9),
                  SS, MID(truncated, 1, 2),
                  AA, MID(truncated, 3, 2),
                  TTTTT, RIGHT(truncated, 5),
                  solved, 99 - SS,
                  attempted, VALUE(AA),
                  time, IF(TTTTT = "99999", "?:??:??", IF(INT(TTTTT / 3600) = 0, TEXT(MOD(INT(TTTTT / 60), 60), "0") & ":" & TEXT(MOD(TTTTT, 60), "00"), TEXT(INT(TTTTT / 3600), "0") & ":" & TEXT(MOD(INT(TTTTT / 60), 60), "00") & ":" & TEXT(MOD(TTTTT, 60), "00"))),
                  solved & "/" & attempted & " " & time
               )
            )
         )
      )
   )
)
```
