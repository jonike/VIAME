#!/bin/bash

# Path to VIAME installation
export VIAME_INSTALL=/opt/noaa/viame

# Core processing options
export INPUT_LIST=input_list.txt
export INPUT_FRAME_RATE=1
export PROCESS_FRAME_RATE=1

# Note: Frame rates are specified in hertz, aka frames per second. If the
# input frame rate is 1 and the process frame rate is also 1, then every
# input image in the list will be processed. If the process frame rate
# is 2, then every other image will be processed.

# Extra resource utilization options
export TOTAL_GPU_COUNT=1
export PIPES_PER_GPU=1

# Setup paths and run command
source ${VIAME_INSTALL}/setup_viame.sh

python ${VIAME_INSTALL}/configs/process_video.py \
  -l ${INPUT_LIST} -ifrate ${INPUT_FRAME_RATE} -frate ${PROCESS_FRAME_RATE} \
  -p pipelines/tracker_default.tut.pipe \
  -gpus ${TOTAL_GPU_COUNT} -pipes-per-gpu ${PIPES_PER_GPU} \
  -s detector:detector:darknet:net_config=deep_training/yolo_v2.cfg \
  -s detector:detector:darknet:weight_file=deep_training/models/yolo_v2.backup \
  -s detector:detector:darknet:class_names=deep_training/yolo_v2.lbl \
  -s detector:detector:darknet:scale=1.4 \
  -s detector_writer:file_name=deep_detections.csv \
  -s track_writer:file_name=deep_tracks.csv
