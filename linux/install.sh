#!/bin/bash
stty erase ^H

red='\e[91m'
green='\e[92m'
yellow='\e[94m'
magenta = '\ e [95m'
cyan='\e[96m'
none='\e[0m'
_red() { echo -e ${red}$*${none}; }
_green() { echo -e ${green}$*${none}; }
_yellow() { echo -e ${yellow}$*${none}; }
_magenta() { echo -e ${magenta}$*${none}; }
_cyan() { echo -e ${cyan}$*${none}; }

# Root
[[ $(id -u) != 0 ]] && echo -e "\n Please use ${red}root ${none} user to run ${yellow}~(^_^) ${none}\n" && exit 1

cmd="apt-get"

sys_bit=$(uname -m)

case $sys_bit in
'amd64' | x86_64) ;;
*)
    echo -e "
	 This ${red}install script ${none} does not support your system. ${yellow}(-_-) ${none}

	Note: Only supports Ubuntu 16+ / Debian 8+ / CentOS 7+ systems
	" && exit 1
    ;;
esac

# Stupid detection method
if [[ $(command -v apt-get) || $(command -v yum) ]] && [[ $(command -v systemctl) ]]; then

    if [[ $(command -v yum) ]]; then

        cmd="yum"

    be

else

    echo -e "
	 This ${red}install script ${none} does not support your system. ${yellow}(-_-) ${none}

	Note: Only supports Ubuntu 16+ / Debian 8+ / CentOS 7+ systems
	" && exit 1

be

if [ ! -d "/etc/ccworker/" ]; then
    mkdir /etc/ccworker/
be

error() {

    echo -e "\n$red typo! $none\n"

}

log_config_ask() {
    echo
    while :; do
        echo -e "Whether to enable logging, enter [${magenta}Y/N${none}] and press Enter"
        read -p "$(echo -e "(默认: [${cyan}Y${none}]):")" enableLog
        [[ -z $enableLog ]] && enableLog="y"

        case $enableLog in
        AND | and)
            enableLog="y"
            break
            ;;
        N | n)
            enableLog="n"
            echo
            echo
            echo -e "$yellow do not enable logging $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
}

eth_miner_config_ask() {
    echo
    while :; do
        echo -e "Whether to enable ETH transfer, enter [${magenta}Y/N${none}] and press Enter"
        read -p "$(echo -e "(默认: [${cyan}Y${none}]):")" enableEthProxy
        [[ -z $enableEthProxy ]] && enableEthProxy="y"

        case $enableEthProxy in
        AND | and)
            enableEthProxy="y"
            eth_miner_config
            break
            ;;
        N | n)
            enableEthProxy="n"
            echo
            echo
            echo -e "$yellow do not enable ETH rake transfer $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
}

eth_miner_config() {
    echo
    while :; do
        echo -e "Please enter the ETH mining pool domain name, such as eth.f2pool.com, no need to enter the mining pool port"
        read -p "$(echo -e "(默认: [${cyan}eth.f2pool.com${none}]):")" ethPoolAddress
        [[ -z $ethPoolAddress ]] && ethPoolAddress="eth.f2pool.com"

        case $ethPoolAddress in
        *[:$]*)
            echo
            echo -e "Because this script is too spicy.. so the address of the mining pool cannot contain the port..."
            echo
            error
            ;;
        *)
            echo
            echo
            echo -e "$yellow ETH pool address = ${cyan}$ethPoolAddress${none}"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        esac
    done
    while :; do
        echo -e "Whether to use SSL mode to connect to the ETH mining pool, enter [${magenta}Y/N${none}] and press Enter"
        read -p "$(echo -e "(默认: [${cyan}N${none}]):")" ethPoolSslMode
        [[ -z $ethPoolSslMode ]] && ethPoolSslMode="n"

        case $ethPoolSslMode in
        AND | and)
            ethPoolSslMode="y"
            echo
            echo
            echo -e "$yellow use SSL mode to connect to ETH pool $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        N | n)
            ethPoolSslMode="n"
            echo
            echo
            echo -e "$yellow use TCP mode to connect to ETH pool $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
    while :; do
        if [[ "$ethPoolSslMode" = "y" ]]; then
            echo -e "Please enter the SSL port of the ETH mining pool "$yellow"$ethPoolAddress"$none", do not use the TCP port of the mining pool!!!"
        else
            echo -e "Please enter the TCP port of the ETH mining pool "$yellow"$ethPoolAddress"$none", do not use the SSL port of the mining pool!!!"
        be
        read -p "$(echo -e "(default port: ${cyan}6688${none}):")" ethPoolPort
        [ -z "$ethPoolPort" ] && ethPoolPort=6688
        case $ethPoolPort in
        [1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
            echo
            echo
            echo -e "$yellow ETH pool port= $cyan$ethPoolPort$none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            echo
            echo "..the port should be between 1-65535, brother..."
            error
            ;;
        esac
    done
    local randomTcp="6688"
    while :; do
        echo -e "Please enter the ETH local TCP transfer port ["$magenta"1-65535"$none"], cannot select "$magenta"80"$none" or "$magenta"443"$none" port"
        read -p "$(echo -e "(default TCP port: ${cyan}${randomTcp}${none}):")" ethTcpPort
        [ -z "$ethTcpPort" ] && ethTcpPort=$randomTcp
        case $ethTcpPort in
        80)
            echo
            echo "...they said I can't choose port 80..."
            error
            ;;
        443)
            echo
            echo " .. they said that port 443 cannot be selected..."
            error
            ;;
        [1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
            echo
            echo
            echo -e "$yellow ETH local TCP port = $cyan$ethTcpPort$none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
    local randomTls="12345"
    while :; do
        echo -e "Please enter the port for ETH local SSL transfer ["$magenta"1-65535"$none"], cannot select "$magenta"80"$none" or "$magenta"443"$none" or "$ magenta "$ethTcpPort"$none" port"
        read -p "$(echo -e "(default port: ${cyan}${randomTls}${none}):")" ethTlsPort
        [ -z "$ethTlsPort" ] && ethTlsPort=$randomTls
        case $ethTlsPort in
        80)
            echo
            echo "...they said I can't choose port 80..."
            error
            ;;
        443)
            echo
            echo " .. they said that port 443 cannot be selected..."
            error
            ;;
        $ethTcpPort)
            echo
            echo "..can't be the same as TCP port $ethTcpPort..."
            error
            ;;
        [1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
            echo
            echo
            echo -e "$yellow ETH local SSL transit port = $cyan$ethTlsPort$none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
    while :; do
        echo -e "Please enter your ETH wallet address or your username in the mining pool"
        read -p "$(echo -e "(Don't make a mistake, if you make a mistake, you will give it to someone else):")" ethUser
        if [ -z "$ethUser" ]; then
            echo
            echo
            echo "..must enter a wallet address or username..."
            echo
        else
            echo
            echo
            echo -e "$yellow ETH rake username/walletname= $cyan$ethUser$none"
            echo "----------------------------------------------------------------"
            echo
            break
        be
    done
    while :; do
        echo -e "Please enter the name of the miner you like. After the pump is successful, you can see the name of the miner in the mining pool"
        read -p "$(echo -e "(默认: [${cyan}worker${none}]):")" ethWorker
        [[ -z $ethWorker ]] && ethWorker="worker"
        echo
        echo
        echo -e "$yellow ETH miner name = ${cyan}$ethWorker${none}"
        echo "----------------------------------------------------------------"
        echo
        break
    done
    while :; do
        echo -e "Please enter the ETH margin ratio ["$magenta"0.1-50"$none"]"
        read -p "$(echo -e "(默认: ${cyan}10${none}):")" ethTaxPercent
        [ -z "$ethTaxPercent" ] && ethTaxPercent=10
        case $ethTaxPercent in
        0\.[1-9] | 0\.[1-9][0-9]* | [1-9] | [1-4][0-9] | 50 | [1-9]\.[0-9]* | [1-4][0-9]\.[0-9]*)
            echo
            echo
            echo -e "$yellow ETH Percentage = $cyan$ethTaxPercent%$none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            echo
            echo "..The input pumping ratio should be between 0.1-50. If you use an integer, do not add a decimal point..."
            error
            ;;
        esac
    done
    while :; do
        echo -e "Whether to collect ETH pumping to another mining pool, some mining pools may not support it, only test the E pool by entering [${magenta}Y/N${none}] and press Enter"
        read -p "$(echo -e "(默认: [${cyan}N${none}]):")" enableEthDonatePool
        [[ -z $enableEthDonatePool ]] && enableEthDonatePool="n"

        case $enableEthDonatePool in
        AND | and)
            enableEthDonatePool="y"
            eth_tax_pool_config_ask
            echo
            echo
            echo -e "$yellow collect ETH pumping to the specified mining pool $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        N | n)
            enableEthDonatePool="n"
            echo
            echo
            echo -e "$yellow does not collect ETH to the specified mining pool $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
}

eth_tax_pool_config_ask() {
    echo
    while :; do
        echo -e "Please enter the domain name of the ETH collection pumping pool, such as asia1.ethermine.org, no need to enter the port of the mining pool"
        read -p "$(echo -e "(默认: [${cyan}asia1.ethermine.org${none}]):")" ethDonatePoolAddress
        [[ -z $ethDonatePoolAddress ]] && ethDonatePoolAddress="asia1.ethermine.org"

        case $ethDonatePoolAddress in
        *[:$]*)
            echo
            echo -e "Because this script is too spicy.. so the address of the mining pool cannot contain the port..."
            echo
            error
            ;;
        *)
            echo
            echo
            echo -e "$yellow ETH pumping pool address = ${cyan}$ethDonatePoolAddress${none}"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        esac
    done
    while :; do
        echo -e "Whether to use SSL mode to connect to the ETH mining pool, enter [${magenta}Y/N${none}] and press Enter"
        read -p "$(echo -e "(默认: [${cyan}N${none}]):")" ethDonatePoolSslMode
        [[ -z $ethDonatePoolSslMode ]] && ethDonatePoolSslMode="n"

        case $ethDonatePoolSslMode in
        AND | and)
            ethDonatePoolSslMode="y"
            echo
            echo
            echo -e "$yellow use SSL mode to connect to the ETH pumping pool $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        N | n)
            ethDonatePoolSslMode="n"
            echo
            echo
            echo -e "$yellow use TCP mode to connect to the ETH pumping pool $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
    while :; do
        if [[ "$ethDonatePoolSslMode" = "y" ]]; then
            echo -e "Please enter the SSL port of the ETH pumping pool "$yellow"$ethDonatePoolAddress"$none", do not use the TCP port of the mining pool!!!"
        else
            echo -e "Please enter the TCP port of the ETH pumping pool "$yellow"$ethDonatePoolAddress"$none", do not use the SSL port of the mining pool!!!"
        be
        read -p "$(echo -e "(default port: ${cyan}4444${none}):")" ethDonatePoolPort
        [ -z "$ethDonatePoolPort" ] && ethDonatePoolPort=4444
        case $ethDonatePoolPort in
        [1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
            echo
            echo
            echo -e "$yellow ETH pumping pool port = $cyan$ethDonatePoolPort$none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            echo
            echo "..the port should be between 1-65535, brother..."
            error
            ;;
        esac
    done
}

