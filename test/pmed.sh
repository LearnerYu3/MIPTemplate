# !/bin/bash

# 给定存放输出文件的文件夹
dir=PmedResult

if [ ! -d $dir ]
then
    mkdir $dir
fi

# 执行程序
prog=src/pmed/pmed.jl

for(( i=1; i<=10; i++ ))
do
    workname=pmed$i
    echo bsub -J $workname -q batch -R "span[ptile=1]" -n 1 -e $dir/${workname}.err -o $dir/${workname}.out "julia $prog data/pmed/$workname.txt "
    # 提交任务命令
    bsub -J $workname -q batch -R "span[ptile=1]" -n 1 -e $dir/${workname}.err -o $dir/${workname}.out "julia $prog data/pmed/$workname.txt "
done

# the second way

# File=test/pmed.test
# dir=PmedResult

# if [ ! -d $dir ]
# then
#     mkdir $dir
# fi

# prog=src/pmed/pmed.jl

# if [ -f $File ]
# then
#     cat $File | while read line
# do
#     temp=${line#*pmed/}
#     workname=${temp%*.txt}
#     echo bsub -J $workname -q batch -R "span[ptile=1]" -n 1 -e $dir/${workname}.err -o $dir/${workname}.out "julia $prog $line "
#     bsub -J $workname -q batch -R "span[ptile=1]" -n 1 -e $dir/${workname}.err -o $dir/${workname}.out "julia $prog $line "
# done
# else
#    echo "File $File not exist."
# fi
