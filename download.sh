#!/bin/sh

kiss d $(kiss s \* | tr '/' ' ' | gawk '{ print $NF }')
