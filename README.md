# Correlations calculator

Calculates linear correlation between data ranges

## Command-line options

``corr-calc [DATA_FILE] [-o|--output OUTPUT_FILE]``

* ``DATA_FILE`` -- input file. Default is "data.csv"
* ``OUTPUT_FILE`` -- output file. Defauilt is "results.csv"

## Input format

CSV-file with each data-range as a row of the form:

``%control-code%, %range-name%, %comma-separated doubles%``

Ranges can have different sizes. In that case before calculating correlation between two ranges the longer one is truncated.

### Example:

```
0, Range 1, 1.0, 2.5, 3, 4
1, Range 2, 1,2,3
2, Range 3, 0,9,8,7,6,5,4
```

## Control code

``corr-calc`` calculates correlations between rows using the following rule:

Calculate correlation between "Range 1" and "Range 2" iff control-code of "Range 1" is less than that of "Range 2"

### Example

Suppose you have 5 ranges and you want to get correlations between

* range 1 and ranges 3 and 4
* range 2 and ranges 3 and 4
* range 3 and range 4
* range 5 and ranges 1,2,3,4

Resulting csv-file:

```
1, Range 1, ...
1, Range 2, ...
2, Range 3, ...
3, Range 4, ...
0, Range 5, ...
```
