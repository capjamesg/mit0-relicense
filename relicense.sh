#!/bin/bash

# Relicense all of the projects where I was the only author (excluding Dependabot)

FOLDERS=`ls -d /Users/james/src/*/`

for folder in $FOLDERS; do
    cd $folder

    # if .git doesn't exist, skip
    if [ ! -d .git ]; then
        echo "No .git folder in $folder, skipping"
        continue
    fi

    AUTHORS=`git shortlog --pretty --summary --numbered --email | less | awk '!/jamesg/ && !/dependabot/' | wc -l`

    if [[ $AUTHORS -gt 0 ]]; then
        echo "This repository has more than one author. Please contact the maintainers to discuss relicensing."
        continue
    fi

    CURRENT_DIRECTORY=`basename $(pwd)`

    echo "Relicensing $CURRENT_DIRECTORY..."

    cp ../MIT0.md LICENSE.md

    if [[ $? -eq 0 ]]; then
        echo "Replaced LICENSE.md with MIT 0 License."
    else
        echo "Relicensing failed: MIT0.md license file not found."
        continue
    fi

    sed -iI 's/MIT license/MIT 0 license/' README.md

    if [[ $? -eq 0 ]]; then
        echo "Relicensing complete."
    else
        echo "Relicensing failed: README.md not found."
        continue
    fi
    
    git add README.md
    git add LICENSE.md
    git commit -m "Relicense to MIT 0" -S
    git push

    cd ..
done
