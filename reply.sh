#!/bin/bash

PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
MESSAGE="\
Hello, fellow traveler! Don't lose yourself in this derelict place... \
Join us over at https://mithril.zulipchat.com where life abounds \
and conversations flow.\n\nYes! ... and spread the word around so that others don't get astray." 

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
        postMessage $ROOM_ID
    fi
}

echo $(postIfNeeded 5501985215522ed4b3dd2ac3 MithrilJS/mithril.js)
echo $(postIfNeeded 5441311bdb8155e6700cc6f7 MithrilJS/mithril-node-render)
