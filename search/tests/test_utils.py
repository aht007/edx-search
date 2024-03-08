import time
import unittest
from search.utils import measure_time


class TestUtils(unittest.TestCase):
    def test_measure_time(self):
        @measure_time
        def dummy_function():
            time.sleep(1)

        _, elapsed_time = dummy_function() 
        assert 0.9 <= elapsed_time <= 1.1
