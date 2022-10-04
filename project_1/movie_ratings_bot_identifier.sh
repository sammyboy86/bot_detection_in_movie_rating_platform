#! /bin/bash


 psql -d fdd2db -c "drop table if exists interval_averages_by_genre; create table interval_averages_by_genre as select user_id, genre, AVG(time_between_rates) as average from (select user_id, genre, (date-previous_rate)::interval as time_between_rates from (select user_id, genre_array[1] as genre, row_num, date, previous_rate from (select user_id, regexp_split_to_array(genres, '\|') as genre_array, row_number() over (partition by user_id order by date asc) row_num, date, lag(date) over (partition by user_id order by date asc) previous_rate from ratings_test left join movies on movie_id = id) as sbq1) as sbq2 where previous_rate is not null) as sbq3 group by genre,user_id order by genre,average"

psql -d fdd2db -c 'drop table if exists movie_interval_decile; create table if not exists movie_interval_decile as select distinct genre, percentile_cont(0.1) within group (order by average) "decile_interval" from interval_averages_by_genre group by genre'

psql -d fdd2db -c 'drop table if exists possible_bots; create table if not exists possible_bots as select interval_averages_by_genre.user_id, interval_averages_by_genre.genre, interval_averages_by_genre.average, movie_interval_decile.decile_interval from movie_interval_decile join interval_averages_by_genre on movie_interval_decile.genre=interval_averages_by_genre.genre where movie_interval_decile.decile_interval>=interval_averages_by_genre.average'


psql -d fdd2db -c 'select *  from ratings_test full outer join possible_bots on ratings_test.user_id=possible_bots.user_id'
