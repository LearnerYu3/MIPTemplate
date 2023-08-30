BEGIN{
	timeshift = 1;
	dataNames[0] = 0;
}
/Subject/{       #识别每个文件开始的位置，并重置变量的值
    time = 0;
    obj = 0;
}

#把name按 "/" 划分存储在数组 arr1 中
function split1(name){
	split(name, arr1, "/");
}
function split2(name){
	split(name, arr2, ".");
}

function AddName(names, namelist, name){
	if (names[name] != 1)
	{
		#name[0]记录文件类别数量， namelist记录文件名
		names[name] = 1; 
		namelist[names[0]] = name; 
		names[0]++;
	}
}

/julia src/{
    dataname = $3;
    split1(dataname);
    name = arr1[3];
    split2(name);
    name = arr2[1];
}

/Total \(root\+branch\&cut\)/{
    time = $4;
}

/objective_value\(model\)/{
    obj = $3;
}

/PS:/{    #识别一个文档结束的位置
	AddName(dataNames, dataNameList, name);
    
    times[name] = time;
    objs[name] = obj;
}

END{
# 统计各组数据的信息-----------------------

    sgmtime = 1;

    for( i = 0; i < dataNames[0]; i++ ) {
        name = dataNameList[i];
        sgmtime *= (times[name] + timeshift)^(1/dataNames[0])
    }
    sgmtime -= 1;

    printf "%8-s|%8s|%8s\n", "Name", "Time", "Obj";
    for( i = 1; i <= 10; i++ ) {
        name = "pmed"i;
        printf "%8-s|%8.2f|%8.2f\n", name, times[name], objs[name];
    }
    printf "%8-s|%8.2f|%s\n", "Avg", sgmtime, "";

    # latex table
	print "\\begin{table}";
	print "\\small";
	print "\\addtolength{\\tabcolsep}{-3pt}";
	print "\\centering";
	print "\\caption{Pmed} \\vspace{8pt}";
	print "\\begin{tabular}{|l|c|c|}";
	print "\\hline";
	print "\\texttt{Name} & \\texttt{T} & \\texttt{Obj}  \\\\";
	print "\\hline";
    for( i = 1; i <= 10; i++)
    {
        name = "pmed"i;
        printf "%s & %.2f & %.2f \\\\ \n", name, times[name], objs[name];
    }
    printf "%s & %.2f &  \\\\ \n", "Ave", sgmtime;
	print "\\hline";
	print "\\end{tabular}";
	print "\\end{table}";

}