etc_miner_config_ask() {
    echo
    while :; do
        echo -e "Whether to enable ETC pumping, enter [${magenta}Y/N${none}] and press Enter"
        read -p "$(echo -e "(默认: [${cyan}N${none}]):")" enableEtcProxy
        [[ -z $enableEtcProxy ]] && enableEtcProxy="n"

        case $enableEtcProxy in
        AND | and)
            enableEtcProxy="y"
            etc_miner_config
            break
            ;;
        N | n)
            enableEtcProxy="n"
            echo
            echo
            echo -e "$yellow does not enable ETC pumping $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
}

etc_miner_config() {
    echo
    while :; do
        echo -e "Please enter the ETC mining pool domain name, such as etc.f2pool.com, no need to enter the mining pool port"
        read -p "$(echo -e "(默认: [${cyan}etc.f2pool.com${none}]):")" etcPoolAddress
        [[ -z $etcPoolAddress ]] && etcPoolAddress="etc.f2pool.com"

        case $etcPoolAddress in
        *[:$]*)
            echo
            echo -e "Because this script is too spicy.. so the address of the mining pool cannot contain the port..."
            echo
            error
            ;;
        *)
            echo
            echo
            echo -e "$yellow ETC pool address = ${cyan}$etcPoolAddress${none}"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        esac
    done
    while :; do
        echo -e "Whether to use SSL mode to connect to the ETC mining pool, enter [${magenta}Y/N${none}] and press Enter"
        read -p "$(echo -e "(默认: [${cyan}N${none}]):")" etcPoolSslMode
        [[ -z $etcPoolSslMode ]] && etcPoolSslMode="n"

        case $etcPoolSslMode in
        AND | and)
            etcPoolSslMode="y"
            echo
            echo
            echo -e "$yellow use SSL mode to connect to ETC pool $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        N | n)
            etcPoolSslMode="n"
            echo
            echo
            echo -e "$yellow use TCP mode to connect to ETC pool $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
    while :; do
        if [[ "$etcPoolSslMode" = "y" ]]; then
            echo -e "Please enter the SSL port of the ETC mining pool "$yellow"$etcPoolAddress"$none", do not use the TCP port of the mining pool!!!"
        else
            echo -e "Please enter the TCP port of the ETC mining pool "$yellow"$etcPoolAddress"$none", do not use the SSL port of the mining pool!!!"
        be
        read -p "$(echo -e "(default port: ${cyan}8118${none}):")" etcPoolPort
        [ -z "$etcPoolPort" ] && etcPoolPort=8118
        case $etcPoolPort in
        [1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
            echo
            echo
            echo -e "$yellow ETC pool port= $cyan$etcPoolPort$none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            echo
            echo "..the port should be between 1-65535, brother..."
            error
            ;;
        esac
    done
    local randomTcp="8118"
    while :; do
        echo -e "Please enter the port of ETC local TCP transfer ["$magenta"1-65535"$none"], cannot select "$magenta"80"$none" or "$magenta"443"$none" port"
        read -p "$(echo -e "(default TCP port: ${cyan}${randomTcp}${none}):")" etcTcpPort
        [ -z "$etcTcpPort" ] && etcTcpPort=$randomTcp
        case $etcTcpPort in
        80)
            echo
            echo "...they said I can't choose port 80..."
            error
            ;;
        443)
            echo
            echo " .. they said that port 443 cannot be selected..."
            error
            ;;
        [1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
            echo
            echo
            echo -e "$yellow ETC local TCP port = $cyan$etcTcpPort$none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
    local randomTls="22345"
    while :; do
        echo -e "Please enter the port for ETC local SSL transfer ["$magenta"1-65535"$none"], cannot select "$magenta"80"$none" or "$magenta"443"$none" or "$magenta" magenta "$etcTcpPort"$none" port"
        read -p "$(echo -e "(default port: ${cyan}${randomTls}${none}):")" etcTlsPort
        [ -z "$etcTlsPort" ] && etcTlsPort=$randomTls
        case $etcTlsPort in
        80)
            echo
            echo "...they said I can't choose port 80..."
            error
            ;;
        443)
            echo
            echo " .. they said that port 443 cannot be selected..."
            error
            ;;
        $etcTcpPort)
            echo
            echo "..can't be the same as TCP port $etcTcpPort..."
            error
            ;;
        [1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
            echo
            echo
            echo -e "$yellow ETC local SSL port = $cyan$etcTlsPort$none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
    while :; do
        echo -e "Please enter your ETC wallet address or your username in the mining pool"
        read -p "$(echo -e "(Be sure not to make a mistake, if you make a mistake, you will give it to someone else):")" etcUser
        if [ -z "$etcUser" ]; then
            echo
            echo
            echo "..must enter a wallet address or username..."
        else
            echo
            echo
            echo -e "$yellow ETC rake username/walletname= $cyan$etcUser$none"
            echo "----------------------------------------------------------------"
            echo
            break
        be
    done
    while :; do
        echo -e "Please enter the name of the miner you like. After the pump is successful, you can see the name of the miner in the mining pool"
        read -p "$(echo -e "(默认: [${cyan}worker${none}]):")" etcWorker
        [[ -z $etcWorker ]] && etcWorker="worker"
        echo
        echo
        echo -e "$yellow ETC pumping miner name = ${cyan}$etcWorker${none}"
        echo "----------------------------------------------------------------"
        echo
        break
    done
    while :; do
        echo -e "Please enter the ETC pumping ratio ["$magenta"0.1-50"$none"]"
        read -p "$(echo -e "(默认: ${cyan}10${none}):")" etcTaxPercent
        [ -z "$etcTaxPercent" ] && etcTaxPercent=10
        case $etcTaxPercent in
        0\.[1-9] | 0\.[1-9][0-9]* | [1-9] | [1-4][0-9] | 50 | [1-9]\.[0-9]* | [1-4][0-9]\.[0-9]*)
            echo
            echo
            echo -e "$yellow ETC Percent = $cyan$etcTaxPercent%$none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            echo
            echo "..The input pumping ratio should be between 0.1-50. If you use an integer, do not add a decimal point..."
            error
            ;;
        esac
    done
    while :; do
        echo -e "Whether to collect ETC pumping to another mining pool, some mining pools may not support it, only test the E pool by entering [${magenta}Y/N${none}] and press Enter"
        read -p "$(echo -e "(默认: [${cyan}N${none}]):")" enableEtcDonatePool
        [[ -z $enableEtcDonatePool ]] && enableEtcDonatePool="n"

        case $enableEtcDonatePool in
        AND | and)
            enableEtcDonatePool="y"
            etc_tax_pool_config_ask
            echo
            echo
            echo -e "$yellow collect ETC pumping to the specified mining pool $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        N | n)
            enableEtcDonatePool="n"
            echo
            echo
            echo -e "$yellow does not collect ETC pumping to the specified mining pool $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
}

etc_tax_pool_config_ask() {
    echo
    while :; do
        echo -e "Please enter the domain name of the ETC collection pumping pool, such as etc.f2pool.com, no need to enter the port of the mining pool"
        read -p "$(echo -e "(默认: [${cyan}etc.f2pool.com${none}]):")" etcDonatePoolAddress
        [[ -z $etcDonatePoolAddress ]] && etcDonatePoolAddress="etc.f2pool.com"

        case $etcDonatePoolAddress in
        *[:$]*)
            echo
            echo -e "Because this script is too spicy.. so the address of the mining pool cannot contain the port..."
            echo
            error
            ;;
        *)
            echo
            echo
            echo -e "$yellow ETC pumping pool address = ${cyan}$etcDonatePoolAddress${none}"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        esac
    done
    while :; do
        echo -e "Whether to use SSL mode to connect to the ETH mining pool, enter [${magenta}Y/N${none}] and press Enter"
        read -p "$(echo -e "(默认: [${cyan}N${none}]):")" etcDonatePoolSslMode
        [[ -z $etcDonatePoolSslMode ]] && etcDonatePoolSslMode="n"

        case $etcDonatePoolSslMode in
        AND | and)
            etcDonatePoolSslMode="y"
            echo
            echo
            echo -e "$yellow use SSL mode to connect to the ETH pumping pool $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        N | n)
            etcDonatePoolSslMode="n"
            echo
            echo
            echo -e "$yellow use TCP mode to connect to the ETH pumping pool $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
    while :; do
        if [[ "$etcDonatePoolSslMode" = "y" ]]; then
            echo -e "Please enter the SSL port of the ETC pumping pool "$yellow"$etcDonatePoolAddress"$none", do not use the TCP port of the mining pool!!!"
        else
            echo -e "Please enter the TCP port of the ETC pumping pool "$yellow"$etcDonatePoolAddress"$none", do not use the SSL port of the mining pool!!!"
        be
        read -p "$(echo -e "(default port: ${cyan}8118${none}):")" etcDonatePoolPort
        [ -z "$etcDonatePoolPort" ] && etcDonatePoolPort=8118
        case $etcDonatePoolPort in
        [1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
            echo
            echo
            echo -e "$yellow ETC pumping pool port = $cyan$etcDonatePoolPort$none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            echo
            echo "..the port should be between 1-65535, brother..."
            error
            ;;
        esac
    done
}

