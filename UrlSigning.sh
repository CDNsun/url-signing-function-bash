#!/bin/bash

while getopts "s:r:p:k:e:i:" opt; do
  case $opt in
    s)
      s="$OPTARG";
      ;;
    r)
      r="$OPTARG";
      ;;
    p)
      p="$OPTARG";
      ;;
    k)
      k="$OPTARG";
      ;;
    e)
      e="$OPTARG";
      ;;
    i)
      i="$OPTARG";
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2;
      exit 1;
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2;
      exit 1;
      ;;
  esac
done
if [ -z "${s+x}" ]
then
        echo "Options -s is required.";
        exit 1;
fi
if [ -z "${r+x}" ]
then
        echo "Options -r is required.";
        exit 1;
fi
if [ -z "${p+x}" ]
then
        echo "Options -p is required.";
        exit 1;
else
        # Append leading slash if missing
        if ! `echo -n "$p" | grep -q "^/"`
        then
                p="/""$p";
        fi
        # Extract uri, ignore arguments
        p=`echo -n "$p" | sed 's/\?.*$//'`;
fi
if [ -z "${k+x}" ]
then
        echo "Options -k is required.";
        exit 1;
fi
if [ -z "${e+x}" ]
then
        e="";
fi
if [ -z "${i+x}" ]
then
        i="";
fi

TK="$e""$p""$k""$i";
echo $TK;
T=`echo -n "$TK" | openssl md5 -binary | openssl base64 | tr +/ -_ | tr -d =`;
URI="$s""://""$r""$p""?secure=""$T";

if [[ -n "$e" ]]
then
        URI="$URI""&expires=""$e";
fi
if [[ -n "$i" ]]
then
        URI="$URI""&ip=""$i";
fi

echo "$URI";