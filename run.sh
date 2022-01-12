#!/bin/bash

export FLASK_APP=iota
export FLASK_ENV=production

export IOTA_INSTANCE_PATH=${IOTA_INSTANCE_PATH:-"/var/iota"}
export IOTA_USER=${IOTA_USER:-"iota"}
export DBFILE=${DBFILE:-"$IOTA_INSTANCE_PATH/iota.sqlite"}
export HOME=$IOTA_INSTANCE_PATH

id $IOTA_USER || adduser --shell /sbin/nologin --system --no-create-home --home /var/iota --group $IOTA_USER

if [[ ! -f "$DBFILE" ]]; then
    cd $IOTA_INSTANCE_PATH
    flask init-db
    if [[ ! -z "$ADMIN_TOKEN" && ${#ADMIN_TOKEN} -ge 32 ]]; then
        echo "Using specified ADMIN_TOKEN"
    else
        echo "Generated new ADMIN_TOKEN"
        ADMIN_TOKEN=$(python3 -c "import nacl.utils; import base64; print(base64.b64encode(nacl.utils.random(64)).decode())")
        echo "#####################################################"
        echo
        echo "ADMIN TOKEN: $ADMIN_TOKEN"
        echo
        echo "#####################################################"
    fi
    HASHED_TOKEN=$(python3 -c "import nacl.pwhash; print(nacl.pwhash.str(b'$ADMIN_TOKEN').decode())")
    sqlite3 "$DBFILE" "UPDATE tokens SET token = '$HASHED_TOKEN' WHERE name = 'admin'"
fi

chown -R "$IOTA_USER" $IOTA_INSTANCE_PATH

exec su -p $IOTA_USER -s /bin/bash -c "waitress-serve --call \"$FLASK_APP:create_app\""
