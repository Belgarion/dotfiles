#!/bin/sh
dir=`pwd`
for i in *; do
	[[ $i == "install.sh" ]] && continue
	if [[ -f ~/.$i ]]; then
		echo "~/.$i already exists, overwrite? [y/n] "
		read yn
		if [[ $yn == "y" ]]; then
			ln -sf $dir/$i ~/.$i
		fi
	else
		ln -sf $dir/$i ~/.$i
	fi
done
