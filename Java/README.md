
## ���л���

JDK 1.8

## ���� maven ��
```

```

## ����ʾ��
```
// ȫ�ֳ�ʼ������WorkerId��Ĭ�����2^16-1������ʼ������ȫ��ֻ��һ�Σ��ұ����������ã�
IdGeneratorOptions options = new IdGeneratorOptions();
options.WorkerId = 1;
IdHelper.setIdGenerator(options);

// ��ʼ���Ժ󣬾Ϳ�������Ҫ�ĵط����÷�������ID��
long newId = IdHelper.nextId();

```
�������DI��ܼ��ɣ����Բο� IdHelper ȥ���� IdGenerator ���󣬱���ʹ��**����**ģʽ��

## options˵��
```
/**
     * ѩ�����㷽��
     * ��1-Ư���㷨|2-��ͳ�㷨����Ĭ��1
     */
    public short Method = 1;

    /**
     * ��ʼʱ��
     * ���ܳ�����ǰϵͳʱ��
     */
    public long StartTime = 0;

    /**
     * �����룬�������ⲿϵͳ����
     * �� WorkerIdBitLength �й�ϵ
     */
    public short WorkerId = 0;

    /**
     * ������λ��
     * ��Χ��2-21��Ҫ��������λ��+������λ��������22����
     * ���鷶Χ��6-12��
     */
    public byte WorkerIdBitLength = 6;

    /**
     * ������λ��
     * ��Χ��2-21��Ҫ��������λ��+������λ��������22����
     * ���鷶Χ��6-14��
     */
    public byte SeqBitLength = 6;

    /**
     * ���������������
     * ����SeqBitLength��������ֵ��
     */
    public short MaxSeqNumber = 0;

    /**
     * ��С������������
     * Ĭ��11����С��5��������MaxSeqNumber-2
     */
    public short MinSeqNumber = 11;

    /**
     * ���Ư�ƴ���������
     * Ĭ��2000���Ƽ���Χ500-10000������������йأ�
     */
    public short TopOverCostCount = 2000;

```