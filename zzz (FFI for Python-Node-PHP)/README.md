# idgenerator

## FFI ����

Pyton��node.js��PHP �ȿ���ͨ�� FFI ��ʽ���ö�̬������ ID��

��ͬ����ϵͳ�����ò�ͬ�Ķ�̬�⡣

## �ӿڷ���˵��

��1����**ȫ��** ��ʼ����Ӧ�ó�������ʱִ��һ�Σ���
```
// ���ò���
// workerId
// workerIdBitLength��Ӱ�� workerId���ֵ��һ������6��֧�ֵ� WorkerId ���ֵΪ2^workerIdBitLength-1
// seqBitLength��һ��ֻҪ����6.
extern "C" void SetOptions(int workerId, int workerIdBitLength, int seqBitLength) 
```

��2��������ID��
```
// ����ID
extern "C" long NextId() 
```

