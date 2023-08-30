# 利用 JuMP 库建模并实现 Benders 分解

## p-median Problem

* $`d_{ij}`$ : 表示客户 $`i`$ 到设施 $`j`$ 的距离
* $`p`$ : 开放设施的数量
* $`n`$ : 客户数量
* $`m`$ : 可选的设施数量

```math
\begin{align}
\min & \sum_{i = 1}^n \sum_{j = 1}^m d_{ij} x_{ij} &  \\
\text{s.t.} & \sum_{j=1}^m x_{ij} = 1, & \forall \, i \in [n] \\
 & x_{ij} \leq y_j, & \forall \, i \in [n], \, j \in [m], \\
 & \sum_{j = 1}^m y_j = p, & \\
 & y_j \in \{0, 1 \}, & \forall \, j \in [m], \\
 & x_{ij} \in \{ 0, 1 \}, & \forall \, i \in [n], \, j \in [m].
\end{align}
```

对于每个用户 $`i`$，引入符号 $`\sigma_i(1), \ldots, \sigma_i(m)`$，使得

```math
d_{i \sigma_i(1)} \leq d_{i \sigma_i(2)} \leq \cdots \leq d_{i \sigma_i(m)}.
```

则其 Benders 分解模型可写为：

```math
\begin{align}
\min & \sum_{i = 1}^n \theta_i &  \\
\text{s.t.} & \sum_{j = 1}^m y_j = p, & \\
 & \theta_i \geq d_{i \sigma_i(k)} - \sum_{j=1}^{k -1} (d_{i \sigma_i(k)} - d_{i \sigma_i(j)}) y_j, & \forall \, i \in [n], \, k \in [m],  \\
 & y_j \in \{0, 1 \}, & \forall \, j \in [m], \\
 & d_{i \sigma_i(1)} \leq \theta_i \leq d_{i \sigma_i(m)}, & \forall \, i \in [n].
\end{align}
```

对于约束 (9) 可以利用求解器 `Callback` 调用实现动态添加约束的行为，即利用 branch-and-cut 框架实现。事实上在每次判断割违反的过程中，对于每个用户 $`i`$ 可只判断最可能违反的约束是否违反，即寻找 $`K_i \in [m]`$, 
```math
    K_i = \argmin_{k \in [m]} \left \{ \sum_{j=1}^k y_j \geq 1  \right \}
```

具体 `julia` 代码可查看 `src/pmed` 下代码文件

## 配置环境
如果本地没有 julia，可以到官网下载。然后可以按如下方式配置使用环境
* [配置 JuMP 使用环境](https://learneryu3.github.io/2022/04/01/use-JuMP/)

关于 `JuMP` 的更多的细节可以参见 https://jump.dev/JuMP.jl/stable/
## 执行代码

在当前文件夹 (`Template`) 下执行
```shell
julia src/pmed/pmed.jl [数据文件名]
# 例
julia src/pmed/pmed.jl data/pmed/pmed1.txt
```

## 集群测试

当算例数较多时，我们在本地运行程序依次测试的行为会造成大量的时间消耗，且很难在可观的时间内得到数值结果。
因此我们可以选择提交作业到集群进行并行测试。
在当前文件夹下执行如下命令可将作业提交到集群（小集群）
```shell
./test/pmed.sh
```

## 统计输出信息
在测试结束之后，我们可以利用统计工具（如：`awk`）统计我们需要的信息。可在当前文件夹下执行如下命令
```shell
awk -f stats/pmed.awk PmedResult/*.out
```
`PmedResult` 是存放输出文件的文件夹。你可以在 `pmed.sh` 中设置自己用于存放结果的文件夹名，此处仅作示例

## Reference
Cristian D.-M., Zacharie A., Sourour E.(2023),
An efficient benders decomposition for the p-median problem,
European Journal of Operational Research,
308, 84-96,
https://doi.org/10.1016/j.ejor.2022.11.033.
(https://www.sciencedirect.com/science/article/pii/S0377221722008864)
