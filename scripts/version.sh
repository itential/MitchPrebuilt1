git checkout "${GITHUB_REF:11}"
git reset --hard origin/"${GITHUB_REF:11}"
cd $1

var=$(git log --format=%s --merges -1 | awk '{print $NF}')  
if [[ $var == *"major"* ]] 
then
        type=major
elif [[ $var == *"minor"* ]] 
then
        type=minor
else   
        type=patch
fi

git config --global user.name '$GITHUB_ACTOR'
git config --global user.email 'github-action@users.noreply.github.com'
git remote set-url origin https://x-access-token:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY
npm version $type 
git add package.json
git commit -m "Updating version. Skip CI"
cd ../..
git push origin main --follow-tags --no-verify