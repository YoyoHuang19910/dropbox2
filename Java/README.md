
## ���л���

JDK 1.8+

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


## options Ĭ��ֵ��˵��

�ο�Դ�룺/contract/IdGeneratorOptions.java

