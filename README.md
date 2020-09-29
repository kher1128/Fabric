OJT - SmartM2M
---
환경
---
![스크린샷 2020-09-29 오후 1 56 15](https://user-images.githubusercontent.com/38308305/94514190-8b765680-025b-11eb-87f4-121f319eece5.png)

구조도
---
<img src="https://user-images.githubusercontent.com/38308305/94513480-bfe91300-0259-11eb-9462-6bac6199cc46.png">
---
# CA 3개 , Orderer 3개, 조직 3개, 조직별로 peer 2개, 채널 3개

> cd youngwookim

> ./ojt.sh restart

> docker-compose up -d

#채널, 체인코드 설치
___

> export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/youngwookim.com/orderers/orderer2.youngwookim.com/msp/tlscacerts/tlsca.youngwookim.com-cert.pem

> peer channel create -o orderer2.youngwookim.com:7050 -c rc -f ./channel-artifacts/researchchannel.tx --tls --cafile $ORDERER_CA

> peer channel create -o orderer2.youngwookim.com:7050 -c pc -f ./channel-artifacts/productionchannel.tx --tls --cafile $ORDERER_CA

> peer channel join -b rc.block --tls --cafile $ORDERER_CA

> peer channel join -b pc.block --tls --cafile $ORDERER_CA

> peer chaincode install -n mycc -v 1.0 -p github.com/chaincode/chaincode_example02/go/

> peer chaincode instantiate -o orderer2.youngwookim.com:7050 --tls --cafile $ORDERER_CA -C rc -n mycc -v 1.0 -c '{"Args":["init","a", "100", "b","200"]}'

> peer chaincode instantiate -o orderer2.youngwookim.com:7050 --tls --cafile $ORDERER_CA -C pc -n mycc -v 1.0 -c '{"Args":["init","a", "100", "b","200"]}' 

...