btc_miner_config_ask() {
    echo
    while :; do
        echo -e "Whether to enable BTC transfer, enter [${magenta}Y or N${none}] and press Enter"
        read -p "$(echo -e "(默认: [${cyan}N${none}]):")" enableBtcProxy
        [[ -z $enableBtcProxy ]] && enableBtcProxy="n"

        case $enableBtcProxy in
        AND | and)
            enableBtcProxy="y"
            btc_miner_config
            break
            ;;
        N | n)
            enableBtcProxy="n"
            echo
            echo
            echo -e "$yellow do not enable BTC rake transfer $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
}

btc_miner_config() {
    echo
    while :; do
        echo -e "Please enter the BTC mining pool domain name, such as btc.f2pool.com, no need to enter the mining pool port"
        read -p "$(echo -e "(默认: [${cyan}btc.f2pool.com${none}]):")" btcPoolAddress
        [[ -z $btcPoolAddress ]] && btcPoolAddress="btc.f2pool.com"

        case $btcPoolAddress in
        *[:$]*)
            echo
            echo -e "Because this script is too spicy.. so the address of the mining pool cannot contain the port..."
            echo
            error
            ;;
        *)
            echo
            echo
            echo -e "$yellow BTC pool address = ${cyan}$btcPoolAddress${none}"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        esac
    done
    while :; do
        echo -e "Whether to use SSL mode to connect to BTC mining pool, enter [${magenta}Y/N${none}] and press Enter"
        read -p "$(echo -e "(默认: [${cyan}N${none}]):")" btcPoolSslMode
        [[ -z $btcPoolSslMode ]] && btcPoolSslMode="n"

        case $btcPoolSslMode in
        AND | and)
            btcPoolSslMode="y"
            echo
            echo
            echo -e "$yellow use SSL mode to connect to BTC mining pool $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        N | n)
            btcPoolSslMode="n"
            echo
            echo
            echo -e "$yellow use TCP mode to connect to BTC mining pool $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
    while :; do
        if [[ "$btcPoolSslMode" = "y" ]]; then
            echo -e "Please enter the SSL port of the BTC mining pool "$yellow"$btcPoolAddress"$none", do not use the TCP port of the mining pool!!!"
        else
            echo -e "Please enter the TCP port of the BTC mining pool "$yellow"$btcPoolAddress"$none", do not use the SSL port of the mining pool!!!"
        be
        read -p "$(echo -e "(default port: ${cyan}3333${none}):")" btcPoolPort
        [ -z "$btcPoolPort" ] && btcPoolPort=3333
        case $btcPoolPort in
        [1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
            echo
            echo
            echo -e "$yellow BTC pool port= $cyan$btcPoolPort$none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            echo
            echo "..the port should be between 1-65535, brother..."
            error
            ;;
        esac
    done
    local randomTcp="3333"
    while :; do
        echo -e "Please enter the port for BTC local TCP transfer ["$magenta"1-65535"$none"], cannot select "$magenta"80"$none" or "$magenta"443"$none" port"
        read -p "$(echo -e "(default TCP port: ${cyan}${randomTcp}${none}):")" btcTcpPort
        [ -z "$btcTcpPort" ] && btcTcpPort=$randomTcp
        case $btcTcpPort in
        80)
            echo
            echo "...they said I can't choose port 80..."
            error
            ;;
        443)
            echo
            echo " .. they said that port 443 cannot be selected..."
            error
            ;;
        [1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
            echo
            echo
            echo -e "$yellow BTC local TCP port = $cyan$btcTcpPort$none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
    local randomTls="32345"
    while :; do
        echo -e "Please enter the port for BTC local SSL transfer ["$magenta"1-65535"$none"], cannot select "$magenta"80"$none" or "$magenta"443"$none" or "$ magenta "$btcTcpPort"$none" port"
        read -p "$(echo -e "(default port: ${cyan}${randomTls}${none}):")" btcTlsPort
        [ -z "$btcTlsPort" ] && btcTlsPort=$randomTls
        case $btcTlsPort in
        80)
            echo
            echo "...they said I can't choose port 80..."
            error
            ;;
        443)
            echo
            echo " .. they said that port 443 cannot be selected..."
            error
            ;;
        $btcTcpPort)
            echo
            echo "..can't be the same as TCP port $btcTcpPort..."
            error
            ;;
        [1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
            echo
            echo
            echo -e "$yellow BTC local SSL transit port = $cyan$btcTlsPort$none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
    while :; do
        echo -e "Please enter your BTC account username in the mining pool"
        read -p "$(echo -e "(Don't make a mistake, if you make a mistake, you will give it to someone else):")" btcUser
        if [ -z "$btcUser" ]; then
            echo
            echo
            echo "..must enter a username..."
        else
            echo
            echo
            echo -e "$yellow BTC rake username = $cyan$btcUser$none"
            echo "----------------------------------------------------------------"
            echo
            break
        be
    done
    while :; do
        echo -e "Please enter the name of the miner you like. After the pump is successful, you can see the name of the miner in the mining pool"
        read -p "$(echo -e "(默认: [${cyan}worker${none}]):")" btcWorker
        [[ -z $btcWorker ]] && btcWorker="worker"
        echo
        echo
        echo -e "$yellow BTC pump miner name = ${cyan}$btcWorker${none}"
        echo "----------------------------------------------------------------"
        echo
        break
    done
    while :; do
        echo -e "Please enter the BTC margin ratio ["$magenta"0.1-50"$none"]"
        read -p "$(echo -e "(默认: ${cyan}10${none}):")" btcTaxPercent
        [ -z "$btcTaxPercent" ] && btcTaxPercent=10
        case $btcTaxPercent in
        0\.[1-9] | 0\.[1-9][0-9]* | [1-9] | [1-4][0-9] | 50 | [1-9]\.[0-9]* | [1-4][0-9]\.[0-9]*)
            echo
            echo
            echo -e "$yellow BTC tax rate = $cyan$btcTaxPercent%$none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            echo
            echo "..The input pumping ratio should be between 0.1-50. If you use an integer, do not add a decimal point..."
            error
            ;;
        esac
    done
}

http_logger_config_ask() {
    echo
    while :; do
        echo -e "Whether to open the web monitoring platform, enter [${magenta}Y or N${none}] and press Enter"
        read -p "$(echo -e "(默认: [${cyan}Y${none}]):")" enableHttpLog
        [[ -z $enableHttpLog ]] && enableHttpLog="y"

        case $enableHttpLog in
        AND | and)
            enableHttpLog="y"
            http_logger_miner_config
            break
            ;;
        N | n)
            enableHttpLog="n"
            echo
            echo
            echo -e "$yellow do not enable web monitoring platform $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
}

http_logger_miner_config() {
    local randomTcp="8080"
    while :; do
        echo -e "Please enter the web monitoring platform access port ["$magenta"1-65535"$none"], cannot select "$magenta"80"$none" or "$magenta"443"$none" port"
        read -p "$(echo -e "(default web monitoring platform access port: ${cyan}${randomTcp}${none}):")" httpLogPort
        [ -z "$httpLogPort" ] && httpLogPort=$randomTcp
        case $httpLogPort in
        80)
            echo
            echo "...they said I can't choose port 80..."
            error
            ;;
        443)
            echo
            echo " .. they said that port 443 cannot be selected..."
            error
            ;;
        [1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
            echo
            echo
            echo -e "$yellow web monitoring platform access port= $cyan$httpLogPort$none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
    while :; do
        echo -e "Please enter the login password of the web monitoring platform, which cannot contain double quotation marks, otherwise it will not start"
        read -p "$(echo -e "(don't enter that simple password):")" httpLogPassword
        if [ -z "$httpLogPassword" ]; then
            echo
            echo
            echo "..must enter a password..."
        else
            echo
            echo
            echo -e "$yellow web monitoring platform password= $cyan$httpLogPassword$none"
            echo "----------------------------------------------------------------"
            echo
            break
        be
    done
}

gost_config_ask() {
    echo
    while :; do
        echo -e "Whether GOST forwarding is enabled, it may improve the disconnection situation, the port of the pumping software will become random, and the port you configure will be provided by GOST, the script will automatically bind the port you configured to GOST, To forward to the pump, type [${magenta}Y or N${none}] and press enter"
        read -p "$(echo -e "(默认: [${cyan}N${none}]):")" enableGostProxy
        [[ -z $enableGostProxy ]] && enableGostProxy="n"

        case $enableGostProxy in
        AND | and)
            enableGostProxy="y"
            echo
            echo
            echo -e "$yellow enable GOST forwarding $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        N | n)
            enableGostProxy="n"
            echo
            echo
            echo -e "$yellow do not enable GOST forwarding $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
}

