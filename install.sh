#!/bin/bash

setup_kernelspec()
{
    KERNEL_NAME=$1
    SPARK_HOME=$2
    SPARK_PYPATH=$3
    PYTHON_VER=$4
    KERNEL_TPL=$5
    SCRIPT_PROFILE=$6
    PROFILE_NAME=${KERNEL_NAME}-${SCRIPT_PROFILE}

    # setup ipython profile
    ipython profile create --profile=\"${PROFILE_NAME}\"
    cp profile_script/${SCRIPT_PROFILE}/*py \
       ${HOME}/.ipython/profile_${PROFILE_NAME}/startup/ || true
    # ensure to execute after all script, renaming to zzzz_pyspark_shell.py
    cp ${SPARK_HOME}/python/pyspark/shell.py \
       ${HOME}/.ipython/profile_${PROFILE_NAME}/startup/zzzz_pyspark_shell.py

    # setup jupyter kernel
    KERNEL_PATH="/usr/local/share/jupyter/kernels/${KERNEL_NAME}"
    mkdir -p ${KERNEL_PATH}
    sed \
        -e "s;%%KERNEL_NAME%%;${KERNEL_NAME};g" \
        -e "s;%%SPARK_HOME%%;${SPARK_HOME};g" \
        -e "s;%%SPARK_PYPATH%%;${SPARK_PYPATH};g" \
        -e "s;%%PROFILE_NAME%%;${PROFILE_NAME};g" \
        kernel_template/${KERNEL_TPL} > ${KERNEL_PATH}/kernel.json

    echo "Generated kernel ${KERNEL_NAME} to ${KERNEL_PATH}/kernel.json"
}

main()
{
    while IFS=', ' read -r SPARK_VER_BIN PYTHON_VER KERNEL_TPL SCRIPT_PROFILE
    do
        # skip comment line
        [ "${SPARK_VER_BIN:0:1}" = "#" ] && continue

        echo "Installing ${SPARK_VER_BIN} ${PYTHON_VER} ..."

        # download spark pre-build binary
        wget -q http://d3kbcqa49mib13.cloudfront.net/${SPARK_VER_BIN}.tgz
        tar xzf ${SPARK_VER_BIN}.tgz -C /usr/local
        rm ${SPARK_VER_BIN}.tgz

        # setup var
        SPARK_HOME="/usr/local/${SPARK_VER_BIN}"
        PY4J_FILES=(${SPARK_HOME}/python/lib/py4j-*-src.zip)
        SPARK_PYPATH="${SPARK_HOME}/python:${PY4J_FILES[0]}"
        KERNEL_NAME=${SPARK_VER_BIN:0:11}-${PYTHON_VER}

        # setup kernel spec
        setup_kernelspec \
            ${KERNEL_NAME} \
            ${SPARK_HOME} \
            ${SPARK_PYPATH} \
            ${PYTHON_VER} \
            ${KERNEL_TPL} \
            ${SCRIPT_PROFILE}
    done < kernel.list
}

main
