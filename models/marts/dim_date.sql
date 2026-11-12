with days as (

    select dateadd(day, row_number() over (order by seq4()) - 1, '2016-01-01'::date) as date_day
    from table(generator(rowcount => 1096))

)

select
    date_day,
    year(date_day)                     as year_number,
    quarter(date_day)                  as quarter_number,
    month(date_day)                    as month_number,
    monthname(date_day)                as month_name,
    to_char(date_day, 'YYYY-MM')       as year_month,
    dayofweekiso(date_day)             as day_of_week_number,
    dayname(date_day)                  as day_name,
    weekiso(date_day)                  as week_of_year,
    dayofweekiso(date_day) in (6, 7)   as is_weekend
from days