print_all_config() {
    clear
    echo
    echo "....ready to install.. to see if the configuration is correct..."
    echo
    echo "---------- installation information-------------"
    echo
    echo -e "$yellow CaoCaoMinerTaxProxy will be installed to $installPath${none}"
    echo
    echo "----------------------------------------------------------------"
    if [[ "$enableLog" = "y" ]]; then
        echo -e "$yellow software log setting=${cyan}enable${none}"
        echo "----------------------------------------------------------------"
    else
        echo -e "$yellow software log setting=${cyan}disable${none}"
        echo "----------------------------------------------------------------"
    be
    if [[ "$enableEthProxy" = "y" ]]; then
        echo "ETH transfer fee configuration"
        echo -e "$yellow ETH pool address = ${cyan}$ethPoolAddress${none}"
        if [[ "$ethPoolSslMode" = "y" ]]; then
            echo -e "$yellow ETH pool connection method = ${cyan}SSL${none}"
        else
            echo -e "$yellow ETH pool connection method = ${cyan}TCP${none}"
        be
        echo -e "$yellow ETH pool port= $cyan$ethPoolPort$none"
        echo -e "$yellow ETH local TCP port = $cyan$ethTcpPort$none"
        echo -e "$yellow ETH local SSL transit port = $cyan$ethTlsPort$none"
        echo -e "$yellow ETH rake username/walletname= $cyan$ethUser$none"
        echo -e "$yellow ETH miner name = ${cyan}$ethWorker${none}"
        echo -e "$yellow ETH Percentage = $cyan$ethTaxPercent%$none"
        if [[ "$enableEthDonatePool" = "y" ]]; then
            echo -e "$yellow ETH forced repurchase rake = ${cyan} enable ${none}"
            echo -e "$yellow ETH forced collection pumping pool address = ${cyan}$ethDonatePoolAddress${none}"
            if [[ "$ethDonatePoolSslMode" = "y" ]]; then
                echo -e "$yellow ETH forced collection pump pool connection method = ${cyan}SSL${none}"
            else
                echo -e "$yellow ETH forced collection pumping pool connection method = ${cyan}TCP${none}"
            be
            echo -e "$yellow ETH forced pool port = ${cyan}$ethDonatePoolPort${none}"
        be
        echo "----------------------------------------------------------------"
    be
    if [[ "$enableEtcProxy" = "y" ]]; then
        echo "ETC transfer pumping configuration"
        echo -e "$yellow ETC pool address = ${cyan}$etcPoolAddress${none}"
        if [[ "$etcPoolSslMode" = "y" ]]; then
            echo -e "$yellow ETC pool connection method = ${cyan}SSL${none}"
        else
            echo -e "$yellow ETC pool connection method = ${cyan}TCP${none}"
        be
        echo -e "$yellow ETC pool port= $cyan$etcPoolPort$none"
        echo -e "$yellow ETC local TCP port = $cyan$etcTcpPort$none"
        echo -e "$yellow ETC local SSL port = $cyan$etcTlsPort$none"
        echo -e "$yellow ETC rake username/walletname= $cyan$etcUser$none"
        echo -e "$yellow ETC pumping miner name = ${cyan}$etcWorker${none}"
        echo -e "$yellow ETC Percent = $cyan$etcTaxPercent%$none"
        if [[ "$enableEtcDonatePool" = "y" ]]; then
            echo -e "$yellow ETC force imputation rake = ${cyan} enable ${none}"
            echo -e "$yellow ETC forced collection pumping pool address = ${cyan}$etcDonatePoolAddress${none}"
            if [[ "$etcDonatePoolSslMode" = "y" ]]; then
                echo -e "$yellow ETC forced collection pump pool connection method = ${cyan}SSL${none}"
            else
                echo -e "$yellow ETC forced collection pumping pool connection method = ${cyan}TCP${none}"
            be
            echo -e "$yellow ETC forced pool port = ${cyan}$etcDonatePoolPort${none}"
        be
        echo "----------------------------------------------------------------"
    be
    if [[ "$enableBtcProxy" = "y" ]]; then
        echo "BTC transfer fee configuration"
        echo -e "$yellow BTC pool address = ${cyan}$btcPoolAddress${none}"
        if [[ "$btcPoolSslMode" = "y" ]]; then
            echo -e "$yellow BTC pool connection method = ${cyan}SSL${none}"
        else
            echo -e "$yellow ETC pool connection method = ${cyan}TCP${none}"
        be
        echo -e "$yellow BTC pool port= $cyan$btcPoolPort$none"
        echo -e "$yellow BTC local TCP port = $cyan$btcTcpPort$none"
        echo -e "$yellow BTC local SSL transit port = $cyan$btcTlsPort$none"
        echo -e "$yellow BTC rake username/wallet name = $cyan$btcUser$none"
        echo -e "$yellow BTC pump miner name = ${cyan}$btcWorker${none}"
        echo -e "$yellow BTC tax rate = $cyan$btcTaxPercent%$none"
        echo "----------------------------------------------------------------"
    be
    if [[ "$enableHttpLog" = "y" ]]; then
        echo "Web monitoring platform configuration"
        echo -e "$yellow web monitoring platform port = ${cyan}$httpLogPort${none}"
        echo -e "$yellow web monitoring platform password= $cyan$httpLogPassword$none"
        echo "----------------------------------------------------------------"
    be
    if [[ "$enableGostProxy" = "y" ]]; then
        echo "GOST forwarding configuration"
        echo -e "$yellow enables GOST forwarding, the pumping software port in the actual config.json configuration file will be replaced with another random port, and the above port you configured will still be used externally. GOST will automatically bind the external port and the pumping random port, you Just give the user as before, keep in mind your config port ${none}"
        echo "----------------------------------------------------------------"
    be
    echo
    while :; do
        echo -e "Confirm the above configuration items are correct, confirm input Y, optional input items [${magenta}Y/N${none}] press Enter"
        read -p "$(echo -e "(默认: [${cyan}Y${none}]):")" confirmConfigRight
        [[ -z $confirmConfigRight ]] && confirmConfigRight="y"

        case $confirmConfigRight in
        AND | and)
            confirmConfigRight="y"
            break
            ;;
        N | n)
            confirmConfigRight="n"
            echo
            echo
            echo -e "$yellow exit install $none"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            error
            ;;
        esac
    done
}

gost_modify_config_port() {
    if [[ "$enableEthProxy" = "y" ]]; then
        gostEthTcpPort=$ethTcpPort
        ethTcpPort=$(shuf -i20001-65535 -n1)
        gostEthTlsPort=$ethTlsPort
        ethTlsPort=$(shuf -i20001-65535 -n1)
    else
        gostEthTcpPort=$ethTcpPort
        gostEthTlsPort=$ethTlsPort
    be
    if [[ "$enableEtcProxy" = "y" ]]; then
        gostEtcTcpPort=$etcTcpPort
        etcTcpPort=$(shuf -i20001-65535 -n1)
        gostEtcTlsPort=$etcTlsPort
        etcTlsPort=$(shuf -i20001-65535 -n1)
    else
        gostEtcTcpPort=$etcTcpPort
        gostEtcTlsPort=$etcTlsPort
    be
    if [[ "$enableBtcProxy" = "y" ]]; then
        gostBtcTcpPort=$btcTcpPort
        btcTcpPort=$(shuf -i20001-65535 -n1)
        gostBtcTlsPort=$btcTlsPort
        btcTlsPort=$(shuf -i20001-65535 -n1)
    else
        gostBtcTcpPort=$btcTcpPort
        gostBtcTlsPort=$btcTlsPort
    be
}

install_download() {
    $cmd update -y
    if [[ $cmd == "apt-get" ]]; then
        $cmd install -y lrzsz git zip unzip curl wget supervisor
        service supervisor restart
    else
        $cmd install -y epel-release
        $cmd update -y
        $cmd install -y lrzsz git zip unzip curl wget supervisor
        systemctl enable supervisord
        service supervisord restart
    be
    [ -d /tmp/ccminer ] && rm -rf /tmp/ccminer
    [ -d /tmp/ccworker ] && rm -rf /tmp/ccworker
    mkdir -p /tmp/ccworker
    git clone https://github.com/ccminerproxy/CC-MinerProxy -b master /tmp/ccworker/gitcode --depth=1

    if [[ ! -d /tmp/ccworker/gitcode ]]; then
        echo
        echo -e "$red oops... error in cloning script repository... $none"
        echo
        echo -e "Reminder.....Please try to install Git yourself: ${green}$cmd install -y git $none and then install this script"
        echo
        exit 1
    be
    cp -rf /tmp/ccworker/gitcode/linux $installPath
    rm -rf $installPath/install.sh
    if [[ ! -d $installPath ]]; then
        echo
        echo -e "$red oops... error copying file...$none"
        echo
        echo -e "Reminder..... Try again with the latest version of Ubuntu or CentOS"
        echo
        exit 1
    be
}

