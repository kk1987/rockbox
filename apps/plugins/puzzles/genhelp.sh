#!/bin/bash
# usage: ./genhelp.sh > helpcontent.sh
#
# expects halibut to be installed in $PATH:
# http://www.chiark.greenend.org.uk/~sgtatham/halibut

halibut --text src/puzzles.but

# preprocess the input

# strip leading whitespace
cat puzzles.txt | awk '{$1=$1; print}' > puzzles.txt.tmp

# cut at "Appendix A"
cat puzzles.txt.tmp | awk 'BEGIN { a=1; } /Appendix A/ { a = 0; } a==1' > puzzles.txt

rm puzzles.txt.tmp

cat <<EOF
/* auto-generated by genhelp.sh */
/* DO NOT EDIT! */
const int help_chapteroffsets[] = {
EOF

# generate chapter offset list
cat puzzles.txt | awk 'BEGIN { x = -1; n = 0; } /#Chapter/ { if($0 !~ / 1:/ && $0 !~ / 2:/) { if( x == -1 ) { x = n; } print n - x","; }} {n += length($0) + 1; if(x >= 0 && $0 !~ /Chapter/ && substr($0, 1, 1) == "#") n += 1;}'

cat <<EOF
};

const char help_text[] =
EOF

# get starting byte offset
start=`cat puzzles.txt | awk 'BEGIN { x = -1; n = 0; } /#Chapter/ { if($0 !~ / 1:/ && $0 !~ / 2:/) { if( x == -1 ) { x = n; print x + 1; } print n - x","; }} {n += length($0) + 1; if(x >= 0 && $0 !~ /Chapter/ && substr($0, 1, 1) == "#") n += 1;}' | head -n 1`

# generate content
cat puzzles.txt | tail -c +$start | awk '{gsub(/\\/,"\\\\"); if($0 !~ /Chapter/ && substr($0, 1, 1) == "#") begin = "\\n"; else begin = ""; last = substr($0, length($0), 1); if(length($0) == 0 || last == "|" || last == "-" || (term == "\\n" && last == "3")) term="\\n"; else term = " "; print "\"" begin $0 term "\"";}'

cat <<EOF
;

EOF

# length of longest chapter (not including null)
maxlen=`cat puzzles.txt | awk 'BEGIN { x = -1; n = 0; } /#Chapter/ { if($0 !~ / 1:/ && $0 !~ / 2:/) { if( x == -1 ) { x = n; } print n - x","; }} {n += length($0) + 1; if(x >= 0 && $0 !~ /Chapter/ && substr($0, 1, 1) == "#") n += 1;}' | awk 'BEGIN { max = 0; last = 0; } { if($0 - last > max) max = $0 - last; last = $0; } END { print max }'`

# remember number of chapters
num=`cat puzzles.txt | awk 'BEGIN { x = -1; n = 0; } /#Chapter/ { if($0 !~ / 1:/ && $0 !~ / 2:/) { if( x == -1 ) { x = n; } print n - x","; }} {n += length($0) + 1; if(x >= 0 && $0 !~ /Chapter/ && substr($0, 1, 1) == "#") n += 1;}' | wc -l`

echo "const int help_maxlen = "$maxlen";"
echo "const int help_numchapters = "$num";"