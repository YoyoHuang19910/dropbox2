# IdGenerator

## 介绍
用一种全新的雪花漂移算法（以下简称本算法），让ID更短、生成速度更快。
核心在于缩短ID长度的同时，还能保持极高并发处理量（50W/0.1s），且具有很强配置能力。

## 需求来源

1.作为架构设计的你，想要解决数据库主键唯一的问题，特别是在分布式系统多数据库的时候。

2.你希望这个主键是用最少的存储空间，索引速度更快，Select、Insert 和 Update 更迅速。

3.你要考虑在分库分表（合库合表）的时候，主键值可直接使用，并能反映业务时序。

4.如果这样的主键值太长，超过前端 JS Number 类型最大值，须把 Long 型转换为 String 型，你会觉得有点沮丧。

5.哪怕 Guid 能自增，但占用空间大，这也不是你想要的。

6.你希望系统能运行 100 年以上。


## 传统算法问题

1.生成的ID太长。

2.并发量不够。

3.不能解决时间回拨问题。

4.不支持后补生成前序ID。

5.依赖外部缓存系统。


## 新算法特点

1.整形数字，随时间单调递增（不一定连续），长度更短，用50年都不会超过 js Number类型最大值。（默认配置 WorkerId 是6bit，自增数是6bit）

2.速度更快，是传统雪花算法的2-5倍，0.1秒可生成50万个。（i7笔记本，默认算法配置6bit+6bit）

3.支持时间回拨处理。比如服务器时间回拨1秒，本算法能自动适应生成临界时间的唯一ID。

4.支持手工插入新ID。当业务需要在历史时间生成新ID时，用本算法的预留位能生成5000个每秒。

5.漂移时能外发通知事件。让调用方确切知道算法漂移记录，Log并发调用量。

6.不依赖任何外部缓存和数据库。（但 WorkerId 必须由外部指定）


## 性能数据
(参数：10位自增序列，1000次漂移最大值)
| 连续请求量 |  5K  |  5W  |  50W  |
|  ----  | ----  |  ----  | ----  |
| 传统雪花算法 | 0.0045s | 0.053s  |  0.556s |
| 雪花漂移算法  | 0.0015s | 0.012s | 0.11s |

## 效果

1.js Number 类型最大数值：9007199254740992，本算法在保持并发性能（5W+/0.01s）和最大64个 WorkerId（6bit）的同时，能用70年才到 js Number Max 值。

2.增加WorkerId位数到8bit（128节点）时，15年达到 js Number Max 值。

3.极致性能：500W/1s。

4.所有测试数据均基于8代低压i7计算。

## “我”是什么

1.本算法是一个类库，它基于 net standard2.0 基础库，不依赖任何第三方组件。

2.本算法不依赖任何外部数据系统（除了要被指定 WorkerId 之外）。


## 适用范围

1.小型、中型、大型需要全局唯一Id（不用Guid）的项目。

2.分布式项目。

3.不想将 Long 型转 String 给前端用的项目。（若前端支持bigint，则可不转类型）


## 如何处理时间回拨
1.当发生系统时间回拨的时候，算法采用过去时序的预留序数生成新的ID。

2.默认每秒生成100个（速度可调整）。

3.回拨生成的ID序号，默认靠前，也可以调整为靠后。

4.允许时间回拨至本算法预设基数（参数可调）。


## 能用多久

1.在默认配置下，ID可用 71000 年不重复。

2.在支持 1024 个工作节点时，ID可用 4480 年不重复。

3.在支持 4096 个工作节点时，ID可用 1120 年不重复。

4.以上所有工作节点，均拥有 50W/0.1s 最大处理速度。


## ★★集成建议★★

#### 常规集成

1.用单例模式调用。外部集成方使用更多的实例并行调用本算法，不会增加ID产出效能，因为本算法采用单线程模式生成ID。

2.指定唯一的 WorkerId。必须由外部系统确保 WorkerId 的全局唯一性，并赋值给本算法入口方法。

3.异常处理。本算法内部会抛出所有Exception，外部系统 catch 相关信息并做好应对处理，以免引发更大的系统崩溃。

4.认真理解 IdGeneratorOptions 的定义，这对集成和使用本算法有帮助。

5.订阅ID异步通知。IIdGenerator.GenIdActionAsync 是一个可以向外部系统异步发送ID生成消息的事件，它包含的消息类型有"漂移开始、漂移结束、时间回拨"
，具体参考 Yitter.IdGenTest 的 Program.cs 启动代码。不过订阅ID异步通知会有细微的性能损失。

6.同步或同步调用。你可在外部系统的异步（async标记）方法中调用本算法，同步调用同样没问题。

7.使用雪花漂移算法。虽然代码里包含了传统雪花算法的定义，并且你可以在入口处指定（Method=2）来启用传统算法，但仍建议你使用雪花漂移算法（Method=1，默认的），毕竟它具有更好的伸缩力和更高的性能。