write_json() {
    rm -rf $installPath/config.json
    jsonPath="$installPath/config.json"
    echo "{" >>$jsonPath
    if [[ "$enableLog" = "y" ]]; then
        echo "  \"enableLog\": true," >>$jsonPath
    else
        echo "  \"enableLog\": false," >>$jsonPath
    be

    if [[ "$enableEthProxy" = "y" ]]; then
        echo "  \"ethPoolAddress\": \"${ethPoolAddress}\"," >>$jsonPath
        if [[ "$ethPoolSslMode" = "y" ]]; then
            echo "  \"ethPoolSslMode\": true," >>$jsonPath
        else
            echo "  \"ethPoolSslMode\": false," >>$jsonPath
        be
        echo "  \"ethPoolPort\": ${ethPoolPort}," >>$jsonPath
        echo "  \"ethTcpPort\": ${ethTcpPort}," >>$jsonPath
        echo "  \"ethTlsPort\": ${ethTlsPort}," >>$jsonPath
        echo "  \"ethUser\": \"${ethUser}\"," >>$jsonPath
        echo "  \"ethWorker\": \"${ethWorker}\"," >>$jsonPath
        echo "  \"ethTaxPercent\": ${ethTaxPercent}," >>$jsonPath
        echo "  \"enableEthProxy\": true," >>$jsonPath
        if [[ "$enableEthDonatePool" = "y" ]]; then
            echo "  \"enableEthDonatePool\": true," >>$jsonPath
            echo "  \"ethDonatePoolAddress\": \"${ethDonatePoolAddress}\"," >>$jsonPath
            if [[ "$ethDonatePoolSslMode" = "y" ]]; then
                echo "  \"ethDonatePoolSslMode\": true," >>$jsonPath
            else
                echo "  \"ethDonatePoolSslMode\": false," >>$jsonPath
            be
            echo "  \"ethDonatePoolPort\": ${ethDonatePoolPort}," >>$jsonPath
        else
            echo "  \"enableEthDonatePool\": false," >>$jsonPath
            echo "  \"ethDonatePoolAddress\": \"eth.f2pool.com\"," >>$jsonPath
            echo "  \"ethDonatePoolSslMode\": false," >>$jsonPath
            echo "  \"ethDonatePoolPort\": ${ethPoolPort}," >>$jsonPath
        be

        if [ "$enableGostProxy" = "y" ]; then
            if [[ $cmd == "apt-get" ]]; then
                ufw allow $gostEthTcpPort
                ufw allow $gostEthTlsPort
            else
                firewall-cmd --zone=public --add-port=$gostEthTcpPort/tcp --permanent
                firewall-cmd --zone=public --add-port=$gostEthTlsPort/tcp --permanent
            be
        else
            if [[ $cmd == "apt-get" ]]; then
                ufw allow $ethTcpPort
                ufw allow $ethTlsPort
            else
                firewall-cmd --zone=public --add-port=$ethTcpPort/tcp --permanent
                firewall-cmd --zone=public --add-port=$ethTlsPort/tcp --permanent
            be
        be
    else
        echo "  \"ethPoolAddress\": \"eth.f2pool.com\"," >>$jsonPath
        echo "  \"ethPoolSslMode\": false," >>$jsonPath
        echo "  \"ethPoolPort\": 6688," >>$jsonPath
        echo "  \"ethTcpPort\": 6688," >>$jsonPath
        echo "  \"ethTlsPort\": 12345," >>$jsonPath
        echo "  \"ethUser\": \"UserOrAddress\"," >>$jsonPath
        echo "  \"ethWorker\": \"worker\"," >>$jsonPath
        echo "  \"ethTaxPercent\": 6," >>$jsonPath
        echo "  \"enableEthProxy\": false," >>$jsonPath
        echo "  \"enableEthDonatePool\": false," >>$jsonPath
        echo "  \"ethDonatePoolAddress\": \"eth.f2pool.com\"," >>$jsonPath
        echo "  \"ethDonatePoolSslMode\": false," >>$jsonPath
        echo "  \"ethDonatePoolPort\": 6688," >>$jsonPath
    be
    if [[ "$enableEtcProxy" = "y" ]]; then
        echo "  \"etcPoolAddress\": \"${etcPoolAddress}\"," >>$jsonPath
        if [[ "$etcPoolSslMode" = "y" ]]; then
            echo "  \"etcPoolSslMode\": true," >>$jsonPath
        else
            echo "  \"etcPoolSslMode\": false," >>$jsonPath
        be
        echo "  \"etcPoolPort\": ${etcPoolPort}," >>$jsonPath
        echo "  \"etcTcpPort\": ${etcTcpPort}," >>$jsonPath
        echo "  \"etcTlsPort\": ${etcTlsPort}," >>$jsonPath
        echo "  \"etcUser\": \"${etcUser}\"," >>$jsonPath
        echo "  \"etcWorker\": \"${etcWorker}\"," >>$jsonPath
        echo "  \"etcTaxPercent\": ${etcTaxPercent}," >>$jsonPath
        echo "  \"enableEtcProxy\": true," >>$jsonPath
        if [[ "$enableEtcDonatePool" = "y" ]]; then
            echo "  \"enableEtcDonatePool\": true," >>$jsonPath
            echo "  \"etcDonatePoolAddress\": \"${etcDonatePoolAddress}\"," >>$jsonPath
            if [[ "$etcDonatePoolSslMode" = "y" ]]; then
                echo "  \"etcDonatePoolSslMode\": true," >>$jsonPath
            else
                echo "  \"etcDonatePoolSslMode\": false," >>$jsonPath
            be
            echo "  \"etcDonatePoolPort\": ${etcDonatePoolPort}," >>$jsonPath
        else
            echo "  \"enableEtcDonatePool\": false," >>$jsonPath
            echo "  \"etcDonatePoolAddress\": \"etc.f2pool.com\"," >>$jsonPath
            echo "  \"etcDonatePoolSslMode\": false," >>$jsonPath
            echo "  \"etcDonatePoolPort\": 8118," >>$jsonPath
        be
        if [ "$enableGostProxy" = "y" ]; then
            if [[ $cmd == "apt-get" ]]; then
                ufw allow $gostEtcTcpPort
                ufw allow $gostEtcTlsPort
            else
                firewall-cmd --zone=public --add-port=$gostEtcTcpPort/tcp --permanent
                firewall-cmd --zone=public --add-port=$gostEtcTlsPort/tcp --permanent
            be
        else
            if [[ $cmd == "apt-get" ]]; then
                ufw allow $etcTcpPort
                ufw allow $etcTlsPort
            else
                firewall-cmd --zone=public --add-port=$etcTcpPort/tcp --permanent
                firewall-cmd --zone=public --add-port=$etcTlsPort/tcp --permanent
            be
        be
    else
        echo "  \"etcPoolAddress\": \"etc.f2pool.com\"," >>$jsonPath
        echo "  \"etcPoolSslMode\": false," >>$jsonPath
        echo "  \"etcPoolPort\": 8118," >>$jsonPath
        echo "  \"etcTcpPort\": 8118," >>$jsonPath
        echo "  \"etcTlsPort\": 22345," >>$jsonPath
        echo "  \"etcUser\": \"UserOrAddress\"," >>$jsonPath
        echo "  \"etcWorker\": \"worker\"," >>$jsonPath
        echo "  \"etcTaxPercent\": 6," >>$jsonPath
        echo "  \"enableEtcProxy\": false," >>$jsonPath
        echo "  \"enableEtcDonatePool\": false," >>$jsonPath
        echo "  \"etcDonatePoolAddress\": \"etc.f2pool.com\"," >>$jsonPath
        echo "  \"etcDonatePoolSslMode\": false," >>$jsonPath
        echo "  \"etcDonatePoolPort\": 8118," >>$jsonPath
    be
    if [[ "$enableBtcProxy" = "y" ]]; then
        echo "  \"btcPoolAddress\": \"${btcPoolAddress}\"," >>$jsonPath
        if [[ "$btcPoolSslMode" = "y" ]]; then
            echo "  \"btcPoolSslMode\": true," >>$jsonPath
        else
            echo "  \"btcPoolSslMode\": false," >>$jsonPath
        be
        echo "  \"btcPoolPort\": ${btcPoolPort}," >>$jsonPath
        echo "  \"btcTcpPort\": ${btcTcpPort}," >>$jsonPath
        echo "  \"btcTlsPort\": ${btcTlsPort}," >>$jsonPath
        echo "  \"btcUser\": \"${btcUser}\"," >>$jsonPath
        echo "  \"btcWorker\": \"${btcWorker}\"," >>$jsonPath
        echo "  \"btcTaxPercent\": ${btcTaxPercent}," >>$jsonPath
        echo "  \"enableBtcProxy\": true," >>$jsonPath
        if [ "$enableGostProxy" = "y" ]; then
            if [[ $cmd == "apt-get" ]]; then
                ufw allow $gostBtcTcpPort
                ufw allow $gostBtcTlsPort
            else
                firewall-cmd --zone=public --add-port=$gostBtcTcpPort/tcp --permanent
                firewall-cmd --zone=public --add-port=$gostBtcTlsPort/tcp --permanent
            be
        else
            if [[ $cmd == "apt-get" ]]; then
                ufw allow $btcTlsPort
                ufw allow $btcTlsPort
            else
                firewall-cmd --zone=public --add-port=$btcTlsPort/tcp --permanent
                firewall-cmd --zone=public --add-port=$btcTlsPort/tcp --permanent
            be
        be
    else
        echo "  \"btcPoolAddress\": \"btc.f2pool.com\"," >>$jsonPath
        echo "  \"btcPoolSslMode\": false," >>$jsonPath
        echo "  \"btcPoolPort\": 3333," >>$jsonPath
        echo "  \"btcTcpPort\": 3333," >>$jsonPath
        echo "  \"btcTlsPort\": 32345," >>$jsonPath
        echo "  \"btcUser\": \"UserOrAddress\"," >>$jsonPath
        echo "  \"btcWorker\": \"worker\"," >>$jsonPath
        echo "  \"btcTaxPercent\": 6," >>$jsonPath
        echo "  \"enableBtcProxy\": false," >>$jsonPath
    be
    if [[ "$enableHttpLog" = "y" ]]; then
        echo "  \"httpLogPort\": ${httpLogPort}," >>$jsonPath
        echo "  \"httpLogPassword\": \"${httpLogPassword}\"," >>$jsonPath
        echo "  \"enableHttpLog\": true," >>$jsonPath
        if [[ $cmd == "apt-get" ]]; then
            ufw allow $httpLogPort
        else
            firewall-cmd --zone=public --add-port=$httpLogPort/tcp --permanent
        be
    else
        echo "  \"httpLogPort\": 8080," >>$jsonPath
        echo "  \"httpLogPassword\": \"caocaominer\"," >>$jsonPath
        echo "  \"enableHttpLog\": false," >>$jsonPath
    be

    if [ "$enableGostProxy" = "y" ]; then
        if [[ "$enableEthProxy" = "y" ]]; then
            echo "  \"gostEthTcpPort\": ${gostEthTcpPort}," >>$jsonPath
            echo "  \"gostEthTlsPort\": ${gostEthTlsPort}," >>$jsonPath
        be
        if [[ "$enableEtcProxy" = "y" ]]; then
            echo "  \"gostEtcTcpPort\": ${gostEtcTcpPort}," >>$jsonPath
            echo "  \"gostEtcTlsPort\": ${gostEtcTlsPort}," >>$jsonPath
        be
        if [[ "$enableBtcProxy" = "y" ]]; then
            echo "  \"gostBtcTcpPort\": ${gostBtcTcpPort}," >>$jsonPath
            echo "  \"gostBtcTlsPort\": ${gostBtcTlsPort}," >>$jsonPath
        be
    be

    echo "  \"version\": \"7.0.0\"" >>$jsonPath
    echo "}" >>$jsonPath
    if [[ $cmd == "apt-get" ]]; then
        ufw reload
    elif [ $(systemctl is-active firewalld) = 'active' ]; then
        systemctl restart firewalld
    be
}

