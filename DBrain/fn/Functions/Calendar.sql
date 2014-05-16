create function fn.Calendar (@DateFrom date, @DateTo date)
returns @Calendar table (
	DateKey int,
	FullDate date,
	[DayOfWeek] smallint,
	[DayOfMonth] smallint,
	[DayOfYear] smallint,
	[DayName] varchar(9),
	DayNameAbbrev char(3),
	[Weekday] bit,
	WeekOfYear smallint,
	WeekBeginDate date,
	WeekBeginDateKey int,
	MonthNumber smallint,
	[MonthName] varchar(9),
	MonthNameAbbrev char(3),
	[Quarter] smallint,
	[Year] smallint,
	YearMonth int,
	FiscalMonthNumber smallint,
	FiscalQuarter smallint,
	FiscalYear smallint,
	LastDayInMonth bit,
	SameDayLastYear date
)
as
begin

	;with Calendar_cte as (
	select
		convert(varchar(8), @DateFrom, 112) as 'DateKey',
		convert(date, @DateFrom) as 'FullDate',
		datepart(weekday, @DateFrom) as 'DayOfWeek',
		datepart(dd, @DateFrom) as 'DayOfMonth',
		datepart(dayofyear, @DateFrom) as 'DayOfYear',
		datename(weekday, @DateFrom) as 'DayName',
		left(datename(weekday, @DateFrom), 3) as 'DayNameAbbrev',
		iif(datepart(weekday, @DateFrom) in (2,3,4,5,6), 1, 0) as 'Weekday',
		datepart(ww, @DateFrom) as 'WeekOfYear',
		iif(datepart(weekday, @DateFrom) = 2, convert(date, @DateFrom), dateadd(dd, -datepart(weekday, @DateFrom), convert(date, @DateFrom))) as 'WeekBeginDate',
		iif(datepart(weekday, @DateFrom) = 2, convert(varchar(8), @DateFrom, 112), convert(varchar(8), dateadd(dd, -datepart(weekday, @DateFrom), convert(date, @DateFrom)), 112)) as WeekBeginDateKey,
		datepart(mm, @DateFrom) as 'MonthNumber',
		datename(mm, @DateFrom) as 'MonthName',
		left(datename(mm, @DateFrom),3) as 'MonthNameAbbrev',
		datepart(qq, @DateFrom) as 'Quarter',
		datepart(yyyy, @DateFrom) as 'Year',
		convert(int, left(convert(varchar(8), @DateFrom, 112), 6)) as 'YearMonth',
		iif(datepart(mm, @DateFrom) in (4,5,6,7,8,9,10,11,12), datepart(mm, @DateFrom) - 3, datepart(mm, @DateFrom) + 9) as 'FiscalMonthNumber',
		iif(datepart(qq, @DateFrom) > 1, datepart(qq, @DateFrom) - 1, 4) as 'FiscalQuarter',
		iif(datepart(mm, @DateFrom) not in (1,2,3), datepart(yyyy, @DateFrom), datepart(yyyy, @DateFrom) - 1) as 'FiscalYear',
		iif(datepart(dd, dateadd(dd, 1, @DateFrom)) = 1, 1, 0) as 'LastDayInMonth',
		dateadd(yyyy, -1, convert(date, @DateFrom)) as SameDayLastYear

	union all

	select
		convert(varchar(8), dateadd(dd, 1, FullDate), 112),
		dateadd(dd, 1, FullDate),
		datepart(weekday, dateadd(dd, 1, FullDate)),
		datepart(dd, dateadd(dd, 1, FullDate)),
		datepart(dayofyear, dateadd(dd, 1, FullDate)),
		datename(weekday, dateadd(dd, 1, FullDate)),
		left(datename(weekday, dateadd(dd, 1, FullDate)), 3),
		iif(datepart(weekday, dateadd(dd, 1, FullDate)) in (2,3,4,5,6), 1, 0),
		datepart(ww, dateadd(dd, 1, FullDate)) as WeekOfYear,
		case
			when datepart(weekday, dateadd(dd, 1, FullDate)) = 2 then dateadd(dd, 1, FullDate)
			when datepart(weekday, dateadd(dd, 1, FullDate)) = 3 then FullDate
			when datepart(weekday, dateadd(dd, 1, FullDate)) = 4 then dateadd(dd, -1, FullDate)
			when datepart(weekday, dateadd(dd, 1, FullDate)) = 5 then dateadd(dd, -2, FullDate)
			when datepart(weekday, dateadd(dd, 1, FullDate)) = 6 then dateadd(dd, -3, FullDate)
			when datepart(weekday, dateadd(dd, 1, FullDate)) = 7 then dateadd(dd, -4, FullDate)
			when datepart(weekday, dateadd(dd, 1, FullDate)) = 1 then dateadd(dd, -5, FullDate)
			else null
		end,
		case
			when datepart(weekday, dateadd(dd, 1, FullDate)) = 2 then convert(varchar(8), dateadd(dd, 1, FullDate), 112)
			when datepart(weekday, dateadd(dd, 1, FullDate)) = 3 then convert(varchar(8), FullDate, 112)
			when datepart(weekday, dateadd(dd, 1, FullDate)) = 4 then convert(varchar(8), dateadd(dd, -1, FullDate), 112)
			when datepart(weekday, dateadd(dd, 1, FullDate)) = 5 then convert(varchar(8), dateadd(dd, -2, FullDate), 112)
			when datepart(weekday, dateadd(dd, 1, FullDate)) = 6 then convert(varchar(8), dateadd(dd, -3, FullDate), 112)
			when datepart(weekday, dateadd(dd, 1, FullDate)) = 7 then convert(varchar(8), dateadd(dd, -4, FullDate), 112)
			when datepart(weekday, dateadd(dd, 1, FullDate)) = 1 then convert(varchar(8), dateadd(dd, -5, FullDate), 112)
			else null
		end,
		datepart(mm, dateadd(dd, 1, FullDate)),
		datename(mm, dateadd(dd, 1, FullDate)),
		left(datename(mm, dateadd(dd, 1, FullDate)),3),
		datepart(qq, dateadd(dd, 1, FullDate)),
		datepart(yyyy, dateadd(dd, 1, FullDate)),
		convert(int, left(convert(varchar(8), dateadd(dd, 1, FullDate), 112), 6)),
		iif(datepart(mm, dateadd(dd, 1, FullDate)) in (4,5,6,7,8,9,10,11,12), datepart(mm, dateadd(dd, 1, FullDate)) - 3, datepart(mm, dateadd(dd, 1, FullDate)) + 9),
		iif(datepart(qq, dateadd(dd, 1, FullDate)) > 1, datepart(qq, dateadd(dd, 1, FullDate)) - 1, 4),
		iif(datepart(mm, dateadd(dd, 1, FullDate)) not in (1,2,3), datepart(yyyy, dateadd(dd, 1, FullDate)), datepart(yyyy, dateadd(dd, 1, FullDate)) - 1),
		iif(datepart(dd, dateadd(dd, 2, FullDate)) = 1, 1, 0),
		dateadd(yyyy, -1, dateadd(dd, 1, FullDate))
		from Calendar_cte
		where FullDate < @DateTo
	)

	insert @Calendar (
		DateKey,
		FullDate,
		[DayOfWeek],
		[DayOfMonth],
		[DayOfYear],
		[DayName],
		DayNameAbbrev,
		[Weekday] ,
		WeekOfYear,
		WeekBeginDate,
		WeekBeginDateKey,
		MonthNumber,
		[MonthName],
		MonthNameAbbrev,
		[Quarter],
		[Year],
		YearMonth,
		FiscalMonthNumber,
		FiscalQuarter,
		FiscalYear,
		LastDayInMonth,
		SameDayLastYear
	)
	select
		DateKey,
		FullDate,
		[DayOfWeek],
		[DayOfMonth],
		[DayOfYear],
		[DayName],
		DayNameAbbrev,
		[Weekday] ,
		WeekOfYear,
		WeekBeginDate,
		WeekBeginDateKey,
		MonthNumber,
		[MonthName],
		MonthNameAbbrev,
		[Quarter],
		[Year],
		YearMonth,
		FiscalMonthNumber,
		FiscalQuarter,
		FiscalYear,
		LastDayInMonth,
		SameDayLastYear
		from Calendar_cte
		option (maxrecursion 0)

	return

end