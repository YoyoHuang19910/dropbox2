# idgenerator

## Go����
1.go 1.16

2. Ĭ�ϲ���GOROOT��ʽ���룬����޸�ΪGo-Modules


## Go����ʾ��
```
var yid = idgen.YitIdHelper{}
fmt.Println(yid.NextId())

// ���������Զ������
var options = contract.NewIdGeneratorOptions(1)
//options.WorkerIdBitLength = 6
//options.SeqBitLength = 6
//options.TopOverCostCount = 2000
//options.BaseTime = time.Date(2020, 2, 20, 2, 20, 2, 20, time.UTC).UnixNano() / 1e6
yid.SetIdGenerator(options)

```