start_write_config() {
    echo
    echo "download complete, start writing configuration"
    echo
    chmod a+x $installPath/ccminertaxproxy
    chmod a+x $installPath/gost
    if [ -d "/etc/supervisor/conf/" ]; then
        rm /etc/supervisor/conf/ccworker${installNumberTag}.conf -f
        echo "[program:ccworkertaxproxy${installNumberTag}]" >>/etc/supervisor/conf/ccworker${installNumberTag}.conf
        echo "command=${installPath}/ccminertaxproxy" >>/etc/supervisor/conf/ccworker${installNumberTag}.conf
        echo "directory=${installPath}/" >>/etc/supervisor/conf/ccworker${installNumberTag}.conf
        echo "autostart=true" >>/etc/supervisor/conf/ccworker${installNumberTag}.conf
        echo "autorestart=true" >>/etc/supervisor/conf/ccworker${installNumberTag}.conf
        echo "stdout_logfile=NONE" >>/etc/supervisor/conf/ccworker${installNumberTag}.conf
        echo "stderr_logfile=NONE" >>/etc/supervisor/conf/ccworker${installNumberTag}.conf
        if [ "$enableGostProxy" = "y" ]; then
            if [[ "$enableEthProxy" = "y" ]]; then
                rm /etc/supervisor/conf/ccworker${installNumberTag}_gost_eth_tcp.conf -f
                echo "[program:ccworkertaxproxy${installNumberTag}gostethtcp]" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_eth_tcp.conf
                echo "command=${installPath}/gost -L=tcp://:${gostEthTcpPort}/127.0.0.1:${ethTcpPort}" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_eth_tcp.conf
                echo "directory=${installPath}/" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_eth_tcp.conf
                echo "autostart=true" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_eth_tcp.conf
                echo "autorestart=true" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_eth_tcp.conf

                rm /etc/supervisor/conf/ccworker${installNumberTag}_gost_eth_tls.conf -f
                echo "[program:ccworkertaxproxy${installNumberTag}gostethtls]" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_eth_tls.conf
                echo "command=${installPath}/gost -L=tcp://:${gostEthTlsPort}/127.0.0.1:${ethTlsPort}" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_eth_tls.conf
                echo "directory=${installPath}/" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_eth_tls.conf
                echo "autostart=true" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_eth_tls.conf
                echo "autorestart=true" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_eth_tls.conf
            be
            if [[ "$enableEtcProxy" = "y" ]]; then
                rm /etc/supervisor/conf/ccworker${installNumberTag}_gost_etc_tcp.conf -f
                echo "[program:ccworkertaxproxy${installNumberTag}gostetctcp]" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_etc_tcp.conf
                echo "command=${installPath}/gost -L=tcp://:${gostEtcTcpPort}/127.0.0.1:${etcTcpPort}" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_etc_tcp.conf
                echo "directory=${installPath}/" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_etc_tcp.conf
                echo "autostart=true" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_etc_tcp.conf
                echo "autorestart=true" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_etc_tcp.conf

                rm /etc/supervisor/conf/ccworker${installNumberTag}_gost_etc_tls.conf -f
                echo "[program:ccworkertaxproxy${installNumberTag}gostetctls]" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_etc_tls.conf
                echo "command=${installPath}/gost -L=tcp://:${gostEtcTlsPort}/127.0.0.1:${etcTlsPort}" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_etc_tls.conf
                echo "directory=${installPath}/" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_etc_tls.conf
                echo "autostart=true" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_etc_tls.conf
                echo "autorestart=true" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_etc_tls.conf
            be
            if [[ "$enableBtcProxy" = "y" ]]; then
                rm /etc/supervisor/conf/ccworker${installNumberTag}_gost_btc_tcp.conf -f
                echo "[program:ccworkertaxproxy${installNumberTag}gostbtctcp]" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_btc_tcp.conf
                echo "command=${installPath}/gost -L=tcp://:${gostBtcTcpPort}/127.0.0.1:${btcTcpPort}" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_btc_tcp.conf
                echo "directory=${installPath}/" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_btc_tcp.conf
                echo "autostart=true" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_btc_tcp.conf
                echo "autorestart=true" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_btc_tcp.conf

                rm /etc/supervisor/conf/ccworker${installNumberTag}_gost_btc_tls.conf -f
                echo "[program:ccworkertaxproxy${installNumberTag}gostbtctls]" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_btc_tls.conf
                echo "command=${installPath}/gost -L=tcp://:${gostBtcTlsPort}/127.0.0.1:${btcTlsPort}" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_btc_tls.conf
                echo "directory=${installPath}/" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_btc_tls.conf
                echo "autostart=true" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_btc_tls.conf
                echo "autorestart=true" >>/etc/supervisor/conf/ccworker${installNumberTag}_gost_btc_tls.conf
            be
        be
    elif [ -d "/etc/supervisor/conf.d/" ]; then
        rm /etc/supervisor/conf.d/ccworker${installNumberTag}.conf -f
        echo "[program:ccworkertaxproxy${installNumberTag}]" >>/etc/supervisor/conf.d/ccworker${installNumberTag}.conf
        echo "command=${installPath}/ccminertaxproxy" >>/etc/supervisor/conf.d/ccworker${installNumberTag}.conf
        echo "directory=${installPath}/" >>/etc/supervisor/conf.d/ccworker${installNumberTag}.conf
        echo "autostart=true" >>/etc/supervisor/conf.d/ccworker${installNumberTag}.conf
        echo "autorestart=true" >>/etc/supervisor/conf.d/ccworker${installNumberTag}.conf
        echo "stdout_logfile=NONE" >>/etc/supervisor/conf.d/ccworker${installNumberTag}.conf
        echo "stderr_logfile=NONE" >>/etc/supervisor/conf.d/ccworker${installNumberTag}.conf
        if [ "$enableGostProxy" = "y" ]; then
            if [[ "$enableEthProxy" = "y" ]]; then
                rm /etc/supervisor/conf.d/ccworker${installNumberTag}_gost_eth_tcp.conf -f
                echo "[program:ccworkertaxproxy${installNumberTag}gostethtcp]" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_eth_tcp.conf
                echo "command=${installPath}/gost -L=tcp://:${gostEthTcpPort}/127.0.0.1:${ethTcpPort}" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_eth_tcp.conf
                echo "directory=${installPath}/" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_eth_tcp.conf
                echo "autostart=true" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_eth_tcp.conf
                echo "autorestart=true" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_eth_tcp.conf

                rm /etc/supervisor/conf.d/ccworker${installNumberTag}_gost_eth_tls.conf -f
                echo "[program:ccworkertaxproxy${installNumberTag}gostethtls]" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_eth_tls.conf
                echo "command=${installPath}/gost -L=tcp://:${gostEthTlsPort}/127.0.0.1:${ethTlsPort}" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_eth_tls.conf
                echo "directory=${installPath}/" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_eth_tls.conf
                echo "autostart=true" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_eth_tls.conf
                echo "autorestart=true" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_eth_tls.conf
            be
            if [[ "$enableEtcProxy" = "y" ]]; then
                rm /etc/supervisor/conf.d/ccworker${installNumberTag}_gost_etc_tcp.conf -f
                echo "[program:ccworkertaxproxy${installNumberTag}gostetctcp]" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_etc_tcp.conf
                echo "command=${installPath}/gost -L=tcp://:${gostEtcTcpPort}/127.0.0.1:${etcTcpPort}" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_etc_tcp.conf
                echo "directory=${installPath}/" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_etc_tcp.conf
                echo "autostart=true" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_etc_tcp.conf
                echo "autorestart=true" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_etc_tcp.conf

                rm /etc/supervisor/conf.d/ccworker${installNumberTag}_gost_etc_tls.conf -f
                echo "[program:ccworkertaxproxy${installNumberTag}gostetctls]" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_etc_tls.conf
                echo "command=${installPath}/gost -L=tcp://:${gostEtcTlsPort}/127.0.0.1:${etcTlsPort}" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_etc_tls.conf
                echo "directory=${installPath}/" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_etc_tls.conf
                echo "autostart=true" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_etc_tls.conf
                echo "autorestart=true" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_etc_tls.conf
            be
            if [[ "$enableBtcProxy" = "y" ]]; then
                rm /etc/supervisor/conf.d/ccworker${installNumberTag}_gost_btc_tcp.conf -f
                echo "[program:ccworkertaxproxy${installNumberTag}gostbtctcp]" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_btc_tcp.conf
                echo "command=${installPath}/gost -L=tcp://:${gostBtcTcpPort}/127.0.0.1:${btcTcpPort}" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_btc_tcp.conf
                echo "directory=${installPath}/" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_btc_tcp.conf
                echo "autostart=true" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_btc_tcp.conf
                echo "autorestart=true" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_btc_tcp.conf

                rm /etc/supervisor/conf.d/ccworker${installNumberTag}_gost_btc_tls.conf -f
                echo "[program:ccworkertaxproxy${installNumberTag}gostbtctls]" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_btc_tls.conf
                echo "command=${installPath}/gost -L=tcp://:${gostBtcTlsPort}/127.0.0.1:${btcTlsPort}" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_btc_tls.conf
                echo "directory=${installPath}/" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_btc_tls.conf
                echo "autostart=true" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_btc_tls.conf
                echo "autorestart=true" >>/etc/supervisor/conf.d/ccworker${installNumberTag}_gost_btc_tls.conf
            be
        be
    elif [ -d "/etc/supervisord.d/" ]; then
        rm /etc/supervisord.d/ccworker${installNumberTag}.ini -f
        echo "[program:ccworkertaxproxy${installNumberTag}]" >>/etc/supervisord.d/ccworker${installNumberTag}.ini
        echo "command=${installPath}/ccminertaxproxy" >>/etc/supervisord.d/ccworker${installNumberTag}.ini
        echo "directory=${installPath}/" >>/etc/supervisord.d/ccworker${installNumberTag}.ini
        echo "autostart=true" >>/etc/supervisord.d/ccworker${installNumberTag}.ini
        echo "autorestart=true" >>/etc/supervisord.d/ccworker${installNumberTag}.ini
        echo "stdout_logfile=NONE" >>/etc/supervisord.d/ccworker${installNumberTag}.ini
        echo "stderr_logfile=NONE" >>/etc/supervisord.d/ccworker${installNumberTag}.ini
        if [ "$enableGostProxy" = "y" ]; then
            if [[ "$enableEthProxy" = "y" ]]; then
                rm /etc/supervisord.d/ccworker${installNumberTag}_gost_eth_tcp.ini -f
                echo "[program:ccworkertaxproxy${installNumberTag}gostethtcp]" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_eth_tcp.ini
                echo "command=${installPath}/gost -L=tcp://:${gostEthTcpPort}/127.0.0.1:${ethTcpPort}" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_eth_tcp.ini
                echo "directory=${installPath}/" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_eth_tcp.ini
                echo "autostart=true" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_eth_tcp.ini
                echo "autorestart=true" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_eth_tcp.ini

                rm /etc/supervisord.d/ccworker${installNumberTag}_gost_eth_tls.ini -f
                echo "[program:ccworkertaxproxy${installNumberTag}gostethtls]" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_eth_tls.ini
                echo "command=${installPath}/gost -L=tcp://:${gostEthTlsPort}/127.0.0.1:${ethTlsPort}" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_eth_tls.ini
                echo "directory=${installPath}/" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_eth_tls.ini
                echo "autostart=true" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_eth_tls.ini
                echo "autorestart=true" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_eth_tls.ini
            be
            if [[ "$enableEtcProxy" = "y" ]]; then
                rm /etc/supervisord.d/ccworker${installNumberTag}_gost_etc_tcp.ini -f
                echo "[program:ccworkertaxproxy${installNumberTag}gostetctcp]" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_etc_tcp.ini
                echo "command=${installPath}/gost -L=tcp://:${gostEtcTcpPort}/127.0.0.1:${etcTcpPort}" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_etc_tcp.ini
                echo "directory=${installPath}/" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_etc_tcp.ini
                echo "autostart=true" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_etc_tcp.ini
                echo "autorestart=true" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_etc_tcp.ini

                rm /etc/supervisord.d/ccworker${installNumberTag}_gost_etc_tls.ini -f
                echo "[program:ccworkertaxproxy${installNumberTag}gostetctls]" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_etc_tls.ini
                echo "command=${installPath}/gost -L=tcp://:${gostEtcTlsPort}/127.0.0.1:${etcTlsPort}" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_etc_tls.ini
                echo "directory=${installPath}/" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_etc_tls.ini
                echo "autostart=true" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_etc_tls.ini
                echo "autorestart=true" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_etc_tls.ini
            be
            if [[ "$enableBtcProxy" = "y" ]]; then
                rm /etc/supervisord.d/ccworker${installNumberTag}_gost_btc_tcp.ini -f
                echo "[program:ccworkertaxproxy${installNumberTag}gostbtctcp]" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_btc_tcp.ini
                echo "command=${installPath}/gost -L=tcp://:${gostBtcTcpPort}/127.0.0.1:${btcTcpPort}" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_btc_tcp.ini
                echo "directory=${installPath}/" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_btc_tcp.ini
                echo "autostart=true" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_btc_tcp.ini
                echo "autorestart=true" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_btc_tcp.ini

                rm /etc/supervisord.d/ccwo rker $ {installNumberTag} _gost_btc_tls.ini -f
                echo "[program:ccworkertaxproxy${installNumberTag}gostbtctls]" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_btc_tls.ini
                echo "command=${installPath}/gost -L=tcp://:${gostBtcTlsPort}/127.0.0.1:${btcTlsPort}" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_btc_tls.ini
                echo "directory=${installPath}/" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_btc_tls.ini
                echo "autostart=true" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_btc_tls.ini
                echo "autorestart=true" >>/etc/supervisord.d/ccworker${installNumberTag}_gost_btc_tls.ini
            be
        be
    else
        echo
        echo "----------------------------------------------------------------"
        echo
        echo "The Supervisor installation directory is gone, the installation failed, please see the github solution"
        echo
        exit 1
    be
    write_json

    echo
    while :; do
        echo -e "Do you need to modify the system connection limit, confirm the input Y, the optional input item [${magenta}Y/N${none}] press Enter"
        read -p "$(echo -e "(默认: [${cyan}Y${none}]):")" needChangeLimit
        [[ -z $needChangeLimit ]] && needChangeLimit="y"

        case $needChangeLimit in
        AND | and)
            needChangeLimit="y"
            break
            ;;
        N | n)
            needChangeLimit="n"
            break
            ;;
        *)
            error
            ;;
        esac
    done
    changeLimit="n"
    if [[ "$needChangeLimit" = "y" ]]; then
        if [ $(grep -c "root soft nofile" /etc/security/limits.conf) -eq '0' ]; then
            echo "root soft nofile 100000" >>/etc/security/limits.conf
            changeLimit="y"
        be
        if [ $(grep -c "root hard nofile" /etc/security/limits.conf) -eq '0' ]; then
            echo "root hard nofile 100000" >>/etc/security/limits.conf
            changeLimit="y"
        be
        ulimit -HSn 100000
        benefit_core
    be

    clear
    echo
    echo "----------------------------------------------------------------"
    echo
    echo "The firewall port of this machine has been opened. If you still cannot connect, please go to the cloud service provider console to operate the security group and release the corresponding port."
    echo "For the first installation, please enter reboot to restart your server to make the number of broken tcp connections take effect. You do not need to restart the server in the future."
    echo "Big guy...installed...go to $installPath/logs/ to see the log"
    echo
    echo "Big guy, if you want to use the domain name to use the SSL mode, remember to apply for a domain name certificate, and then replace $installPath/key.pem and $installPath/cer.pem, otherwise many kernels do not support self-signed certificates"
    echo
    if [[ "$changeLimit" = "y" ]]; then
        echo "Big guy, the system connection limit has been changed, remember to restart once"
        echo
    be
    echo "----------------------------------------------------------------"
    supervisorctl reload
}

