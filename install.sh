#!/bin/sh
dir=`pwd`
mkdir $dir/old
for i in *; do
	[[ $i == "install.sh" || $i == "README" ]] && continue
	if [[ -f ~/.$i ]]; then
		cp ~/.$i $dir/old/$i

		echo "~/.$i already exists, overwrite? [y/n] "
		read yn
		if [[ $yn == "y" ]]; then
			ln -sf $dir/$i ~/.$i
		fi
	else
		ln -sf $dir/$i ~/.$i
	fi
done
