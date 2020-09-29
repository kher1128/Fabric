#!/bin/bash
rootdir="$( cd "$(dirname "$0")" ; pwd -P )"

function vscode_usage
{
    echo "========================================================================="
    echo " "
    echo "-------------------------------------------------------------------------"
    echo " Commands"
    echo " - up"
    echo " - down"
    echo ""
}

function restart
{
    echo "delete crypto config"
    rm -rf crypto-config
    echo "delete channel tx and genesis block"
    rm -rf ./channel-artifacts/*

    echo "remake cryptogen"

    ../bin/cryptogen generate --config=./crypto-config.yaml

    echo "remake genesis block"
    ../bin/configtxgen -profile MainChain -outputBlock ./channel-artifacts/genesis.block
    echo "remake channel transaction"

    ../bin/configtxgen -profile DevChannel -outputCreateChannelTx ./channel-artifacts/devchannel.tx -channelID dc
    ../bin/configtxgen -profile ResearchChannel -outputCreateChannelTx ./channel-artifacts/researchchannel.tx -channelID rc
    ../bin/configtxgen -profile ProductionChannel -outputCreateChannelTx ./channel-artifacts/productionchannel.tx -channelID pc

}

function recompose
{
    echo "dockder-compose down"
    docker-compose down
    echo "stop docker"
    docker stop $(docker ps -a -q)
    docker rm -f $(docker ps -a -q)
    echo "docker volume prune"
    docker volume prune
    echo "recompose"
    docker-compose up -d
}

function cryptogen
{
    cmd="../bin/cryptogen generate --config=./crypto-config.yaml"
    echo $cmd
    cmd

}

function down {
    echo "stop docker"
    docker stop $(docker ps -a -q)
    docker rm -f $(docker ps -a -q)
    echo "dockder-compose down"
    docker-compose down
    echo "docker volume prune"
    docker volume prune
}

# function all
# {   
#     clean
#     cryptogen
#     configtxgen
#     docker up
#     channel create
#     channel join

#     chain in
#     inst
#     invoke
# }

function main
{

    case $1 in
        cryptogen | configtxgen | down | restart | recompose )
            fun=$1
            shift
            $fun $@
            ;;
        *)
            vscode_usage
			exit
            ;;
    esac
}

main $@

