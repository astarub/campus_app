WIKI_PATH=./docs/wiki
SUBFOLDERS=(Utilities Pages)

# Remove priviously generated home pages
if [ -f $WIKI_PATH/Home.md ]; then
    rm $WIKI_PATH/Home.md;
fi

# Copy README.md to Home.md
cat README.md >> $WIKI_PATH/Home.md

for sub in ${SUBFOLDERS[@]}; 
do
    FILE=$WIKI_PATH/${sub}.md

    # Remove priviously generated wiki pages
    if [ -f $FILE ]; then
        rm $FILE;
    fi

    # Create seperate file for subpage
    touch $FILE   

    # Iterate over all subfolders and create corresponding wiki page
    for f in $(find "${WIKI_PATH}/${sub}" -type f -name "*.md"); 
    do
        cat "$f" >> $FILE;              # Concanate subpage
        printf "\n---\n\n" >> $FILE;    # Add devider after each subpage
    done
done