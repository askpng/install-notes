function monitor --wraps='systemctl status tlp throttled zcfan' --description 'alias monitor=systemctl status tlp throttled zcfan'
  systemctl status tlp throttled zcfan $argv
end
