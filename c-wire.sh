#!/bin/bash

# Script: c-wire.sh
# Description: Filters data from a CSV file and runs a C program for processing.
# Usage: ./c-wire.sh <input_csv> <type_station> <type_consumer> [<central_id>] [-h]

# Constants and paths
C_EXECUTABLE="./codeC/programme"
TMP_DIR="./tmp"
OUTPUT_DIR="./tests"

# Timestamp at the beginning 
START_TIME=$(date +%s)  

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

# If the argument is -h display the help
for arg in "$@"; do
  case "$arg" in
    -h)
    print_help 
    ;;
  esac
done

# Put arguments into variables
INPUT_CSV="$1"
TYPE_STATION="$2"
TYPE_CONSUMER="$3"
CENTRAL_ID="${4:-}"

# Check input file
if [[ ! -f "$INPUT_CSV" ]]; then
  error_exit "Input CSV file not found."
fi

# Check station type
if [[ "$TYPE_STATION" != "hvb" && "$TYPE_STATION" != "hva" && "$TYPE_STATION" != "lv" ]]; then
  error_exit "Invalid type_station: $TYPE_STATION. Must be 'hvb', 'hva', or 'lv'. 
Usage: $0 <input_csv> <type_station> <type_consumer> [<central_id>] [-h]
"
fi

# Check consumer type
if [[ "$TYPE_CONSUMER" != "comp" && "$TYPE_CONSUMER" != "indiv" && "$TYPE_CONSUMER" != "all" ]]; then
  error_exit "Invalid type_consumer: $TYPE_CONSUMER. Must be 'comp', 'indiv', or 'all'.
Usage: $0 <input_csv> <type_station> <type_consumer> [<central_id>] [-h]
"
fi

# Forbidden combinations
if { [[ "$TYPE_STATION" == "hvb" || "$TYPE_STATION" == "hva" ]] && [[ "$TYPE_CONSUMER" == "all" || "$TYPE_CONSUMER" == "indiv" ]]; }; then
  error_exit "Invalid combination of station and consumer.

Authorized combinations : 
  -hvb comp
  -hva comp
  -lv comp
  -lv indiv
  -lv all
"
fi

# Prepare directories
mkdir -p "$TMP_DIR" "$OUTPUT_DIR"
rm -rf "$TMP_DIR"/*

CSV_FILE="$TMP_DIR/temp_${TYPE_STATION}_${TYPE_CONSUMER}${CENTRAL_ID:+_}${CENTRAL_ID}.csv"
# Filter input CSV
case $TYPE_STATION in
  # Case argument is hvb
  "hvb")
    if [[ -n "$CENTRAL_ID" ]]; then
      awk -F ';' -v id="$CENTRAL_ID" 'NR == 1 || (($2 != "-" && $5 != "-" && $4 == "-" && $3 == "-" && $1 == id) || ($2 != "-" && $3 == "-" && $4 == "-" && $1 == id))' "$INPUT_CSV" > "$CSV_FILE"
    else
      awk -F ';' 'NR == 1 || (($2 != "-" && $5 != "-" && $4 == "-" && $3 == "-") || ($2 != "-" && $3 == "-" && $4 == "-"))' "$INPUT_CSV" > "$CSV_FILE"
    fi
    ;;
    # Case argument is hva
  "hva")
    if [[ -n "$CENTRAL_ID" ]]; then
      awk -F ';' -v id="$CENTRAL_ID" 'NR == 1 || (($3 != "-" && $5 != "-" && $4 == "-" && $1 == id) || ($3 != "-" && $4 == "-" && $1 == id))' "$INPUT_CSV" > "$CSV_FILE"
    else
      awk -F ';' 'NR == 1 || (($3 != "-" && $5 != "-" && $4 == "-") || ($3 != "-" && $4 == "-"))' "$INPUT_CSV" > "$CSV_FILE"
    fi
    ;;
    # Case argument is lv
  "lv")
    case $TYPE_CONSUMER in
      "all")
        if [[ -n "$CENTRAL_ID" ]]; then
          awk -F ';' -v id="$CENTRAL_ID" 'NR == 1 || ($4 != "-" && $1 == id)' "$INPUT_CSV" > "$CSV_FILE"
        else
          awk -F ';' 'NR == 1 || ($4 != "-")' "$INPUT_CSV" > "$CSV_FILE"
        fi
        ;;
      "indiv")
        if [[ -n "$CENTRAL_ID" ]]; then
          awk -F ';' -v id="$CENTRAL_ID" 'NR == 1 || ($4 != "-" && $6 != "-" && $1 == id) || ($4 != "-" && $5 == "-" && $1 == id)' "$INPUT_CSV" > "$CSV_FILE"
        else
          awk -F ';' 'NR == 1 || ($4 != "-" && $6 != "-") || ($4 != "-" && $5 == "-")' "$INPUT_CSV" > "$CSV_FILE"
        fi
        ;;
      "comp")
        if [[ -n "$CENTRAL_ID" ]]; then
          awk -F ';' -v id="$CENTRAL_ID" 'NR == 1 || ($4 != "-" && $5 != "-" && $1 == id) || ($4 != "-" && $6 == "-" && $1 == id)' "$INPUT_CSV" > "$CSV_FILE"
        else
          awk -F ';' 'NR == 1 || ($4 != "-" && $5 != "-") || ($4 != "-" && $6 == "-")' "$INPUT_CSV" > "$CSV_FILE"
        fi
        ;;
    esac
    ;;
esac

# Check if file is not empty
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
  all) CONSUMER_LABEL="tous" ;;
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

# Sort output by capacity in ascending order
SORTED_FILE="$TMP_DIR/sorted_output"
tail -n +2 "$OUTPUT_FILE" | sort -t ':' -k2n > "$SORTED_FILE"
echo "$HEADER" > "$OUTPUT_FILE"
cat "$SORTED_FILE" >> "$OUTPUT_FILE"

# Create lv_all_minmax.csv
if [[ "$TYPE_CONSUMER" == "all" && "$TYPE_STATION" == "lv" ]]; then
  MINMAX_FILE="$OUTPUT_DIR/lv_all_minmax.csv"
  cat "$OUTPUT_FILE" > "$MINMAX_FILE"
  sort -t ':' -k3n "$MINMAX_FILE" > "$SORTED_FILE"
  sort -t ':' -k3n "$SORTED_FILE" | tail -n +2 | { head -n 10 && tail -n 10; } > "$MINMAX_FILE" # Take only the 10 first and 10 last
  awk -F':' '{diff = $3 - $2; print diff, $0}' "$MINMAX_FILE" | sort -k1,1nr | cut -d' ' -f2- > "$SORTED_FILE" # Sort the difference: Load(-)Capacity
  echo "Min and Max 'capacity-load' extreme nodes" > "$MINMAX_FILE"
  echo "$HEADER" >> "$MINMAX_FILE"
  cat "$SORTED_FILE" >> "$MINMAX_FILE"
fi

# Timestamp at the end
END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo "Results saved to $OUTPUT_FILE."
echo "Done. Time elapsed : ${ELAPSED} seconds"