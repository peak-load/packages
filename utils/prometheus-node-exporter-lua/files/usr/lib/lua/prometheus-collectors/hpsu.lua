local function scrape()
  local f = assert(io.popen('python3 /opt/pyHPSU/pyHPSU.py -c t_hs -c t_hs_set -c t_ext -c t_room1_setpoint -c t_dhw -c t_dhw_set -c t_return -c flow_rate -c water_pressure -c status_pump -c runtime_pump -c runtime_comp -c water_pressure -o CSV | grep -vE "error|warning"', 'r'))
  local s = assert(f:read('*all'))
  f:close()
  
  metric("hpsu_temperature_hs_celsius", "gauge", nil, string.match(s,"t_hs,([-]?[0-9.]+)"))
  metric("hpsu_temperature_hs_set_celsius", "gauge", nil, string.match(s,"t_hs_set,([-]?[0-9.]+)"))
  metric("hpsu_temperature_ext_celsius", "gauge", nil, string.match(s,"t_ext,([-]?[0-9.]+)"))
  metric("hpsu_temperature_room1_setpoint_celsius", "gauge", nil, string.match(s,"t_room1_setpoint,([-]?[0-9.]+)"))
  metric("hpsu_temperature_dhw_celsius", "gauge", nil, string.match(s,"t_dhw,([-]?[0-9.]+)"))
  metric("hpsu_temperature_dhw_set_celsius", "gauge", nil, string.match(s,"t_dhw_set,([-]?[0-9.]+)"))
  metric("hpsu_temperature_return_celsius", "gauge", nil, string.match(s,"t_return,([-]?[0-9.]+)"))
  metric("hpsu_flow_rate_liters", "gauge", nil, string.match(s,"flow_rate,([0-9.]+)"))
  metric("hpsu_pump_enabled", "gauge", nil, string.match(s,"status_pump,([0-9.]+)"))
  metric("hpsu_runtime_pump_seconds_total", "counter", nil, string.match(s,"runtime_pump,([0-9.]+)")*3600)
  metric("hpsu_runtime_comp_seconds_total", "counter", nil, string.match(s,"runtime_comp,([0-9.]+)")*3600)
  metric("hpsu_water_pressure_bars", "gauge", nil, string.match(s,"water_pressure,([0-9.]+)"))
end

return { scrape = scrape }
