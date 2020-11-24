set -e

fixup_nixos() {
	echo patching ELF for nixos...
	patchelf --set-interpreter $(patchelf --print-interpreter $(which python)) addons/pythonscript/x11-64/bin/python3
	patchelf --set-interpreter $(patchelf --print-interpreter $(which godot)) xterminate.x86_64
	patchelf --set-rpath $(patchelf --print-rpath $(which godot)):$(patchelf --print-rpath $(which pulseaudio)) xterminate.x86_64
	patchelf --set-rpath $(patchelf --print-rpath $(which godot)):$(patchelf --print-rpath $(which pulseaudio)) libgodot-xterm.linux.*.so
	echo ELF patched!
}

generate_export() {
	target=$1
	echo "Exporting target $target"

	if [ $target = "nixos-64" ]
	then
		preset="x11-64"
	else
		preset=$target
	fi

	case $preset in
		x11*)
			libsuffix="so"
			;&
		x11-64)
	      		suffix="x86_64"
	      		;;
	        x11-32)
	      		suffix="x86"
	      		;;
	        osx-64)
			libsuffix="dylib"
	      		suffix="zip"
			;;
	        windows*)
			libsuffix="dll"
	      		suffix="exe"
	      		;;
	        *)
	      		echo "Unknown preset: $preset!"
	      		exit 1
	      		;;
	esac

	tmpdir=export/xterminate.${target}
	rm -rf $tmpdir
	mkdir -p $tmpdir

	godot-headless --export-pack "$preset" ${tmpdir}/pack.zip
	godot-headless --export "$preset" ${tmpdir}/xterminate.${suffix}
	
	cd $tmpdir

	if [ $preset = "osx-64" ]
	then
		fixup_osx
	else
		unzip pack.zip
		rm -rf addons/pythonscript
		mkdir addons/pythonscript
		cp -L -r ../../thirdparty/godot-python-assetlib-repo/addons/pythonscript/${preset} addons/pythonscript/
		rm pack.zip xterminate.pck

		if [ $target = "nixos-64" ]
		then
			fixup_nixos
		fi
	fi

	cd ..
	zip xterminate.${target}.zip -r xterminate.${target}
	cd ..
	rm -rf $tmpdir
}

if [ -z $1 ]
then
	generate_export nixos-64
	generate_export x11-64
	generate_export osx-64
	generate_export windows-64
else
	generate_export $1
fi
