# zhengrr
# 2024-04-05 – 2024-04-05
# MIT License
set quiet
set shell := ['nu', '--commands']
shebang := if os() == 'windows' { 'nu' } else { '/usr/bin/env nu' }

# 默认配方：列出可用配方
[private]
default:
	just --list \
		--justfile '{{justfile()}}' \
		--unsorted

# 清除
clean:
	rm --recursive --force --permanent `dist/*`

# 编译
build: (clean)
	#!{{shebang}}
	cd '{{justfile_directory()}}'

	mkdir 'dist'
	cp --recursive --verbose `src/*` 'dist'

	'[ToolSet]
	OrgYmlPath={{justfile_directory()}}\src\localisation
	ModYmlPath={{justfile_directory()}}\dist\localisation' | save --force 'tools/EU4HHTOOL/EU4HHTOOL.ini'

	do { tools/EU4HHTOOL/EU4HHTOOL.exe } | complete

	exit 0

# 应用
apply:
	#!{{shebang}}
	cd '{{justfile_directory()}}'

	let mod_dist_path  = pwd | path join 'dist' | str replace --all '\' '/'
	let mod_index_path = $env.USERPROFILE | path join 'Documents' 'Paradox Interactive' 'Europa Universalis IV' 'mod' "o_baka's EU4.mod"
	cp 'src/descriptor.mod' $mod_index_path

	$'
	path="($mod_dist_path)"
	' | save $mod_index_path --append
