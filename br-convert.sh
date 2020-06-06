#/bin/bash

# Compress all js and css files in subdirectories, to ~brotli/ directory
# apt install webp
# Usage ./br-convert.sh

br() {
	local fullname="$1"

	if [[ "$fullname" =~ "brotli/" ]]; then
		local brotlifn=`echo ${fullname/"$dir/brotli"/$dir}`

		if [[ ! -f "$brotlifn" ]]; then
			rm -f $fullname
		fi
	else
		local brotli=`echo ${fullname/$dir/"$dir/brotli"}`
		local filename=`basename "$1"`

		if [[ -e "$brotli" ]]; then
			if [[ $(date -r "$brotli" +%s) < $(date -r "$fullname" +%s) ]]; then
				brotli -Zf -o "$brotli" "$fullname"
			fi
		else
			local wdir=$(dirname "${brotli}")
			
			if [[ ! -d "$wdir" ]]; then
				mkdir -p "$wdir"
			fi
			
			brotli -Zf -o "$brotli" "$fullname"
		fi
	fi
}


scanjscss() {
    find $path \( -iname "*.js" -o -iname "*.css" \) | while read file; do
        br "$file"
    done
}


[[ $(lsof -t $0| wc -l) > 1 ]] && exit

## Start into subdirectory example ./tmp/br-convert.sh
cd ..

## Exit if runned another copy
[ $# -eq 0 ] && path=`pwd` || path=$@

dir=`basename $path`
scanjscss "$path"
