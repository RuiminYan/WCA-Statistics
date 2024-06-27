/*
BAo5的方法如下：
如果5个value有超过2个≤0，则BAo5取为NULL
如果5个value有2个≤0，则BAo5取为剩下3个value的平均
如果5个value有1个≤0，则BAo5取为剩下4个value的和减去最大value,再除以3
如果5个value没有≤0，则BAo5取为5个value的和减去最大value, 再减去第二大value, 再除以3
*/
