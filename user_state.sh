while read line
do
user_id=`echo $line |cut -d, -f1`
#query="select email from corporate_user_account where user_id=$user_id;"
#email=`echo "select email from corporate_user_account where user_id=$user_id;"|mysql -ushailendra.patel -p'sh32ilEndraP8801'  -h172.16.3.129 ssodb |sed 1d`

curl -X GET "http://service1.yatra.com/corporate-user-profile-service/services/corporate-address-service/corporate/$user_id/address" -H "accept: application/json" -H "com.yatra.tenant.header.tenantId: 1" > output1
state=`cat output1|jq '.corporateUserAddresses'|jq .[]|jq .state|sed 's/"//g'`
curl -X POST "http://service1.yatra.com/single-signon-service/services/corporate-login-service/corporate/accounts" -H "Content-Type: application/json" -H "com.yatra.tenant.header.tenantId: 1" -d "{\"userIds\":[$user_id]}" > output2
email=`cat output2|jq '.userInfoMap'|jq .[]|jq '.emailId'|sed 's/"//g'`
echo "$user_id","$email","$state" >> user_state.xls
done < user_id

rm -rf output1 output2


