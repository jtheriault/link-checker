#!/bin/sh
set -uo pipefail

LINKCHECKER_OUTPUT_DIR=${LINKCHECKER_OUTPUT_DIR:="link-checker"}
LINKCHECKER_OUTPUT_FILENAME=${LINKCHECKER_OUTPUT_FILENAME:="out.md"}

# Make the temp directory
mkdir -p /tmp/link-checker

# Execute Liche
liche "$@" >/tmp/link-checker/out 2>&1
exit_code=$?

# If link errors were found output a report to the designated directory
if [ $exit_code -eq 1 ]; then
    mkdir -p $LINKCHECKER_OUTPUT_DIR
    cat << EOF > $LINKCHECKER_OUTPUT_DIR/$LINKCHECKER_OUTPUT_FILENAME
### Link Checker:
Errors were reported while checking the connectivity of links.
\`\`\`
$(cat /tmp/link-checker/out)
\`\`\`
EOF
    echo "Link checker output file: $LINKCHECKER_OUTPUT_DIR/$LINKCHECKER_OUTPUT_FILENAME"
fi

# Output to console
cat /tmp/link-checker/out

# Pass Liche exit code to next step
echo ::set-output name=exit_code::$exit_code
