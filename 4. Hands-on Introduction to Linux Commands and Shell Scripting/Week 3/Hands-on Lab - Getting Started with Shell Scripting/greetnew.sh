#! /bin/bash
# This script accepts the user\'s firstname & lastname and prints 
# a message greeting the user

# Print the prompt message on screen
echo -n "Enter your first name :"
read firstname
echo -n "Enter your last name :"
read lastname 	  	

# Print the hello message followed by the first name and last name	
echo "Hello $firstname $lastname"