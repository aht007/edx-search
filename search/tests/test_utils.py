import time
from search.utils import measure_time

def test_measure_time():
    @measure_time
    def dummy_function():
        time.sleep(1)

    dummy_function()

    assert 0.9 <= dummy_function.elapsed_time <= 1.1
