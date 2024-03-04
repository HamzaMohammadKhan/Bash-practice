mkdir /home/hamza/countries
  
mkdir /home/hamza/countries/{USA,UK,India}

find /home/hamza/countries/{USA,UK,India} -name "capital.txt" -exec touch -f {} +

echo 'Washington, D.C' > /home/hamza/countries/USA/capital.txt

echo 'London' > /home/hamza/countries/UK/capital.txt

echo 'New Delhi' > /home/hamza/countries/India/capital.txt

uptime
