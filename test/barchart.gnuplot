reset
set style fill solid border -1
set boxwidth 0.8
set xtic offset 0,-.1 rotate by -90 scale 0
set datafile separator "\t"
set xlabel ' '
set ylabel 'average run time (seconds)'
unset key
set terminal postscript
set output 'timings.eps'
plot 'timeavg.out' using 2:xticlabel(1) with boxes
