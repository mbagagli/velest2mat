#!/bin/bash
# VELEST2MAT.sh is a script to create the necessary ASCII files
# for the MATLAB plotting routine of VELEST_v4.5
#
# USAGE:  velest2mat.sh LOG CNV STATCORR
# AUTHOR: Matteo Bagagli @ ETH-Zurich
if [ "$#" -lt 1 ]; then
cat << EOF
USAGE: velest2mat.sh -l LOG -c CNV -s STATCORR
EOF
exit
fi

# ------------------------------------------ Grep args and Checks
while getopts :l:c:s: option
do
    case "$option"
    in
        l) LOG=$OPTARG;;
        c) CNV=$OPTARG;;
        s) SCR=$OPTARG;;
    esac
done
# Checks
if [ ! -n "${LOG}" -a ! -n "${CNV}" -a ! -n "${SCR}" ]; then
    echo "$(basename $0): ERROR! Need at least one file!"
    echo "*** USAGE: $(basename $0) -l LOG -c CNV -s STATCORR"
    exit
fi

# ------------------------------------------ Work on LOG
if [ -n "${LOG}" ]; then
    ### Hypocenter Adjustment (t x y z)
    grep "A V E R A G E   of ADJUSTMENTS :" ${LOG} | \
          awk '{print $11,$12,$13,$14}'> velest2mat.HypoCorr

    ### RMS
    # " Iteration nr*" # Results Line +1
    # "(Iteration nr*" # Occours if is a backup-run
    awk '/ Iteration nr*/{getline; print $NF}' ${LOG} > velest2mat.RMS
fi

# ------------------------------------------ Work on CNV
if [ -n "${CNV}" ]; then
    grep "EVID" ${CNV} | cut -c19- | \
    awk '{print substr($1, 1, length($1)-1),substr($2, 1, length($2)-1),$3,$4}' > velest2mat.latlondepmag
fi

# ------------------------------------------ Work on STATCORR
if [ -n "${SCR}" ]; then
    # *** NB: the header should be one line otherwise remove the sed call!
    # *** NB: The script assumes that direction N is positive and E is positive!
    sed '1d' ${SCR} | sed '/^[[:space:]]*$/d;s/[[:space:]]*$//' > tmp.START # remove blanklines
    cat tmp.START | cut -c 1-4 > tmp.STATION
    cat tmp.START | cut -c 5- > tmp.BODY
    # adjust lat+lon (positive sign for N and E) and separate them from body
    awk '{if (substr($1,length($1),1)!="N") print "-"substr($1,1,length($1)-1); \
    if (substr($1,length($1),1)=="N") print "+"substr($1,1,length($1)-1)}' tmp.BODY > tmp.LAT
    awk '{if (substr($2,length($2),1)!="E") print "-"substr($2,1,length($2)-1); \
    if (substr($2,length($2),1)=="E") print "+"substr($2,1,length($2)-1)}' tmp.BODY > tmp.LON
    awk '{$1=$2=""; print $0}' tmp.BODY > tmp.REST
    #
    paste -d " " tmp.STATION tmp.LAT tmp.LON tmp.REST > velest2mat.statcorr
fi

# ------------------------------------------ Netting
rm tmp*
echo "... DONE"
