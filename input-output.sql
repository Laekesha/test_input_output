create table INPUT_OUTPUT (    
  user_fn                varchar2(50) not null,   
  input_datetime         timestamp not null,   
  output_datetime        timestamp not null  
)


insert into INPUT_OUTPUT values ( 
    'Любимова Ольга',  
    timestamp '2018-01-08 14:00:00', 
    timestamp '2018-01-08 20:00:00' 
)


insert into INPUT_OUTPUT values ( 
    'Колбасова Яна',  
    timestamp '2018-01-08 10:00:00',  
    timestamp '2018-01-08 13:30:00' 
)


insert into INPUT_OUTPUT values ( 
    'Колбасова Яна',  
    timestamp '2018-01-08 14:00:00',  
    timestamp '2018-01-08 16:30:00' 
)


insert into INPUT_OUTPUT values ( 
    'Колбасова Яна',  
    timestamp '2018-01-08 17:05:00', 
    timestamp '2018-01-08 18:10:00' 
)


insert into INPUT_OUTPUT values ( 
    'Любимова Ольга',  
    timestamp '2018-01-15 09:00:00',  
    timestamp '2018-01-15 13:00:00' 
)


insert into INPUT_OUTPUT values ( 
    'Любимова Ольга',  
    timestamp '2018-01-15 14:00:00', 
    timestamp '2018-01-15 18:00:00' 
)


insert into INPUT_OUTPUT values ( 
    'Колбасова Яна',  
    timestamp '2018-01-15 09:00:00', 
    timestamp '2018-01-15 13:00:00' 
)


insert into INPUT_OUTPUT values ( 
    'Колбасова Яна',  
    timestamp '2018-01-15 14:00:00',  
    timestamp '2018-01-15 18:00:00' 
)


insert into INPUT_OUTPUT values (  
    'Любимова Ольга',   
    timestamp '2018-01-22 09:21:00',  
    timestamp '2018-01-22 12:59:00' 
)


insert into INPUT_OUTPUT values (  
    'Любимова Ольга',   
    timestamp '2018-01-22 14:15:00',   
    timestamp '2018-01-22 17:30:00' 
)


insert into INPUT_OUTPUT values (  
    'Колбасова Яна',   
    timestamp '2018-01-22 08:42:00',   
    timestamp '2018-01-22 19:13:00' 
)


select  
    to_char(input_datetime, 'w') "WEEK#", 
    user_fn "USER",   
    sum(  
    case   
        when 
            input_datetime >= trunc(input_datetime) + interval '9' hour  
            and input_datetime < trunc(input_datetime) + interval '13' hour  
            and output_datetime <= trunc(output_datetime) + interval '13' hour  
        then sysdate + (output_datetime - input_datetime) * 24 - sysdate   
        when   
            input_datetime >= trunc(input_datetime) + interval '14' hour  
            and output_datetime > trunc(output_datetime) + interval '14' hour  
            and output_datetime <= trunc(output_datetime) + interval '18' hour  
        then sysdate + (output_datetime - input_datetime) * 24 - sysdate  
         
 
             
        when input_datetime > trunc(input_datetime) + interval '13' hour 
            and output_datetime < trunc(output_datetime) + interval '14' hour 
        then 0 
         /*    
        when  
            input_datetime < trunc(input_datetime) + interval '13' hour 
            and output_datetime > trunc(input_datetime) + interval '13' hour 
            and output_datetime < trunc(input_datetime) + interval '14' hour 
        then sysdate + (trunc(output_datetime) + interval '13' hour - input_datetime) * 24 - sysdate       
             
        when  
            input_datetime > trunc(input_datetime) + interval '13' hour 
            and input_datetime < trunc(input_datetime) + interval '14' hour 
            and output_datetime < trunc(output_datetime) + interval '14' hour 
        then sysdate + (output_datetime - trunc(input_datetime) + interval '14' hour) * 24 - sysdate           
             
        when input_datetime > trunc(input_datetime) + interval '14' hour  
            and output_datetime > trunc(input_datetime) + interval '18' hour 
            then sysdate + (trunc(input_datetime) + interval '18' hour - input_datetime) * 24 - sysdate   
          */   
    end) "BUSSINESS HOURS", 
     
    sum(  
    case   
        when input_datetime < trunc(input_datetime) + interval '9' hour 
            then sysdate + ((trunc(input_datetime) + interval '9' hour) - input_datetime) * 24 - sysdate 
        when output_datetime > trunc(output_datetime) + interval '18' hour 
            then sysdate + (output_datetime - (trunc(output_datetime) + interval '18' hour)) * 24 - sysdate 
    end) "NON-BUSSINESS HOURS", 
     
    (select count(*) from 
        (select 
            user_fn as user_,  
            to_char(input_datetime, 'w') as week_no,  
            min(sysdate + (input_datetime - trunc(input_datetime)) * 24 - sysdate) as min_time 
        from INPUT_OUTPUT 
        group by user_fn, trunc(input_datetime), to_char(input_datetime, 'w')) 
    where user_ = user_fn  
        and week_no = to_char(input_datetime, 'w')  
        and min_time > 9 
    ) "LATELESS"  
     
from INPUT_OUTPUT  
group by user_fn, to_char(input_datetime, 'w') 
order by to_char(input_datetime, 'w'), user_fn