# idgenerator

## ����ʾ����Rust��

��1����**ȫ��** ��ʼ����Ӧ�ó�������ʱִ��һ�Σ���
```
// ���� IdGeneratorOptions ���󣬹��캯������ WorkerId��
let mut options = IdGeneratorOptions::New(1);
// options.WorkerIdBitLength = 10; // WorkerIdBitLength Ĭ��ֵ6��֧�ֵ� WorkerId ���ֵΪ2^6-1���� WorkerId ����64�������ø���� WorkerIdBitLength
// ...... �����������òο� IdGeneratorOptions ���壬һ����˵��ֻҪ������ WorkerIdBitLength ������ WorkerId �����ֵ����

// �������������Ĳ����������������ö�������Ч����
YitIdHelper::SetIdGenerator(options);
// ���ϳ�ʼ������ֻ��ȫ��һ�Σ��ұ����ڵ�2��֮ǰ���á�
```

��2��������ID��
```
// ��ʼ���Ժ󣬼������κ���Ҫ����ID�ĵط����������·�����
long newId = YitIdHelper::NextId();
```


