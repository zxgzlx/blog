/*
 * @Description: In User Settings Edit
 * @Author: your name
 * @Date: 2019-10-23 00:01:20
 * @LastEditTime: 2019-10-23 00:08:31
 * @LastEditors: Please set LastEditors
 */
let date = new Date();
//当前是哪一年
let year = date.getFullYear();
//当前是哪个月，注意这里的月是从0开始计数的
let month = date.getMonth();

//当前月的第一天的日期
let firstDay = new Date(year,month,1);
//第一天是星期几
let weekday = firstDay.getDay();

//求当前月一共有多少天
//new Date(year,month+1,0) ： month+1是下一个月，day为0代表的是上一个月的最后一天，即我们所需的当前月的最后一天。
//getDate（）则返回这个日期对象是一个月中的第几天，我们由最后一天得知这个月一共有多少天
let days = new Date(year,month+1,0).getDate();

let res = "";
//输出第一天之前的空格
for(let i=0;i<weekday;i++){
    res+="  ";
}

for(let j=1;j<=days ;j++){
    res += j+" ";
    weekday++;

    //如果是周日则换行
    if(weekday%7 == 0){
           weekday = 0;
           res += '\n';
    }
}

console.log("打印日历res: \n", res);