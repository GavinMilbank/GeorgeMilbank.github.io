# Entities

- forecastable(forecastable_id,...) -- all the static information 
- forecast_type(forecast_type,...)
- forecast(forecastable_id,date,horizon,forecast_type,value)
- forecastable_history(forecastable_id,date,value)
- forecastable_consumer_history(forecastable_id,consumer_post_id,effects...) # 
- consumer_post(consumer_post_id,date,url) - file, leave in ES
- design_matrix - long form forecastable_history and forecastable_consumer_history gathered wide


