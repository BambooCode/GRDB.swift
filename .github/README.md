# GRDB + SQLCipher 

## What is this?
This is a fork of [GRDB](https://github.com/groue/GRDB.swift) which contains a [SQLCipher Community Edition](https://www.zetetic.net/sqlcipher/open-source/) amalgamation packaged so that it can be consumed as a Swift Package.

The default branch for this repository is `SQLCipher` so that we can more easily pull upstream changes if we need to.

## Versioning

* This Package: *2.0.0*
* GRDB: *7.9.0*
* SQLCipher: *4.7.0*

## Contributions
We do not accept contributions to this repository at this time.  However, feel free to open an issue in order to start a discussion.

## We are hiring!
DuckDuckGo is growing fast and we continue to expand our fully distributed team. We embrace diverse perspectives, and seek out passionate, self-motivated people, committed to our shared vision of raising the standard of trust online. If you are a senior software engineer capable in either iOS or Android, visit our [careers](https://duckduckgo.com/hiring/#open) page to find out more about our openings!

## Updating from Upstream

Add remote upstream:

* `git remote add upstream git@github.com:groue/GRDB.swift.git`

Check out upstream's master branch locally:

* `git fetch upstream +master:upstream-master && git checkout upstream-master`

Update upstream's master branch if needed:

* `git pull upstream master`

Switch back to the `SQLCipher` branch and merge with upstream-master:

* `git merge upstream-master`

Resolve any conflicts that may occur (normally there should be none or only in Package.swift)
and commit the merge. Once done, run `prepare_release.sh` script to fetch and compile the latest tag
of SQLCipher and embed it in GRDB.swift:

* `./prepare_release.sh`

The script will also:
* present the summary of updated versions and ask you to pick the new version number for DuckDuckGo GRDB fork,
* test the build,
* create a new release branch and commit changes.

For versioning, follow [Semantic Versioning Rules](https://semver.org), but note you don't need
to use the same version as GRDB. Examples:

* Upstream GRDB 5.6.0, after merge -> 5.12.0
  * This project 1.0.0 -> 1.1.0

* Upstream GRDB 5.12.0, after merge -> 6.0.0
  * This project 1.1.0 -> 2.0.0

If everything looks fine:
* push your branch,
* create PR for BSK referencing the new branch,
* create PRs for iOS and macOS apps referencing your BSK branch.

Once approved:
* merge your branch back to `SQLCipher`,
* create a tag matching the release number **without the 'v' prefix** (those are reserved for upstream),
* push the tag,
* update the reference to GRDB in BSK to point to a tag.

### Compiling SQLCipher manually

In case `prepare_release.sh` script fails, you need to compile SQLCipher amalgamation package
manually. See [general instructions](https://github.com/sqlcipher/sqlcipher#compiling-for-unix-like-systems):

* Use `./configure --with-crypto-lib=none`.
* Remember to use `make sqlite3.c` and not `make`.
* Copy `sqlite3.c` and `sqlite3.h` to `Sources/SQLCipher/sqlite3.c` and `Sources/SQLCipher/include/sqlite3.h`.
