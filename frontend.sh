#!/bin/sh

# Create a stub AMD-based frontend project with RequireJS and jQuery
# 
# Copyright (c)2012 by Monwara LLC / Banko Vukelic <branko@monwara.com>
# All rights reserved
# v0.0.1
#
# Licensed under GPLv3
# http://www.gnu.org/licenses/gpl-3.0.txt

# Prelude

echo frontend.sh - Stub AMD frontend creation
echo version 0.0.1
echo
echo Licensed under GNU GPL v3 license
echo http://www.gnu.org/licenses/gpl-3.0.txt
echo

# Helper functions

function print_usage {
    echo Basic usage:
    echo
    echo    frontend.sh DIR
    echo
    echo  DIR     Required, directory in which to create the AMD stub
    echo
    echo  -h      Prints this message
    echo  --help
    echo
}

# Check command line args

if [ $# -lt 1 ]
then
    echo ERROR: Missing command line argument
    echo
    print_usage
    exit 1
fi

if [ $1 == '-h' -o $1 == '--help' ]
then
    print_usage
    exit 0
fi

if [ ! -d $1 ]
then
    mkdir -p $1
fi

echo Creating stub AMD project in $1

# Remember current directory
cwdir=`pwd`

# Chdir to project directory
cd $1

# Directory structure
echo -n Creating directory structure...
mkdir -p js/lib js/templates js/i18n css img
echo done

echo
read -rp "Please provide the page title (default: 'AMD project'): " page_title

if [ -z $page_title ]
then
    page_title="AMD project"
fi

echo -n Creating stub index.html...
echo -e "<!doctype html>
<html>
  <head>
    <title>$page_title</title>
    <link rel=\"stylesheet\" href=\"css/main.css\">
    <script src=\"js/require.js\" data-main=\"js/boot\"></script>
  </head>
  <body></body>
</html>" >> index.html
echo done

echo Downloading files

echo -n "* require.js (1.0.7)..."
curl -so js/require.js http://requirejs.org/docs/release/1.0.7/comments/require.js
echo done

echo -n "* text.js (1.0.7)..."
curl -so js/text.js http://requirejs.org/docs/release/1.0.7/comments/text.js
echo done

echo -n "* i18n.js (1.0.7)..."
curl -so js/i18n.js http://requirejs.org/docs/release/1.0.0/comments/i18n.js
echo done

echo -n "* jquery.js (1.7.2)..."
curl -so js/jquery.js http://code.jquery.com/jquery-1.7.2.js
echo done

echo -n Creating stub build config...
echo "({
  appDir: '.',
  baseUrl: 'js',
  dir: '../build',
  uglify: {
    top_level: false,
    ascii_only: false,
    beautify: false
  },
  optimizeCss: 'standard',
  inlineText: true,
  findNestedDependencies: true,
  modules: [
    {name: 'boot', path: 'js/boot'}
  ]
})" >> app.build
echo done

echo -n Creating makefile...
echo -e "build:
\tr.js -o app.build
" >> Makefile
echo done

echo -n Creating miscellaneous stub files...
touch css/main.css
echo -e "define(function(require) {
  var $ = require('jquery');
  
  // Your code goes here
});" >> js/boot.js
if [ ! -e .gitignore ]
then
    echo -e "*.swp\n*.swo\n*~\n" >> .gitignore
fi
echo done

echo All finished. Happy hacking!
cd $cwdir
