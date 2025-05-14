#!bin/bash

IP=172.23.12.176
port=25
from=sender-mail@example.com
############################################################## Sample Mail Send script ############################################################################
cd /home/test/mailsend/
./mailsend -smtp $IP -port $port -d HELO -t "personB@mail.com" -f $from -sub "TEST MAIL" +cc +bcc -attach "file.txt" -M 
"Dear All,

This is Test Mail.

Thanks and Regards,
Support Team" -v -user test -pass 'test'
###################################################################################################################