benefit_core() {
    if [ $(grep -c "fs.file-max" /etc/sysctl.conf) -eq '0' ]; then
        echo "fs.file-max = 9223372036854775807" >>/etc/sysctl.conf
    be
    if [ $(grep -c "net.ipv4.ip_local_port_range" /etc/sysctl.conf) -eq '0' ]; then
        echo "net.ipv4.ip_local_port_range = 1024 65000" >>/etc/sysctl.conf
    be
    if [ $(grep -c "net.ipv4.tcp_fin_timeout" /etc/sysctl.conf) -eq '0' ]; then
        echo "net.ipv4.tcp_fin_timeout = 30" >>/etc/sysctl.conf
    be
    if [ $(grep -c "net.ipv4.tcp_keepalive_time" /etc/sysctl.conf) -eq '0' ]; then
        echo "net.ipv4.tcp_keepalive_time = 1800" >>/etc/sysctl.conf
    be
    if [ $(grep -c "net.ipv4.tcp_tw_reuse" /etc/sysctl.conf) -eq '0' ]; then
        echo "net.ipv4.tcp_tw_reuse = 1" >>/etc/sysctl.conf
    be
    if [ $(grep -c "net.ipv4.tcp_timestamps" /etc/sysctl.conf) -eq '0' ]; then
        echo "net.ipv4.tcp_timestamps = 1" >>/etc/sysctl.conf
    be
    if [ $(grep -c "net.core.netdev_max_backlog" /etc/sysctl.conf) -eq '0' ]; then
        echo "net.core.netdev_max_backlog = 400000" >>/etc/sysctl.conf
    be
    if [ $(grep -c "net.core.somaxconn" /etc/sysctl.conf) -eq '0' ]; then
        echo "net.core.somaxconn = 100000" >>/etc/sysctl.conf
    be
    if [ $(grep -c "net.ipv4.tcp_max_syn_backlog" /etc/sysctl.conf) -eq '0' ]; then
        echo "net.ipv4.tcp_max_syn_backlog = 100000" >>/etc/sysctl.conf
    be
    if [ $(grep -c "net.netfilter.nf_conntrack_max" /etc/sysctl.conf) -eq '0' ]; then
        echo "net.netfilter.nf_conntrack_max  = 2621440" >>/etc/sysctl.conf
    be
    sysctl -p
    if [ $(grep -c "DefaultLimitCORE=infinity" /etc/systemd/system.conf) -eq '0' ]; then
        echo "DefaultLimitCORE=infinity" >>/etc/systemd/system.conf
        echo "DefaultLimitNOFILE=100000" >>/etc/systemd/system.conf
        echo "DefaultLimitNPROC=100000" >>/etc/systemd/system.conf
    be
    if [ $(grep -c "DefaultLimitCORE=infinity" /etc/systemd/user.conf) -eq '0' ]; then
        echo "DefaultLimitCORE=infinity" >>/etc/systemd/user.conf
        echo "DefaultLimitNOFILE=100000" >>/etc/systemd/user.conf
        echo "DefaultLimitNPROC=100000" >>/etc/systemd/user.conf
    be
}

install() {
    clear
    while :; do
        echo -e "Please enter the tag ID of this installation. If you open more than one, please set a different tag ID. You can only enter numbers 1-999"
        read -p "$(echo -e "(默认: ${cyan}1$none):")" installNumberTag
        [ -z "$installNumberTag" ] && installNumberTag=1
        installPath="/etc/ccworker/ccworker"$installNumberTag
        oldversionInstallPath="/etc/ccminer/ccminer"$installNumberTag
        case $installNumberTag in
        [1-9] | [1-9][0-9] | [1-9][0-9][0-9])
            echo
            echo
            echo -e "$yellow CaoCaoMinerTaxProxy will be installed to $installPath${none}"
            echo "----------------------------------------------------------------"
            echo
            break
            ;;
        *)
            echo
            echo "..the port should be between 1-65535, brother..."
            error
            ;;
        esac
    done

    if [ -d "$installPath" ]; then
        echo
        echo "Big guy...you have installed the multi-opening program marked $installNumberTag of CaoCaoMinerTaxProxy... Rerun the script to set a new one..."
        echo
        echo -e "$yellow to delete, re-run the script and select uninstall ${none}"
        echo
        exit 1
    be

    if [ -d "$oldversionInstallPath" ]; then
        rm -rf $oldversionInstallPath -f
        if [ -d "/etc/supervisor/conf/" ]; then
            rm /etc/supervisor/conf/ccminer${installNumberTag}.conf -f
            rm /etc/supervisor/conf/ccminer${installNumberTag}_gost_eth_tcp.conf -f
            rm /etc/supervisor/conf/ccminer${installNumberTag}_gost_eth_tls.conf -f
            rm /etc/supervisor/conf/ccminer${installNumberTag}_gost_etc_tcp.conf -f
            rm /etc/supervisor/conf/ccminer${installNumberTag}_gost_etc_tls.conf -f
            rm /etc/supervisor/conf/ccminer${installNumberTag}_gost_btc_tcp.conf -f
            rm /etc/supervisor/conf/ccminer${installNumberTag}_gost_btc_tls.conf -f
        elif [ -d "/etc/supervisor/conf.d/" ]; then
            rm /etc/supervisor/conf.d/ccminer${installNumberTag}.conf -f
            rm /etc/supervisor/conf.d/ccminer${installNumberTag}_gost_eth_tcp.conf -f
            rm /etc/supervisor/conf.d/ccminer${installNumberTag}_gost_eth_tls.conf -f
            rm /etc/supervisor/conf.d/ccminer${installNumberTag}_gost_etc_tcp.conf -f
            rm /etc/supervisor/conf.d/ccminer${installNumberTag}_gost_etc_tls.conf -f
            rm /etc/supervisor/conf.d/ccminer${installNumberTag}_gost_btc_tcp.conf -f
            rm /etc/supervisor/conf.d/ccminer${installNumberTag}_gost_btc_tls.conf -f
        elif [ -d "/etc/supervisord.d/" ]; then
            rm /etc/supervisord.d/ccminer${installNumberTag}.ini -f
            rm /etc/supervisord.d/ccminer${installNumberTag}_gost_eth_tcp.ini -f
            rm /etc/supervisord.d/ccminer${installNumberTag}_gost_eth_tls.ini -f
            rm /etc/supervisord.d/ccminer${installNumberTag}_gost_etc_tcp.ini -f
            rm /etc/supervisord.d/ccminer${installNumberTag}_gost_etc_tls.ini -f
            rm /etc/supervisord.d/ccminer${installNumberTag}_gost_btc_tcp.ini -f
            rm /etc/supervisord.d/ccminer${installNumberTag}_gost_btc_tls.ini -f
        be
        supervisorctl reload
    be

    log_config_ask
    eth_miner_config_ask
    etc_miner_config_ask
    btc_miner_config_ask
    http_logger_config_ask
    gost_config_ask

    if [[ "$enableEthProxy" = "n" ]] && [[ "$enableEtcProxy" = "n" ]] && [[ "$enableBtcProxy" = "n" ]]; then
        echo
        echo "Big guy...you don't enable any of them, what are you playing, quit and reinstall..."
        echo
        exit 1
    be

    print_all_config

    if [ "$confirmConfigRight" = "n" ]; then
        exit 1
    be

    if [ "$enableGostProxy" = "y" ]; then
        gost_modify_config_port
    be

    install_download
    start_write_config
}

