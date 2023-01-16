#!/bin/bash

set -e

mute=">/dev/null 2>&1"
if [[ "$1" == "-v" ]]; then
	mute=
fi

cwd="$(dirname "${BASH_SOURCE[0]}")"

build_sqlcipher() {
	local tempdir
	tempdir="$(mktemp -d)"
	trap 'rm -rf "$tempdir"' EXIT

	sqlcipher_path="${cwd}/Sources/SQLCipher"
	local header_path="${sqlcipher_path}/include/sqlite3.h"
	local impl_path="${sqlcipher_path}/sqlite3.c"

	printf '%s' "Cloning SQLCipher ... "
	eval git clone https://github.com/sqlcipher/sqlcipher.git "$tempdir" "$mute"
	echo "✅"

	export GIT_DIR="${tempdir}/.git"
	sqlcipher_tag="$(git describe --tags --abbrev=0)"
	eval git checkout "$(git describe --tags --abbrev=0)" "$mute"
	unset GIT_DIR
	echo "Checked out SQLCipher latest tag: $sqlcipher_tag"

	eval pushd "$tempdir" "$mute" || { echo "pushd failed"; exit 1; }

	printf '%s' "Configuring SQLCipher ... "
	eval ./configure --with-crypto-lib=none "$mute"
	echo "✅"

	printf '%s' "Building SQLCipher ... "
	ncpu=$(sysctl -n hw.ncpu 2>/dev/null || echo "1")
	eval make -j"${ncpu}" sqlite3.c "$mute"
	echo "✅"

	eval popd "$mute" || { echo "popd failed"; exit 1; }

	printf '%s' "Moving SQLCipher artifacts into place ... "
	rm -f "$header_path" "$impl_path"
	mkdir -p "${sqlcipher_path}/include"
	cp -f "${tempdir}/sqlite3.h" "$header_path"
	cp -f "${tempdir}/sqlite3.c" "${impl_path}.tmp"
	echo "✅"

	# Including param.h unconditionally removes compile time
	# warnings about ambiguous MIN and MAX macros.
	printf '%s' "Patching sqlite.c ... "
	echo "#include <sys/param.h>" > "$impl_path"
	cat "${impl_path}.tmp" >> "$impl_path"
	rm -f "${impl_path}.tmp"
	echo "✅"
}

update_sqlcipher_config() {
	sed -e 's:<SQLCipher/sqlite3.h>:"sqlite3.h":' "${cwd}/Support/SQLCipher_config.h" \
	    > "${sqlcipher_path}/include/SQLCipher_config.h"
	git add "${sqlcipher_path}/include/SQLCipher_config.h"
	echo "Adjusted SQLCipher_config.h ✅"
}

update_readme() {
	current_version="$(git describe --tags --abbrev=0 --exclude=v* origin/SQLCipher)"
	current_upstream_version="$(grep '\* GRDB' .github/README.md | cut -d '*' -f 3)"
	current_sqlcipher_version="$(grep '\* SQLCipher' .github/README.md | cut -d '*' -f 3)"
	grdb_tag="$(git describe --tags --abbrev=0 --match=v* upstream-master)"

	export new_version upstream_version="${grdb_tag#v}" sqlcipher_version="${sqlcipher_tag#v}"

	if [[ "${current_upstream_version}" == "${upstream_version}" ]] && \
		[[ "${current_sqlcipher_version}" == "${sqlcipher_version}" ]]; then
		echo "GRDB.swift (${upstream_version}) and SQLCipher (${sqlcipher_version}) versions did not change. Skipping release."
		exit 1
	fi

	cat <<- EOF

	DuckDuckGo GRDB.swift current version: ${current_version}
	Upstream GRDB.swift version: ${current_upstream_version} -> ${upstream_version}
	SQLCipher version: ${current_sqlcipher_version} -> ${sqlcipher_version}
	EOF

	while ! [[ "${new_version}" =~ [0-9]\.[0-9]\.[0-9] ]]; do
		read -rp "Input DuckDuckGo GRDB.swift desired version number (x.y.z): " new_version < /dev/tty
	done

	envsubst < "${cwd}/.github/README.md.in" > "${cwd}/.github/README.md"
	git add "${cwd}/.github/README.md"

	echo "Updated .github/README.md ✅"
}

build_and_test_release() {
	echo "Testing the build ..."
	rm -rf "${cwd}/.build"
	# The skipped test references a test database added with a podfile.
	# We're safe to disable it since we don't care about SQLCipher 3 compatibility anyway.
	swift test --skip "EncryptionTests.testSQLCipher3Compatibility"

	echo ""
	swift build -c release

	cat <<- EOF

	SQLCipher ${sqlcipher_tag} is ready to use with GRDB.swift ${grdb_tag} 🎉

	EOF
}

setup_new_release_branch() {
	echo "Setting up new release branch ..."

	local release_branch="release/${new_version}"

	git checkout -b "$release_branch"
	git add "${cwd}/.github/README.md" "$sqlcipher_path"
	git commit -m "DuckDuckGo GRDB.swift ${new_version} (GRDB ${upstream_version}, SQLCipher ${sqlcipher_version})"

	cat <<- EOF

	Release is prepared on branch ${release_branch}.
	Push the branch when ready and follow .github/README.md for release instructions.
	EOF
}

main() {
	build_sqlcipher
	update_sqlcipher_config
	update_readme
	build_and_test_release
	setup_new_release_branch
}

main
