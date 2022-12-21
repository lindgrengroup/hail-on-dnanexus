main() {
	export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
	
	start=`date +%s`
		
	#apt-get install libopenblas-dev liblapack-dev liblz4-dev -y
	#git clone https://github.com/hail-is/hail.git
	#cd hail/hail
	#sed -i 's/$(PIP) install/$(PIP) install --ignore-installed/g' Makefile
	#sed -i 's/check-pip-lockfiles/check-pip-lockfile/g' Makefile
	#make install-on-cluster HAIL_COMPILE_NATIVES=1 SCALA_VERSION=2.12.15 SPARK_VERSION=3.2.0
	
	sed '/^pyspark/d' /pinned-requirements.txt | grep -v -e '^[[:space:]]*#' -e '^$$' | tr '\n' '\0' | xargs -0 pip install --ignore-installed -U
        pip uninstall -y hail
        pip install --ignore-installed /hail-0.2.107-py3-none-any.whl --no-deps
        hailctl config set query/backend spark

	end=`date +%s`
	echo $((end-start))

	MOUNTED_HOME=/home/dnanexus
	DX_CONFIG=$MOUNTED_HOME/environment
	source $MOUNTED_HOME/environment
	export DX_PUBLIC_HOSTNAME=$(dx describe $DX_JOB_ID --json | jq -r .httpsApp.dns.url)
	source /cluster/dx-cluster.environment
	export PYTHONPATH=":$SPARK_HOME/python"
	export PYTHONPATH="$PYTHONPATH:$(echo "$SPARK_HOME/python/lib/py4j-"*"-src.zip")"

	#pip install dxdata

	HAIL_HOME=/usr/local/lib/python3.8/dist-packages/hail/backend
	PYSPARK_SUBMIT_STR="\
		--jars $HAIL_HOME/hail-all-spark.jar,/cluster/dnax/jars/dnaxfilesystem-1.0.jar \
		--conf spark.driver.extraClassPath=/cluster/dnax/jars/dnax-common-1.0.jar:/cluster/dnax/jars/dnanexus-api-0.1.0-SNAPSHOT-jar-with-dependencies.jar:/cluster/dnax/jars/dnaxspark-1.0.jar:$HAIL_HOME/hail-all-spark.jar:/cluster/dnax/jars/dnaxfilesystem-1.0.jar \
		--conf spark.executor.extraClassPath=/cluster/dnax/jars/dnax-common-1.0.jar:/cluster/dnax/jars/dnanexus-api-0.1.0-SNAPSHOT-jar-with-dependencies.jar:/cluster/dnax/jars/dnaxspark-1.0.jar:$HAIL_HOME/hail-all-spark.jar:/cluster/dnax/jars/dnaxfilesystem-1.0.jar \
	--conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
		--conf spark.kryo.registrator=is.hail.kryo.HailKryoRegistrator \
		--conf spark.executorEnv.PYTHONPATH=$PYTHONPATH"
        LOG_CONFIG_PATH="/cluster/dnax/config/log/log4j-DEBUG.properties"
        #PYSPARK_SUBMIT_STR="${PYSPARK_SUBMIT_STR} \
        #      --conf spark.executor.extraJavaOptions=-Dlog4j.configuration=file:$LOG_CONFIG_PATH \
        #      --driver-java-options -Dlog4j.configuration=file:$LOG_CONFIG_PATH"

	PYSPARK_SUBMIT_STR="${PYSPARK_SUBMIT_STR} pyspark-shell"
	export PYSPARK_SUBMIT_ARGS=${PYSPARK_SUBMIT_STR}

	export PYSPARK_PYTHON=python3.8
	export PYSPARK_DRIVER_PYTHON=python3.8

	export HOME=$MOUNTED_HOME
	export DX_PUBLIC_HOSTNAME=$(dx describe $DX_JOB_ID --json | jq -r .httpsApp.dns.url)

	pip install jupyterlab
	jupyter lab --ip=* \
		--port=443 \
		--no-browser \
		--NotebookApp.token='' \
		--NotebookApp.allow_remote_access=True \
		--NotebookApp.disable_check_xsrf=True \
		--allow-root \
		--log=INFO \
		--NotebookApp.custom_display_url=$DX_PUBLIC_HOSTNAME
}

