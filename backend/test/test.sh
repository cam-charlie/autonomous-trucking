SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR
cd ..
source env/bin/activate
python3 test/test_graph.py
python3 test/test_env.py
python3 test/test_metric.py
mypy ./
pylint --rcfile=pylint.cfg --recursive=y simulation test
