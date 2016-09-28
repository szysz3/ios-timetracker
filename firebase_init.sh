#!/bin/bash
echo "-- begin firebase_init --"

sed -e "s|{AD_UNIT_ID_FOR_BANNER_TEST}|$AD_UNIT_ID_FOR_BANNER_TEST|" -e "s|{AD_UNIT_ID_FOR_INTERSTITIAL_TEST}|$AD_UNIT_ID_FOR_INTERSTITIAL_TEST|" -e "s/{CLIENT_ID}/$CLIENT_ID/" -e "s/{REVERSED_CLIENT_ID}/$REVERSED_CLIENT_ID/" -e "s/{API_KEY}/$API_KEY/" -e "s/{GCM_SENDER_ID}/$GCM_SENDER_ID/" -e "s/{PROJECT_ID}/$PROJECT_ID/" -e "s/{STORAGE_BUCKET}/$STORAGE_BUCKET/" -e "s/{GOOGLE_APP_ID}/$GOOGLE_APP_ID/" -e "s|{DATABASE_URL}|$DATABASE_URL|" GoogleService-Info.plist > GoogleService-Info-temp.plist
mv GoogleService-Info-temp.plist GoogleService-Info.plist

cat GoogleService-Info.plist

echo "-- end firebase_init"
