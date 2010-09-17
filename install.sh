#!/bin/bash
dir=`pwd`
timestamp=`date +%s`
mkdir $dir/old.$timestamp
for i in *; do
	[[ $i == "install.sh" || $i == "README" || ${i%%.*} == "old" ]] && continue
	if [[ -f ~/.$i || -d ~/.$i ]]; then
		cp -a ~/.$i $dir/old.$timestamp/$i

		echo "~/.$i already exists, overwrite? [y/n] "
		read yn
		if [[ $yn == "y" ]]; then
			ln -sf $dir/$i ~/.$i
		fi
	else
		ln -sf $dir/$i ~/.$i
	fi
done
