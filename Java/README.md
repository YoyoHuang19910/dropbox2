
## ���л���

JDK 1.8+

## ���� maven ��
```
<dependency>
	<groupId>com.github.yitter</groupId>
	<artifactId>yitter-idgenerator</artifactId>
	<version>1.0.2</version>
</dependency>
```

## ����ʾ��
```
// ȫ�ֳ�ʼ������WorkerId��Ĭ�����2^16-1������ʼ������ȫ��ֻ��һ�Σ��ұ����������ã�
IdGeneratorOptions options = new IdGeneratorOptions();
options.WorkerId = 1;
YitIdHelper.setIdGenerator(options);

// ��ʼ���Ժ󣬾Ϳ�������Ҫ�ĵط����÷�������ID��
long newId = YitIdHelper.nextId();

```
�������DI��ܼ��ɣ����Բο� YitIdHelper ȥ���� IdGenerator ���󣬱���ʹ��**����**ģʽ��


## options Ĭ��ֵ��˵��

�ο�Դ�룺/contract/IdGeneratorOptions.java