8.轻易不要修改核心算法。本算法内部参数较多，逻辑较为复杂，在你尚未掌握核心逻辑时，请勿尝试修改核心代码且用于生产环境。


####  大型分布式集成

1.可扩大 WorkerIdBitLength 到最多20，支持 1,048,576 个节点，且不影响上述并发性能（50W/0.1s）。[算法支持]

2.采用中心化 IdGenerator 集群，给节点生成可用 Id 列表，存入 Redis 队列供节点消费。此时64个中心化节点数足够大型互联网项目使用。[需集成方扩展实现]

3.以上2条二选一即可，采用方法2一般是因为不想增加最终 ID 长度，但节点数超过64个。

4.任何加大 WorkerIdBitLength 或 SeqBitLength 的设置，都可能会增加 ID 的长度。

#### 配置变更

配置变更指是系统运行一段时间后，再变更运行参数（IdGeneratorOptions选项值），请注意：

1.最重要的一条原则是：StartTime **只能往前**（比老值更小、距离现在更远）赋值，原因是往后赋值极大可能产生相同的时间戳。[**不推荐**在系统运行之后调整 StartTime]

2.任何时候增加 WorkerIdBitLength 或 SeqBitLength，都是可以的，但是慎用 “减小”的操作，因为这可能导致在未来某天生成的 ID 与过去老配置时相同。[允许在系统运行之后**增加**任何一个 BitLength 值]

3.如果必须减小 WorkerIdBitLength 或 SeqBitLength 其中的一项，一定要满足一个条件：新的两个 BitLength 之和要大于 老的值之和。[**不推荐**在运行之后缩小任何一个 BitLength 值]

4.上述3条规则，并没有在本算法内做逻辑控制，集成方应根据上述规则做好影响评估，确认无误后，再实施配置变更。



## 代码示例

#### 运行环境

1..NET Standard 2.0+

#### 文件说明

1.SnowWorkerM1.cs 是雪花漂移算法。

2.SnowWorkerM2.cs 是传统雪花算法。

#### 雪花漂移算法
```
var options = new IdGeneratorOptions()
{
	// 设置WorkerId，默认最大2^16-1
	WorkerId = 1
};

var newId = new YitIdGenerator(options).NewLong();
```

#### 传统雪花算法
```
var options = new IdGeneratorOptions()
{
	Method = 2,  // 默认1
	WorkerId = 1
};

var newId = new YitIdGenerator(options).NewLong();
```

#### options说明
options参数（Method、StartTime除外）只支持漂移算法，不支持传统雪花算法。

```
public class IdGeneratorOptions
{
    /// <summary>
    /// 雪花计算方法
    /// （1|2）
    /// </summary>
    public short Method { get; set; } = 1;

    /// <summary>
    /// 开始时间（UTC格式）
    /// 不能超过当前系统时间
    /// </summary>
    public DateTime StartTime { get; set; } = DateTime.MinValue;

    /// <summary>
    /// 机器码
    /// 与 WorkerIdBitLength 有关系
    /// </summary>
    public ushort WorkerId { get; set; } = 0;

    /// <summary>
    /// 机器码位长
    /// 范围：2-21（要求：序列数位长+机器码位长不超过22）。
    /// 建议范围：6-12。
    /// </summary>
    public byte WorkerIdBitLength { get; set; } = 6;

    /// <summary>
    /// 序列数位长
    /// 范围：2-21（要求：序列数位长+机器码位长不超过22）。
    /// 建议范围：6-14。
    /// </summary>
    public byte SeqBitLength { get; set; } = 6;

    /// <summary>
    /// 最大序列数（含）
    /// （由SeqBitLength计算的最大值）
    /// </summary>
    public int MaxSeqNumber { get; set; } = 0;

    /// <summary>
    /// 最小序列数（含）
    /// 默认11，不小于5，不大于MaxSeqNumber-2
    /// </summary>
    public ushort MinSeqNumber { get; set; } = 11;

    /// <summary>
    /// 最大漂移次数（含），
    /// 默认2000，推荐范围500-10000（与计算能力有关）
    /// </summary>
    public int TopOverCostCount { get; set; } = 2000;
```

## 生成的ID

默认配置：
```
WorkerId = 6	(最多64个工作节点)
SeqBitLength = 6
```

ID示例（基于默认配置）：
```
129053495681099        (本算法运行1年)
387750301904971        (运行3年)
646093214093387        (运行5年)
1292658282840139       (运行10年)
9007199254740992       (js Number 最大值)
165399880288699493     (普通雪花算法生成的ID)
```
本算法生成的 ID 值，只有 js Number 最大值的 1%-10%，是普通雪花算法值的千分之一，而计算能力却超过普通雪花算法。


## 技术支持

开源地址：https://gitee.com/yitter/idgenerator

QQ群：646049993

即将推出Java、PHP等版本。