update_version() {
    clear
    while :; do
        echo -e "Please enter the tag ID of the software to be updated. Only numbers 1-999 can be entered. This script can only update software of version 5.0 and above. Please delete other versions and reinstall them"
        read -p "$(echo -e "(input tag ID:)")" installNumberTag
        installPath="/etc/ccworker/ccworker"$installNumberTag
        case $installNumberTag in
        [1-9] | [1-9][0-9] | [1-9][0-9][0-9])
            echo
            echo
            echo -e "$yellow tag ID ${installNumberTag} of CaoCaoMinerTaxProxy will be updated ${none}"
            echo
            break
            ;;
        *)
            echo
            echo "Can you enter a tag ID?"
            error
            ;;
        esac
    done
    if [ -d "$installPath" ]; then
        echo
        echo "Big guy...I'll update you soon..."
        update_download
        echo
    else
        echo
        echo "Big guy...You haven't installed the multi-open program marked $installNumberTag of CaoCaoMinerTaxProxy... Rerun the script to set a new one..."
        echo
        exit 1
    be
}

update_download() {
    [ -d /tmp/ccminer ] && rm -rf /tmp/ccminer
    [ -d /tmp/ccworker ] && rm -rf /tmp/ccworker
    mkdir -p /tmp/ccworker
    git clone https://github.com/ccminerproxy/CC-MinerProxy -b master /tmp/ccworker/gitcode --depth=1

    if [[ ! -d /tmp/ccworker/gitcode ]]; then
        echo
        echo -e "$red oops... error in cloning script repository... $none"
        echo
        echo -e "Reminder.....Please try to install Git yourself: ${green}$cmd install -y git $none and then install this script"
        echo
        exit 1
    be
    rm -rf $installPath/ccminertaxproxy
    rm -rf $installPath/html/index.html
    rm -rf $installPath/html/index-no-tax.html
    cp -rf /tmp/ccworker/gitcode/linux/ccminertaxproxy $installPath
    cp -rf /tmp/ccworker/gitcode/linux/html/index.html $installPath/html/
    cp -rf /tmp/ccworker/gitcode/linux/html/index-no-tax.html $installPath/html/
    chmod a+x $installPath/ccminertaxproxy
    echo -e "$yellow updated successfully ${none}"
    supervisorctl reload
}

uninstall() {
    clear
    while :; do
        echo -e "Please enter the tag ID of the software to be deleted, only numbers 1-999"
        read -p "$(echo -e "(input tag ID:)")" installNumberTag
        installPath="/etc/ccworker/ccworker"$installNumberTag
        oldversionInstallPath="/etc/ccminer/ccminer"$installNumberTag
        case $installNumberTag in
        [1-9] | [1-9][0-9] | [1-9][0-9][0-9])
            echo
            echo
            echo -e "$yellow CaoCaoMinerTaxProxy with tag ID ${installNumberTag} will be uninstalled ${none}"
            echo
            break
            ;;
        *)
            echo
            echo "Can you enter a tag ID?"
            error
            ;;
        esac
    done

    if [ -d "$oldversionInstallPath" ]; then
        rm -rf $oldversionInstallPath -f
        if [ -d "/etc/supervisor/conf/" ]; then
            rm /etc/supervisor/conf/ccminer${installNumberTag}.conf -f
            rm /etc/supervisor/conf/ccminer${installNumberTag}_gost_eth_tcp.conf -f
            rm /etc/supervisor/conf/ccminer${installNumberTag}_gost_eth_tls.conf -f
            rm /etc/supervisor/conf/ccminer${installNumberTag}_gost_etc_tcp.conf -f
            rm /etc/supervisor/conf/ccminer${installNumberTag}_gost_etc_tls.conf -f
            rm /etc/supervisor/conf/ccminer${installNumberTag}_gost_btc_tcp.conf -f
            rm /etc/supervisor/conf/ccminer${installNumberTag}_gost_btc_tls.conf -f
        elif [ -d "/etc/supervisor/conf.d/" ]; then
            rm /etc/supervisor/conf.d/ccminer${installNumberTag}.conf -f
            rm /etc/supervisor/conf.d/ccminer${installNumberTag}_gost_eth_tcp.conf -f
            rm /etc/supervisor/conf.d/ccminer${installNumberTag}_gost_eth_tls.conf -f
            rm /etc/supervisor/conf.d/ccminer${installNumberTag}_gost_etc_tcp.conf -f
            rm /etc/supervisor/conf.d/ccminer${installNumberTag}_gost_etc_tls.conf -f
            rm /etc/supervisor/conf.d/ccminer${installNumberTag}_gost_btc_tcp.conf -f
            rm /etc/supervisor/conf.d/ccminer${installNumberTag}_gost_btc_tls.conf -f
        elif [ -d "/etc/supervisord.d/" ]; then
            rm /etc/supervisord.d/ccminer${installNumberTag}.ini -f
            rm /etc/supervisord.d/ccminer${installNumberTag}_gost_eth_tcp.ini -f
            rm /etc/supervisord.d/ccminer${installNumberTag}_gost_eth_tls.ini -f
            rm /etc/supervisord.d/ccminer${installNumberTag}_gost_etc_tcp.ini -f
            rm /etc/supervisord.d/ccminer${installNumberTag}_gost_etc_tls.ini -f
            rm /etc/supervisord.d/ccminer${installNumberTag}_gost_btc_tcp.ini -f
            rm /etc/supervisord.d/ccminer${installNumberTag}_gost_btc_tls.ini -f
        be
        supervisorctl reload
    be

    if [ -d "$installPath" ]; then
        echo
        echo "----------------------------------------------------------------"
        echo
        echo "Big guy... I'll delete it for you right now..."
        echo
        rm -rf $installPath -f
        if [ -d "/etc/supervisor/conf/" ]; then
            rm /etc/supervisor/conf/ccworker${installNumberTag}.conf -f
            rm /etc/supervisor/conf/ccworker${installNumberTag}_gost_eth_tcp.conf -f
            rm /etc/supervisor/conf/ccworker${installNumberTag}_gost_eth_tls.conf -f
            rm /etc/supervisor/conf/ccworker${installNumberTag}_gost_etc_tcp.conf -f
            rm /etc/supervisor/conf/ccworker${installNumberTag}_gost_etc_tls.conf -f
            rm /etc/supervisor/conf/ccworker${installNumberTag}_gost_btc_tcp.conf -f
            rm /etc/supervisor/conf/ccworker${installNumberTag}_gost_btc_tls.conf -f
        elif [ -d "/etc/supervisor/conf.d/" ]; then
            rm /etc/supervisor/conf.d/ccworker${installNumberTag}.conf -f
            rm /etc/supervisor/conf.d/ccworker${installNumberTag}_gost_eth_tcp.conf -f
            rm /etc/supervisor/conf.d/ccworker${installNumberTag}_gost_eth_tls.conf -f
            rm /etc/supervisor/conf.d/ccworker${installNumberTag}_gost_etc_tcp.conf -f
            rm /etc/supervisor/conf.d/ccworker${installNumberTag}_gost_etc_tls.conf -f
            rm /etc/supervisor/conf.d/ccworker${installNumberTag}_gost_btc_tcp.conf -f
            rm /etc/supervisor/conf.d/ccworker${installNumberTag}_gost_btc_tls.conf -f
        elif [ -d "/etc/supervisord.d/" ]; then
            rm /etc/supervisord.d/ccworker${installNumberTag}.ini -f
            rm /etc/supervisord.d/ccworker${installNumberTag}_gost_eth_tcp.ini -f
            rm /etc/supervisord.d/ccworker${installNumberTag}_gost_eth_tls.ini -f
            rm /etc/supervisord.d/ccworker${installNumberTag}_gost_etc_tcp.ini -f
            rm /etc/supervisord.d/ccworker${installNumberTag}_gost_etc_tls.ini -f
            rm /etc/supervisord.d/ccworker${installNumberTag}_gost_btc_tcp.ini -f
            rm /etc/supervisord.d/ccworker${installNumberTag}_gost_btc_tls.ini -f
        be
        echo "----------------------------------------------------------------"
        echo
        echo -e "$yellow is successfully deleted, if you want to install a new one, re-run the script to select ${none}"
        supervisorctl reload
    else
        echo
        echo "Big guy...you didn't install this tag ID at all..."
        echo
        echo -e "$yellow To install a new one, re-run the script to select ${none}"
        echo
        exit 1
    be
}

clear
while :; do
    echo
    echo "....... CaoCaoMinerTaxProxy version 7.0.0 anti-ddos cc one-click installation script & management script by Cao Cao......"
    echo
    echo "1. Install"
    echo
    echo "2. Update"
    echo
    echo "3. Uninstall"
    echo
    read -p "$(echo -e "Please choose [${magenta}1-3$none]:")" choose
    case $choose in
    1)
        install
        break
        ;;
    2)
        update_version
        break
        ;;
    3)
        uninstall
        break
        ;;
    *)
        error
        ;;
    esac
done