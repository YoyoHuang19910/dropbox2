/*
���˵����

1.����SQL Server��һ�����÷��������д˽ű��󣬽���SQL Server�ġ��ɱ����-����-����ֵ������������һ������ Fn_NextSnowId

2.���ɵ�ID = ʱ��� + WokerId + �����
	ʱ��� = ��ǰʱ��������뵥λ�� - 1582136402000
	WorkerId = {����ֵ}
	����� = 5 �� 2^SeqBigLength-1 ֮�������

3.���÷�����
	���磺select dbo.Fn_NextSnowId(rand())

*/
CREATE function dbo.Fn_NextSnowId
(
	@RandomSeed float -- ����ID�ĺ�������Ҫ��һ����������ڵ���ʱ������ϵͳ���� rand() ����
)
returns bigint
as
begin
	declare @CurrentTime bigint
	declare @TimeTick bigint
	declare @WorkerId int
	declare @WorkerIdBigLength int
	declare @SeqBigLength int

	-- Begin: ��������Ҫ��ʼ���Ĳ�������ȷ�� @WorkerIdBigLength �� @SeqBigLength ������ֵ������Ӧ�ó�����ͬ
	set @WorkerId = 1 -- ���ֵ 2^@WorkerIdBigLength-1
	set @WorkerIdBigLength = 4 -- @WorkerIdBigLength+@SeqBigLength<23
	set @SeqBigLength = 8	-- ���鲻С��6
	-- End

	-- ��ǰʱ��������뵥λ��
	set @CurrentTime = CONVERT(BIGINT,DATEDIFF(MI,'1970-01-01 00:00:00.000', GETUTCDATE())) * 60000 + DATEPART(S,GETUTCDATE()) * 1000 + DATEPART(MS, GETUTCDATE())

	-- �õ�ǰʱ�����ȥ����ʱ�䣬�ó�ID��ʱ����
	set @TimeTick=@CurrentTime-1582136402000 

	-- ����ID
	-- ѩ��ID�������� = 5��2^SeqBigLength-1֮���������� (5 + round((POWER(2, @SeqBigLength)-1) * rand(), 0)
	return @TimeTick * POWER(2, @WorkerIdBigLength + @SeqBigLength) + @WorkerId * POWER(2, @SeqBigLength) + (5 + round((POWER(2, @SeqBigLength)-1) * @RandomSeed, 0))
end
GO


