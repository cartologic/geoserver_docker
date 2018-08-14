#!/usr/bin/env bash
if [ ! -d ${GEOSERVER_DATA_DIR} ];
then
    echo "Creating geoserver data directory"
    mkdir -p ${GEOSERVER_DATA_DIR}
else
    echo "Geoserver data directory already exist"
fi

if [ ! -d ${FOOTPRINTS_DATA_DIR} ];
then
    echo "Creating geoserver footprints directory"
    mkdir -p ${FOOTPRINTS_DATA_DIR}
else
    echo "Geoserver  footprints directory already exist"
fi