import pyspark
conf = pyspark.SparkConf()

# set application name
conf.setAppName('MyAppName')

# set master
conf.setMaster('local[2]')

# set other options as desired
conf.set('spark.executor.cores', '2')
# conf.set('spark.executor.memory', '1g')
# conf.set('spark.driver.memory', '1g')

# create the context
sc = pyspark.SparkContext(conf=conf)
