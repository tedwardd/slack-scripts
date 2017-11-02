#!/usr/bin/env bash
#
# Grab all emoji shortcuts and make ~/.weechat/weemoji.conf with custom emojis
# Set $SLACK_TKN in your environment to your Slack API token

TMP="${HOME}/tmp"
[[ -d "${TMP}" ]] || mkdir "${TMP}"
[[ -z "${SLACK_TKN}" ]] && (echo 'Missing $SLACK_TKN, Aborting.'; exit 1)

curl -X GET -H "Authorization: Bearer ${SLACK_TKN}" -H 'Content-type: application/json' https://slack.com/api/emoji.list | jq -r '.emoji | keys' | tail -n+2 | sed -e '$ d' | sed '$s/$/,/' > "${TMP}/custom.emoji"

cat <<EOF > "${HOME}/.weechat/weemoji.json.new"
{
    "emoji": [
EOF
cat "${TMP}/custom.emoji" "${HOME}/.weechat/weemoji.defaults" >> "${HOME}/.weechat/weemoji.json.new"

cat <<EOF >> "${HOME}/.weechat/weemoji.json.new"
    ]
}
EOF

rm -f "${TMP}/custom.emoji"
mv "${HOME}/.weechat/weemoji.json.new" "${HOME}/.weechat/weemoji.json"
