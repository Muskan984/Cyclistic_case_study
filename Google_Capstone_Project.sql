---------------------------Combine All Datasets------------------------
WITH TripData AS
(SELECT * FROM [dbo].['202004-divvy-tripdata$']
UNION ALL
SELECT * FROM [dbo].['202005-divvy-tripdata$']
UNION ALL
SELECT * FROM [dbo].['202006-divvy-tripdata$']
UNION ALL
SELECT * FROM [dbo].['202007-divvy-tripdata$']
UNION ALL
SELECT * FROM [dbo].['202008-divvy-tripdata$']
UNION ALL
SELECT * FROM [dbo].['202009-divvy-tripdata$']
UNION ALL
SELECT * FROM [dbo].['202010-divvy-tripdata$']
UNION ALL
SELECT * FROM [dbo].['202011-divvy-tripdata$']
UNION ALL
SELECT * FROM [dbo].['202012-divvy-tripdata$']
UNION ALL
SELECT * FROM [dbo].['202101-divvy-tripdata$']
UNION ALL
SELECT * FROM [dbo].['202102-divvy-tripdata$']
UNION ALL
SELECT * FROM [dbo].['202103-divvy-tripdata$']),

-------------------------------------------- Remove Test Trip Data---------------------------------------
No_Test_Data As
(Select * From TripData where [start_station_name] Not like '%test%'),

-------------------------------------------- Add Columns for Trip duration and weekdays--------------------
Trip_duration_data As
(SELECT *, DATEDIFF(MINUTE,[started_at],[ended_at]) as trip_duration,
	Case When convert(varchar(20),DATEPART(weekday, [started_at])) = 1 then 'Sunday'
		 When convert(varchar(20),DATEPART(weekday, [started_at])) = 2 then 'Monday'
		 When convert(varchar(20),DATEPART(weekday, [started_at])) = 3 then 'Tuesday'
		 When convert(varchar(20),DATEPART(weekday, [started_at])) = 4 then 'Wednesday'
		 When convert(varchar(20),DATEPART(weekday, [started_at])) = 5 then 'Thursday'
		 When convert(varchar(20),DATEPART(weekday, [started_at])) = 6 then 'Friday'
		 Else 'Saturday'
	End as day_of_week From No_Test_Data),

-------------------------------------------data cleaning---------------------------------------
Bike_Trip_data As
(Select * from Trip_duration_data Where trip_duration > 0)

Select member_casual, day_of_week, DATEPART(MONTH,started_at) as Month, rideable_type, Count(ride_id) as Total_trips, Sum(Trip_duration) as Total_Trip_duration
From Bike_Trip_data
Group by member_casual, day_of_week, DATEPART(MONTH,started_at), rideable_type;

