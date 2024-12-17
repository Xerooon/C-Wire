#!/bin/bash

# Script: c-wire.sh
# Description: Filters data from a CSV file and runs a C program for processing.
# Usage: ./c-wire.sh <input_csv> <type_station> <type_consumer> [<central_id>] [-h]

# Constants and paths
C_EXECUTABLE="./codeC/programme"
TMP_DIR="tmp"
OUTPUT_DIR="tests"

#Timer
START_TIME=$(date +%s)  # Timestamp at the beginning 

# Helper functions
function print_help {
  echo "Usage: $0 <input_csv> <type_station> <type_consumer> [<central_id>] [-h]"
  echo "  <input_csv>: Path to the input CSV file."
  echo "  <type_station>: Type of station to process. Options: hvb, hva, lv."
  echo "  <type_consumer>: Type of consumer. Options: comp, indiv, all."
  echo "  [<central_id>]: (Optional) Filter by central ID."
  echo "  -h: Show this help message."
  exit 1
}

function error_exit {
  echo "Error: $1" >&2
  echo "Time elapsed for programme execution : 0.0 seconds"
  exit 1
}

# Validate arguments
if [[ "$1" == "-h" ]] || [[ $# -lt 3 ]]; then
  print_help
fi

INPUT_CSV="$1"
TYPE_STATION="$2"
TYPE_CONSUMER="$3"
CENTRAL_ID="$4"

# Check input file
if [[ ! -f "$INPUT_CSV" ]]; then
  error_exit "Input CSV file not found."
fi

# Validate station type
if [[ "$TYPE_STATION" != "hvb" && "$TYPE_STATION" != "hva" && "$TYPE_STATION" != "lv" ]]; then
  error_exit "Invalid type_station: $TYPE_STATION. Must be 'hvb', 'hva', or 'lv'."
fi

# Validate consumer type
if [[ "$TYPE_CONSUMER" != "comp" && "$TYPE_CONSUMER" != "indiv" && "$TYPE_CONSUMER" != "all" ]]; then
  error_exit "Invalid type_consumer: $TYPE_CONSUMER. Must be 'comp', 'indiv', or 'all'."
fi

# Forbidden combinations
if { [[ "$TYPE_STATION" == "hvb" || "$TYPE_STATION" == "hva" ]] && [[ "$TYPE_CONSUMER" == "all" || "$TYPE_CONSUMER" == "indiv" ]]; }; then
  error_exit "Invalid combination of type_station and type_consumer."
fi

# Prepare directories
mkdir -p "$TMP_DIR" "$OUTPUT_DIR"
rm -rf "$TMP_DIR"/*

# Filter input CSV
CSV_FILE="$TMP_DIR/temp_${TYPE_STATION}_${TYPE_CONSUMER}${CENTRAL_ID:+_}${CENTRAL_ID}.csv"
echo "Filtering data for station: $TYPE_STATION, consumer: $TYPE_CONSUMER, central: ${CENTRAL_ID:-all}..."
awk -F';' -v station="$TYPE_STATION" -v consumer="$TYPE_CONSUMER" -v central="$CENTRAL_ID" -v csv_file="$CSV_FILE" \
'BEGIN { OFS=";" }
NR > 1 {
  # Process station data
  if ((station == "hvb" && $2 != "-" && $3 == "-" && $4 == "-" && $5 == "-" && $6 == "-") ||
      (station == "hva" && $3 != "-" && $4 == "-" && $5 == "-" && $6 == "-") ||
      (station == "lv" && $4 != "-" && $5 == "-" && $6 == "-")) {
    if (central == "" || $1 == central) {
      print $0 > csv_file
    }
  }
  # Process consumer data
  if ((station == "hvb" && $2 != "-" && $3 == "-" && $4 == "-") ||
      (station == "hva" && $3 != "-" && $4 == "-") ||
      (station == "lv" && $4 != "-")) {
    if (central == "" || $1 == central) {
      if ((consumer == "comp" && $5 != "-" && $6 == "-") ||
          (consumer == "indiv" && $5 == "-" && $6 != "-") ||
          (consumer == "all" && ($5 != "-" || $6 != "-"))) {
        print $0 > csv_file
      }
    }
  }
}' "$INPUT_CSV"

# Check if combined file is not empty
if [[ ! -s "$CSV_FILE" ]]; then
  error_exit "No data found for the given filters."
fi

# Compile C program if needed
if [[ ! -x "$C_EXECUTABLE" ]]; then
  echo "Compiling C program..."
  (cd codeC && make)
  if [[ $? -ne 0 ]]; then
    error_exit "Compilation failed."
  fi
fi

# Prepare labels for the output
STATION_LABEL=$(echo "$TYPE_STATION" | tr '[:lower:]' '[:upper:]') # Convert to uppercase
case "$TYPE_CONSUMER" in
  comp) CONSUMER_LABEL="entreprises" ;;
  indiv) CONSUMER_LABEL="particuliers" ;;
  all) CONSUMER_LABEL="tout" ;;
  *) error_exit "Unknown consumer type: $TYPE_CONSUMER" ;;
esac

# Run C program
OUTPUT_FILE="$OUTPUT_DIR/${TYPE_STATION}_${TYPE_CONSUMER}${CENTRAL_ID:+_}${CENTRAL_ID}.cvs"
HEADER="Station $STATION_LABEL:Capacité:Consommation ($CONSUMER_LABEL)"
echo "$HEADER" > "$OUTPUT_FILE"
echo "Running C program..."
"$C_EXECUTABLE" "$CSV_FILE" "$OUTPUT_FILE"

if [[ $? -ne 0 ]]; then
  error_exit "C program execution failed."
fi

END_TIME=$(date +%s) # Timestamp at the end
ELAPSED=$((END_TIME - START_TIME))
echo "Results saved to $OUTPUT_FILE."
echo "Done. Time elapsed : ${ELAPSED} seconds"