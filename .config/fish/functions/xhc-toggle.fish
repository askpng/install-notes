unction xhc-toggle --wraps='sudo su && exho XHC > /proc/acpi/wakeup' --wraps='sudo su && echo XHC > /proc/acpi/wakeup' --description 'alias xhc-toggle=sudo su && echo XHC > /proc/acpi/wakeup'
  sudo su && echo XHC > /proc/acpi/wakeup $argv
        
end
