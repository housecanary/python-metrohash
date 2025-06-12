#!/bin/bash
set -eu
ProgName=$(basename $0)

sub_help(){
    echo "Usage: $ProgName <subcommand> [options]"
    echo ""
    echo "Subcommands:"
    echo "    build             Build containers"
    echo "    tests             Run unit tests"
    echo "    flake8            Run flake8 checks"
    echo "    tox               Run tox"
    echo "    makepackage       Create the package"
    echo "    down              Bring down the environment"
    echo ""
    echo "For help with each subcommand run:"
    echo "$ProgName <subcommand> -h|--help"
    echo ""
}

sub_build(){
    ( set -x; docker compose -f docker-compose.yml build "$@" )
}

sub_tests(){
    ( set -x; docker compose -f docker-compose.yml run --rm --no-deps tests ./runtests.sh "$@" )
}

sub_flake8(){
    ( set -x; docker compose -f docker-compose.yml run --rm --no-deps tests flake8 "$@" )
}

sub_tox(){
    ( set -x; docker compose -f docker-compose.yml run --rm --no-deps tests tox "$@" )
}

sub_makepackage(){
    ( set -x; docker compose -f docker-compose.yml run --rm --no-deps tests python3 -m build "$@")
}

sub_down(){
    ( set -x; docker compose -f docker-compose.yml down --remove-orphans "$@" )
}

function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}

if [ $# -eq 0 ]; then
    subcommand=""
else
    subcommand=$1
fi

case $subcommand in
    "" | "-h" | "--help")
        sub_help
        ;;
    *)
        shift
        subfn=sub_${subcommand}
        if ! function_exists $subfn; then
            echo "Error: '$subcommand' is not a known subcommand." >&2
            echo ""
            sub_help
            exit 1
        fi
        $subfn $@
        ;;
esac
