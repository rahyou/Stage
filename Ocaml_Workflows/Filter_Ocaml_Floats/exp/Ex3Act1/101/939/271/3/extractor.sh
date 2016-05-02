#!/bin/bash
PWD=${pwd}

if make -f Makefile; then 
	:./myProg "&1" "&2" "&3"
else 
	:exit
fi
