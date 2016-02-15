#!/bin/bash
INFOPLIST_FILE="OpenCLKit/Info.plist"
VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${INFOPLIST_FILE}")
TMP_DIR="/tmp/docset_build"
BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ ! "${BRANCH}" == "master" ]
then
	echo "Documentation should be generated from master branch"
	exit 1
fi

echo "Building documentation for $VERSION"
rm -rf "${TMP_DIR}"
mkdir -p "${TMP_DIR}"

appledoc \
	--project-name "OpenCLKit" \
	--project-company "Jan-Gerd Tenberge" \
	--company-id com.jan-gerd \
	-v "${VERSION}" \
	--no-create-docset \
	-h \
	-o "${TMP_DIR}/html" \
	.

appledoc \
	--project-name "OpenCLKit" \
	--project-company "Jan-Gerd Tenberge" \
	--company-id com.jan-gerd \
	--docset-feed-url "https://janten.github.io/OpenCLKit/doc/feed.atom" \
	--docset-package-url "https://janten.github.io/OpenCLKit/doc/%VERSION/OpenCLKit.xar" \
	--docset-package-filename "OpenCLKit" \
	-v "${VERSION}" \
	--no-create-docset \
	-u \
	-o "${TMP_DIR}/docset" \
	.

if git checkout gh-pages
then
	git pull
	rm -rf "doc/${VERSION}/"
	mkdir -p "doc/${VERSION}/"
	mv ${TMP_DIR}/html/html/* "doc/${VERSION}/"
	mv ${TMP_DIR}/docset/publish/*.atom "doc/feed.atom"
	mv ${TMP_DIR}/docset/publish/OpenCLKit.xar "doc/${VERSION}/"
	
	git add .
	git commit -m "Update documentation for version ${VERSION}"
	git push -u origin gh-pages
	git checkout "${BRANCH}"
else
	echo "Could not switch to branch gh-pages"
fi

rm -rf "${TMP_DIR}"
