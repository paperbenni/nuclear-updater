wget -q --tries=10 --timeout=20 --spider http://google.com

if [[ $? -eq 0 ]]; then
        echo "Online"
else
        echo "Offline"
        exit 0
fi

cd $HOME

if [ -e ~/.programs/nuclear ]; then
	cd ~/.programs/nuclear
	mv nuclear.txt old.txt
	curl https://api.github.com/repos/nukeop/nuclear/commits/master >new.txt
	sed -n '3p' <new.txt >~/.programs/nuclear.txt

else
	mkdir ~/.programs/nuclear
fi

cd .programs/nuclear
old=$(cat old.txt)
if [[ $(<nuclear.txt) == "$old" ]]; then
	./nuclear
	exit
fi

cd ~/.cache
rm -rf ./nuclear
git clone --depth=1 https://github.com/nukeop/nuclear.git
cd nuclear
npm install
npm audit fix
npm run build:dist
npm run build:electron
npm run pack
cd release
mv linux-unpacked nuclear
mkdir ~/.programs
mv nuclear ~/.programs/nuclear
rm -rf ~/.cache/nuclear
cd ~/.programs/nuclear
curl https://api.github.com/repos/nukeop/nuclear/commits/master >new.txt
sed -n '3p' <new.txt >~/.programs/nuclear.txt
rm new.txt
./nuclear

