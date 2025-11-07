#!/bin/bash

HOMEBREW_NO_AUTO_UPDATE=1
INSTALLED_FORMULAS_LIST=/tmp/kde/installed_formulas
KDE_CASKS_LIST=/tmp/kde/installed_casks
mkdir -p /tmp/kde/

brew ls --formula --full-name > "${INSTALLED_FORMULAS_LIST}"

if grep -q '^bomberfish/kde' "${INSTALLED_FORMULAS_LIST}"; then
	echo "Uninstalling formulas from bomberfish/kde tap"
	brew uninstall -f `grep '^bomberfish/kde' "${INSTALLED_FORMULAS_LIST}"`
else
	echo "No formulas from bomberfish/kde tap is installed"
fi

CORE_FORMULAS=(
	threadweaver
	kdoctools
	ki18n
	karchive
	bomberfish/kde/kf5-cmake-modules
)

echo "Removing KDE formulas from homebrew/core if any installed"

for CORE_FORMULA in "${CORE_FORMULAS[@]}"; do
	if grep -q "${CORE_FORMULA}" "${INSTALLED_FORMULAS_LIST}"; then
		brew uninstall -f --formula "${CORE_FORMULA}"
	fi
done

brew ls --cask --full-name | grep '^bomberfish/kde' > "${KDE_CASKS_LIST}"

if [[ -f "${KDE_CASKS_LIST}" ]]; then
	echo "Uninstalling casks from bomberfish/kde tap"
	xargs brew uninstall -f < "${KDE_CASKS_LIST}"
else
	echo "No casks from bomberfish/kde tap is installed"
fi

rm "${INSTALLED_FORMULAS_LIST}" "${KDE_CASKS_LIST}"
# echo "Cleaning ~/Applications/KDE"
# rm -rf "${HOME}"/Applications/KDE
