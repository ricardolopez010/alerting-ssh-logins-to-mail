
Hey Everyone

I would like to share this script to create alerts when someone loggin into a SSH session easly using Gmail as SMTP provider. Just modify first values in the autodeply.sh file:

#----------------------------------------------------

smtpuser="[smtp.gmail.com]:587 fromaccount@gmail.com:smtppassword"
destinationmail="destinationaccount@sysadmin.com"

#----------------------------------------------------

If you don´t have a SMTP gmail password, I suggest you to follow the next steps first (until step 6) to active it -> https://evermap.com/Tutorial_ADM_UsingAppPasswordsGmail.asp

I hope you find this script usefull
