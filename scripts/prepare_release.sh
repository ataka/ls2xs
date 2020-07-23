#!/usr/bin/env bash

echo    "Input release version:"
echo -n "? "

read version
git checkout -b release/$version

version_swift=Sources/ls2xs/version.swift
sed -ie "s/\( *static let value = \"\)[^\"]*\"/\1$version\"/" $version_swift
git add $version_swift
git commit -m "Set version $version"
