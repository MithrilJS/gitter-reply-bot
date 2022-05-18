#!/bin/bash

PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
MESSAGE="\
Hello, fellow traveler, before you lose yourself in this derelict place, \
I'll enjoin you to swiftly go to https://mithril.zulip.com where life abounds \
and conversations flow.\n\nAlso, please spread the word around so that others don't get astray... \
update the old links that lead you here, or signal the issue to those who can." 

GANDALF_ID='57a33f9b40f3a6eec05deab8'

function getLastMessageUserIdForRoom() {
    ROOM_ID=$1
    curl \
        -H "Accept: application/json" \
        -H "Authorization: Bearer $GANDALF_GITTER_TOKEN" \
        "https://api.gitter.im/v1/rooms/$ROOM_ID/chatMessages?limit=1" \
        | ./json/JSON.sh \
        | grep -Po '"fromUser","id"\]\s*"[^"]*' \
        | grep -Po '[^"]+$'
}

function postMessage() {
    ROOM_ID=$1
    curl -X POST -i \
      -H "Content-Type: application/json" \
      -H "Accept: application/json" \
      -H "Authorization: Bearer $GANDALF_GITTER_TOKEN" \
      "https://api.gitter.im/v1/rooms/$ROOM_ID/chatMessages" \
      -d "{\"text\":\"$MESSAGE\"}"
}

function postIfNeeded () {
    ROOM_ID=$1
    ROOM_NAME=$2
    ID=$(getLastMessageUserIdForRoom $ROOM_ID)

    if [[ "$GANDALF_ID" = "$ID" ]]; then
        echo "Nothing to do in $ROOM_NAME"
    else
        echo "Repling to message in $ROOM_NAME"
        # postMessage $ROOM_ID
    fi
}

echo $(postIfNeeded 5501985215522ed4b3dd2ac3 MithrilJS/mithril.js)
echo $(postIfNeeded 5441311bdb8155e6700cc6f7 MithrilJS/mithril-node-render)
