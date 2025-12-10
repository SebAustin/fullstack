#!/bin/bash

echo "🧪 Testing Udagram API..."
echo ""

API_URL="http://udagram-api-dev.eba-t7kwpbwm.us-east-1.elasticbeanstalk.com"

echo "📡 Testing feed endpoint..."
RESPONSE=$(curl -s -w "\n%{http_code}" "$API_URL/api/v0/feed")
HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ Feed endpoint working! (HTTP $HTTP_CODE)"
    echo "Response: $BODY"
else
    echo "❌ Feed endpoint failed (HTTP $HTTP_CODE)"
    echo "Response: $BODY"
fi

echo ""
echo "🏥 Checking EB environment status..."
cd "udagram/udagram-api"
eb status | grep -E "(CNAME|Status|Health)"

echo ""
echo "📋 Checking environment variables..."
eb printenv 2>&1 | grep -E "(POSTGRES|AWS|JWT|URL|PORT)" || echo "⚠️  No environment variables set - configure via AWS Console"

