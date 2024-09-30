function myip
    curl -s ifconfig.co/json | jq -r ".ip, .country"
end
