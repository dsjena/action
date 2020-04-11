urlpath="https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series"
CONFIRMED="time_series_covid19_confirmed_global.csv"

rm -f ${CONFIRMED} ${DEATH} ${RECOVERED} ${CONFIRMED_US} ${DEATH_US}
mkdir -p csv
jhu=${CONFIRMED}
wget ${urlpath}/${jhu}
mv ${jhu} csv/confirmed.csv
