#!/bin/bash

DEFAULT_NAME="WordPress Plugin Template"
DEFAULT_CLASS=${DEFAULT_NAME// /_}
DEFAULT_TOKEN=$( tr '[A-Z]' '[a-z]' <<< $DEFAULT_CLASS)
DEFAULT_SLUG=${DEFAULT_TOKEN//_/-}

printf "Plugin name (required): "
read NAME

if [[ -z "${NAME// }" ]]; then
	echo "A plugin name is required. Exiting."
	exit
fi

CLASS=${NAME// /_}
TOKEN=$( tr '[A-Z]' '[a-z]' <<< $CLASS)
SLUG=${TOKEN//_/-}

printf "Destination folder (required): "
read FOLDER

if [[ -z "${FOLDER// }" ]]; then
	echo "A folder is required. Exiting."
	exit
fi
if [[ -d "${FOLDER}/${SLUG}" && ! -z "$(ls -A ${FOLDER}/${SLUG})" ]]; then
	echo "The target folder ${FOLDER}/${SLUG} exists and is not empty. Exiting."
	exit
fi

printf "Author name (required): "
read AUTHOR_NAME

if [[ -z "${FOLDER// }" ]]; then
	echo "An author name is required. Exiting."
	exit
fi

printf "Plugin URL (optional): "
read PLUGIN_URL

printf "Author URL (optional): "
read AUTHOR_URL

printf "Contributors (optional - defaults to '${AUTHOR_NAME}'): "
read CONTRIBUTORS

printf "Text Domain (optional - defaults to '${SLUG}'): "
read TEXT_DOMAIN

printf "Include Grunt support (Y/n): "
read GRUNT

printf "Initialise new git repo (y/N): "
read NEWREPO

TODAYS_DATE=$(date +%Y-%m-%d)

if [[ -z "${TEXT_DOMAIN// }" ]]; then
	TEXT_DOMAIN=$SLUG
fi

if [[ -z "${CONTRIBUTORS// }" ]]; then
	CONTRIBUTORS=$AUTHOR_NAME
fi

tmpdir_name=$(mktemp -d "${TMPDIR:-/tmp}"/${DEFAULT_SLUG}_XXXXXX)
cp -R . $tmpdir_name
mkdir -p "${FOLDER}/${SLUG}"

if [[ ! -w "${FOLDER}/${SLUG}" ]]; then
	echo "The target folder ${FOLDER}/${SLUG} is not writeable. Exiting."
	rm -rf $tmpdir_name
	exit
fi

cp -R "${tmpdir_name}/" "${FOLDER}/${SLUG}"
rm -rf $tmpdir_name

cd "${FOLDER}/${SLUG}"

echo "Removing git files..."

rm -rf .git
rm README.md
rm build-plugin.sh
rm changelog.txt

if [ "$GRUNT" == "n" ]; then
	rm Gruntfile.js
	rm package.json
fi

echo "Updating plugin files..."

mv $DEFAULT_SLUG.php $SLUG.php

cp $SLUG.php $SLUG.tmp
sed "s/$DEFAULT_NAME/$NAME/g" $SLUG.tmp > $SLUG.php
rm $SLUG.tmp

cp $SLUG.php $SLUG.tmp
sed "s/$DEFAULT_SLUG/$SLUG/g" $SLUG.tmp > $SLUG.php
rm $SLUG.tmp

cp $SLUG.php $SLUG.tmp
sed "s/$DEFAULT_TOKEN/$TOKEN/g" $SLUG.tmp > $SLUG.php
rm $SLUG.tmp

cp $SLUG.php $SLUG.tmp
sed "s/$DEFAULT_CLASS/$CLASS/g" $SLUG.tmp > $SLUG.php
rm $SLUG.tmp

cp $SLUG.php $SLUG.tmp
if [[ -z "${PLUGIN_URL// }" ]]; then
	sed "/__PLUGIN_URL__/d" $SLUG.tmp > $SLUG.php
else
	sed "s/__PLUGIN_URL__/$(echo $PLUGIN_URL | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" $SLUG.tmp > $SLUG.php
fi
rm $SLUG.tmp

cp $SLUG.php $SLUG.tmp
sed "s/__PLUGIN_NAME__/$(echo $NAME | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" $SLUG.tmp > $SLUG.php
rm $SLUG.tmp

cp $SLUG.php $SLUG.tmp
sed "s/__AUTHOR_NAME__/$(echo $AUTHOR_NAME | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" $SLUG.tmp > $SLUG.php
rm $SLUG.tmp

cp $SLUG.php $SLUG.tmp
if [[ -z "${AUTHOR_URL// }" ]]; then
	sed "/__AUTHOR_URL__/d" $SLUG.tmp > $SLUG.php
else
	sed "s/__AUTHOR_URL__/$(echo $AUTHOR_URL | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" $SLUG.tmp > $SLUG.php
fi
rm $SLUG.tmp

cp $SLUG.php $SLUG.tmp
sed "s/__TEXT_DOMAIN__/$(echo $TEXT_DOMAIN | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" $SLUG.tmp > $SLUG.php
rm $SLUG.tmp

cp readme.txt readme.tmp
sed "s/$DEFAULT_NAME/$NAME/g" readme.tmp > readme.txt
rm readme.tmp

cp readme.txt readme.tmp
sed "s/__CONTRIBUTORS__/$(echo $CONTRIBUTORS | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" readme.tmp > readme.txt
rm readme.tmp

cp readme.txt readme.tmp
if [[ -z "${AUTHOR_URL// }" ]]; then
	sed "/__AUTHOR_URL__/d" readme.tmp > readme.txt
else
	sed "s/__AUTHOR_URL__/$(echo $AUTHOR_URL | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" readme.tmp > readme.txt
fi
rm readme.tmp

cp readme.txt readme.tmp
sed "s/__TODAYS_DATE__/$TODAYS_DATE/g" readme.tmp > readme.txt
rm readme.tmp

if [ "$GRUNT" != "n" ]; then

	cp package.json package.tmp
	if [[ -z "${PLUGIN_URL// }" ]]; then
		sed "/__PLUGIN_URL__/d" package.tmp > package.json
	else
		sed "s/__PLUGIN_URL__/$(echo $PLUGIN_URL | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" package.tmp > package.json
	fi
	rm package.tmp

	cp package.json package.tmp
	sed "s/__AUTHOR_NAME__/$(echo $AUTHOR_NAME | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" package.tmp > package.json
	rm package.tmp

	cp package.json package.tmp
	sed "s/$DEFAULT_NAME/$NAME/g" package.tmp > package.json
	rm package.tmp

	cp package.json package.tmp
	sed "s/$DEFAULT_SLUG/$SLUG/g" package.tmp > package.json
	rm package.tmp
fi

cd languages
mv $DEFAULT_SLUG.pot $SLUG.pot

cp $SLUG.pot $SLUG.tmp
sed "s/$DEFAULT_NAME/$NAME/g" $SLUG.tmp > $SLUG.pot
rm $SLUG.tmp

cp $SLUG.pot $SLUG.tmp
sed "s/$DEFAULT_CLASS/$CLASS/g" $SLUG.tmp > $SLUG.pot
rm $SLUG.tmp

cp $SLUG.pot $SLUG.tmp
sed "s/$DEFAULT_TOKEN/$TOKEN/g" $SLUG.tmp > $SLUG.pot
rm $SLUG.tmp

cp $SLUG.pot $SLUG.tmp
sed "s/$DEFAULT_SLUG/$SLUG/g" $SLUG.tmp > $SLUG.pot
rm $SLUG.tmp


cd ../includes
mv class-$DEFAULT_SLUG.php class-$SLUG.php

cp class-$SLUG.php class-$SLUG.tmp
sed "s/$DEFAULT_CLASS/$CLASS/g" class-$SLUG.tmp > class-$SLUG.php
rm class-$SLUG.tmp

cp class-$SLUG.php class-$SLUG.tmp
sed "s/$DEFAULT_TOKEN/$TOKEN/g" class-$SLUG.tmp > class-$SLUG.php
rm class-$SLUG.tmp

cp class-$SLUG.php class-$SLUG.tmp
sed "s/$DEFAULT_SLUG/$SLUG/g" class-$SLUG.tmp > class-$SLUG.php
rm class-$SLUG.tmp


mv class-$DEFAULT_SLUG-settings.php class-$SLUG-settings.php

cp class-$SLUG-settings.php class-$SLUG-settings.tmp
sed "s/$DEFAULT_CLASS/$CLASS/g" class-$SLUG-settings.tmp > class-$SLUG-settings.php
rm class-$SLUG-settings.tmp

cp class-$SLUG-settings.php class-$SLUG-settings.tmp
sed "s/$DEFAULT_TOKEN/$TOKEN/g" class-$SLUG-settings.tmp > class-$SLUG-settings.php
rm class-$SLUG-settings.tmp

cp class-$SLUG-settings.php class-$SLUG-settings.tmp
sed "s/$DEFAULT_SLUG/$SLUG/g" class-$SLUG-settings.tmp > class-$SLUG-settings.php
rm class-$SLUG-settings.tmp


cd lib
mv class-$DEFAULT_SLUG-post-type.php class-$SLUG-post-type.php

cp class-$SLUG-post-type.php class-$SLUG-post-type.tmp
sed "s/$DEFAULT_CLASS/$CLASS/g" class-$SLUG-post-type.tmp > class-$SLUG-post-type.php
rm class-$SLUG-post-type.tmp

cp class-$SLUG-post-type.php class-$SLUG-post-type.tmp
sed "s/$DEFAULT_TOKEN/$TOKEN/g" class-$SLUG-post-type.tmp > class-$SLUG-post-type.php
rm class-$SLUG-post-type.tmp

cp class-$SLUG-post-type.php class-$SLUG-post-type.tmp
sed "s/$DEFAULT_SLUG/$SLUG/g" class-$SLUG-post-type.tmp > class-$SLUG-post-type.php
rm class-$SLUG-post-type.tmp


mv class-$DEFAULT_SLUG-taxonomy.php class-$SLUG-taxonomy.php

cp class-$SLUG-taxonomy.php class-$SLUG-taxonomy.tmp
sed "s/$DEFAULT_CLASS/$CLASS/g" class-$SLUG-taxonomy.tmp > class-$SLUG-taxonomy.php
rm class-$SLUG-taxonomy.tmp

cp class-$SLUG-taxonomy.php class-$SLUG-taxonomy.tmp
sed "s/$DEFAULT_TOKEN/$TOKEN/g" class-$SLUG-taxonomy.tmp > class-$SLUG-taxonomy.php
rm class-$SLUG-taxonomy.tmp

cp class-$SLUG-taxonomy.php class-$SLUG-taxonomy.tmp
sed "s/$DEFAULT_SLUG/$SLUG/g" class-$SLUG-taxonomy.tmp > class-$SLUG-taxonomy.php
rm class-$SLUG-taxonomy.tmp


mv class-$DEFAULT_SLUG-admin-api.php class-$SLUG-admin-api.php

cp class-$SLUG-admin-api.php class-$SLUG-admin-api.tmp
sed "s/$DEFAULT_CLASS/$CLASS/g" class-$SLUG-admin-api.tmp > class-$SLUG-admin-api.php
rm class-$SLUG-admin-api.tmp

cp class-$SLUG-admin-api.php class-$SLUG-admin-api.tmp
sed "s/$DEFAULT_TOKEN/$TOKEN/g" class-$SLUG-admin-api.tmp > class-$SLUG-admin-api.php
rm class-$SLUG-admin-api.tmp

cp class-$SLUG-admin-api.php class-$SLUG-admin-api.tmp
sed "s/$DEFAULT_SLUG/$SLUG/g" class-$SLUG-admin-api.tmp > class-$SLUG-admin-api.php
rm class-$SLUG-admin-api.tmp


if [ "$NEWREPO" == "y" ]; then
	echo "Initialising new git repo..."
	cd ../..
	git init
fi

echo "Complete!"
