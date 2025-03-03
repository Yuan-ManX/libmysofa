#!/bin/sh

SCRIPTDIR=${0%/*}
NODEJS=$(command -v node nodejs false | head -1)

${MYSOFA2JSON:-${SCRIPTDIR}/../build/src/mysofa2json} -c -s "$1".sofa >tmp1.json 2>tmp1.txt

ret=$?
if [ "$ret" != 0 ]; then 
    cat tmp1.txt
    echo Error libmysofa $ret
    exit $ret
fi

cp -f "${SCRIPTDIR}/json-diff.js" . 2>/dev/null || true
bunzip2 -c -k "$1".json.bz2 >./tmp2.json
"${NODEJS}" ./json-diff.js ./tmp1.json ./tmp2.json
ret=$?
if [ "$ret" != 0 ]; then 
    echo Diff $ret
    exit $ret
fi
echo ok
rm tmp1.json tmp1.txt tmp2.json

